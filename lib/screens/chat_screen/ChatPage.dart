import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rubidya/screens/profile_screen/inner_page/profile_inner_page.dart';
import '../../resources/color.dart';
import '../../services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String userId;
  final String conversationId;
  final String userName;
  final String profilePic;

  ChatPage({
    required this.userId,
    required this.conversationId,
    required this.userName,
    required this.profilePic,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  Timer? _timer;
  late IO.Socket socket;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  List<dynamic> conversationData = [];

  @override
  void initState() {
    super.initState();
    print("Initializing chat with conversationId: ${widget.conversationId}");
    fetchMessages(widget.conversationId);
    _initSocket();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    socket.dispose();
    super.dispose();
  }

  Future<void> fetchChatHistory() async {
    try {
      print("Fetching chat history");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userid');
      String? token = prefs.getString('token');

      if (userId == null || token == null) {
        throw Exception("User ID or token not found");
      }

      var data = await ChatService.getChatHistory(page: 1, limit: 10);
      print("Fetched chat history data: $data");

      setState(() {
        conversationData = data['conversationData'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching chat history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMessages(String conversationId) async {
    if (conversationId.isEmpty) {
      print("Error: conversationId is empty");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var data = await ChatService.getMessages(conversationId, page: 1, limit: 10);
      print("Fetched messages data: $data");

      if (data['messages'] != null) {
        setState(() {
          messages = List<Map<String, dynamic>>.from(data['messages']);
          messages = messages.reversed.toList();
          isLoading = false;
        });

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      } else {
        print("No messages found");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching messages: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('userid');

    print('Current user loginId: $loginId');
    if (loginId == null) {
      print("No login ID found in SharedPreferences");
      return;
    }

    // Add the message locally
    final localMessage = {
      "senderId": loginId,
      "message": message,
      "createdAt": DateTime.now().toIso8601String(),
    };

    setState(() {
      messages.add(localMessage);
      // Ensure the list view scrolls to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });

    _messageController.clear();

    try {
      var response = await ChatService.sendMessage(loginId, message, widget.userId);
      print("Message sent successfully: $response");

      // Optionally, update the local message with additional details from the server response
    } catch (e) {
      print("Error sending message: $e");

      // Remove the message from the list if there was an error
      setState(() {
        messages.remove(localMessage);
      });

      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send message: $e"),
        ),
      );
    }
  }

  Future<void> _initSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('userid');

    socket = IO.io('wss://rubidya.com', <String, dynamic>{
      'transports': ['websocket'],
      'query': {'userId': loginId},
    });

    print('Socket connection initialized with loginId: $loginId');

    socket.on('connect', (_) {
      log('Connected to Socket.IO server');
      print('Socket ID: ${socket.id}');
    });

    socket.on('newMessage', (data) {
      log('Received message: $data');
      if (data['conversationId'] == widget.conversationId) {
        setState(() {
          messages.add(data);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
        });
      }
    });

    socket.on('disconnect', (_) {
      log('Disconnected from Socket.IO server');
    });
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    final alignment = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final color = isMe ? Colors.grey[300] : Colors.green[100];
    final margin = isMe
        ? EdgeInsets.only(right: 50, top: 8, bottom: 8)
        : EdgeInsets.only(left: 50, top: 8, bottom: 8);

    var createdAt = message["createdAt"] != null
        ? DateTime.parse(message["createdAt"])
        : DateTime.now();

    var formattedDate = DateFormat.yMd().add_jms().format(createdAt);

    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Text(
              message["message"] ?? 'No message',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, messages.isNotEmpty ? messages.last : null);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Color(0xff1E3167), Color(0xE21E1889)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            title: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context,
                            messages.isNotEmpty ? messages.last : null);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  profileinnerpage(id: widget.userId),
                            ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: (widget.profilePic != null &&
                              widget.profilePic.isNotEmpty)
                              ? Image.network(
                            widget.profilePic,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8=w600-h300-pc0xffffff-pd',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  profileinnerpage(id: widget.userId),
                            ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Offline',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5)
              ],
            ),
            actions: [SizedBox(width: 20)],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final isMe =
                      messages[index]['senderId'] == widget.userId;
                  return _buildMessage(messages[index], isMe);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  color: Color(0x3AA3D4FF),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Message',
                              hintStyle: TextStyle(
                                color: Color(0xff8996BC),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/Vector.svg',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          String message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            sendMessage(message);
                          }
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: bluetext,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
