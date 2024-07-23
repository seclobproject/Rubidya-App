import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/Chat_service.dart';
import 'ChatPage.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}
class _MessageState extends State<MessagePage> with
    SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> conversationData = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchChatHistory();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future<void> fetchChatHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userid');
      String? token = prefs.getString('token');
      if (userId == null || token == null) {
        throw Exception("User ID or token not found");
      }
      var data = await ChatService.getChatHistory(page: 1, limit: 10);
      setState(() {
        conversationData = data['conversationData'];
        isLoading = false;
      });
    } catch (e) {
// Handle error appropriately
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            collapsedHeight: 180,
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
          isLoading
              ? SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                var conversation = conversationData[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userId: conversation['_id'],
                          userName: conversation['interactedUser'],
                          profilePic: conversation['profilePic'],
                          conversationId: conversation['_id'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: conversation['profilePic'] != null
                            ? Image.network(
                          conversation['profilePic'],
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/default_avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      conversation['interactedUser'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff1E3167)),
                    ),
                    subtitle: Text(
                      'Last message...',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff8996BC)),
                    ),
                    trailing: Text(
                      'Time',
                      style: TextStyle(
                          color: Color(0xffAEAEAE),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
              childCount: conversationData.length,
            ),
          ),
        ],
      ),
    );
  }
}