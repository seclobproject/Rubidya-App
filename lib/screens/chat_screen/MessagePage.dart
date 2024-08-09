import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/chat_provider.dart';
import '../../services/Chat_service.dart';
import '../../services/Search_service.dart';
import 'chatpage.dart';
import 'package:intl/intl.dart';

class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key});

  @override
  ConsumerState<MessagePage> createState() => _MessageState();
}

class _MessageState extends ConsumerState<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> conversationData = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMore = true;
  late List<Map<String, dynamic>> searchlist = [];
  late List<Map<String, dynamic>> originalSearchList = [];
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider).loadContents();
    });
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    fetchChatHistory();
    _initLoad();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (hasMore && !isLoadingMore) {
          loadMoreChatHistory();
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initLoad() async {
    await _searchFollowList('');
  }

  Future<void> fetchChatHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userid');
      String? token = prefs.getString('token');
      if (userId == null || token == null) {
        throw Exception("User ID or token not found");
      }

      var data = await ChatService.getChatHistory(page: currentPage, limit: 10);
      List<dynamic> updatedConversationData = [];

      for (var conversation in data['conversationData']) {
        if (conversation['latestMessage'] == null) {
          var latestMessageData = await fetchLatestMessage(conversation['_id']);
          conversation['latestMessage'] = latestMessageData;
        }
        updatedConversationData.add(conversation);
      }

      setState(() {
        conversationData.addAll(updatedConversationData);
        isLoading = false;
        hasMore = updatedConversationData.length == 10;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadMoreChatHistory() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    currentPage++;

    try {
      var data = await ChatService.getChatHistory(page: currentPage, limit: 10);
      List<dynamic> updatedConversationData = [];

      for (var conversation in data['conversationData']) {
        if (conversation['latestMessage'] == null) {
          var latestMessageData = await fetchLatestMessage(conversation['_id']);
          conversation['latestMessage'] = latestMessageData;
        }
        updatedConversationData.add(conversation);
      }

      setState(() {
        conversationData.addAll(updatedConversationData);
        hasMore = updatedConversationData.length == 10;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchLatestMessage(String conversationId) async {
    var messages = await ChatService.getMessages(conversationId, page: 1, limit: 1);
    return messages['messages'].first;
  }

  Future<void> _searchFollowList(String query) async {
    try {
      var response = await SearchService.searchpage(search: query);
      if (mounted) {
        setState(() {
          searchlist = List<Map<String, dynamic>>.from(response['users']);
        });
      }
    } catch (e) {
      print('Error fetching search data: $e');
    }
  }

  void _onSearchTextChanged(String text) {
    _searchFollowList(text);
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toUtc();
    DateTime istDateTime = dateTime.add(Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm a').format(istDateTime);
  }

  void _updateConversation(String conversationId, Map<String, dynamic> message) {
    setState(() {
      for (var conversation in conversationData) {
        if (conversation['_id'] == conversationId) {
          conversation['latestMessage'] = message;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            collapsedHeight: 100,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E3167),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
            floating: true,
            snap: true,
            expandedHeight: screenHeight * 0.20,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: _onSearchTextChanged,
                      decoration: InputDecoration(
                          fillColor: Color(0x3AA3D4FF),
                          filled: true,
                          hintText: 'Search...',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xffA3D4FF),
                          ),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Color(0xffA7ACD0)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0x3AA3D4FF)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0x3AA3D4FF)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: const OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (searchlist.isNotEmpty && _searchController.text.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var searchResult = searchlist[index];
                  return ListTile(
                    onTap: () {
                      String? conversationId = ref
                          .read(chatProvider)
                          .getConversationId(searchResult['_id']);
                      print(
                          "=================================================$conversationId");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            conversationId: conversationId ?? '',
                            userId: searchResult['_id'] ?? '',
                            userName: searchResult['firstName'] ?? '',
                            profilePic: searchResult['profilePic'] != null
                                ? searchResult['profilePic']['filePath'] ?? ''
                                : '',
                          ),
                        ),
                      ).then((latestMessage) {
                        if (latestMessage != null) {
                          _updateConversation(
                              conversationId ?? '', latestMessage);
                        }
                      });
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: searchResult['profilePic'] != null
                            ? Image.network(
                          searchResult['profilePic']['filePath'] ?? '',
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      searchResult['firstName'] ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff1E3167)),
                    ),
                  );
                },
                childCount: searchlist.length,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var conversation = conversationData[index];
                  var latestMessage = conversation['latestMessage'] ?? {};

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            conversationId: conversation['_id'],
                            userId: conversation['userId'] ?? '',
                            userName: conversation['interactedUser'] ?? '',
                            profilePic: conversation['profilePic'] ?? '',
                          ),
                        ),
                      ).then((latestMessage) {
                        if (latestMessage != null) {
                          _updateConversation(
                              conversation['_id'], latestMessage);
                        }
                      });
                    },
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: conversation['profilePic'] != null
                              ? Image.network(
                            conversation['profilePic'] ?? '',
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        conversation['interactedUser'] ?? '',
                        style: TextStyle(
                          // fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xff1E3167)),
                      ),
                      subtitle: Text(
                        latestMessage['message'] ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff8996BC)),
                      ),
                      trailing: Text(
                        formatDateTime(latestMessage['createdAt'] ?? ''),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff8996BC)),
                      ),
                    ),
                  );
                },
                childCount: conversationData.length,
              ),
            ),
          if (isLoadingMore)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
