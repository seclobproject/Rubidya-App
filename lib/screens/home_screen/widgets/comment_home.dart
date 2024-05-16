import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../profile_screen/inner_page/profile_inner_page.dart';

class Commentbottomsheet extends StatefulWidget {
  final String id;
  const Commentbottomsheet({super.key, required this.id});

  @override
  State<Commentbottomsheet> createState() => _CommentbottomsheetState();
}

class _CommentbottomsheetState extends State<Commentbottomsheet> {
  bool isExpanded = false;
  var userid;
  var commentlist;
  var commentreplaylist;
  String? comment;
  bool _isLoading = false;
  bool showReplies = false;

  Future<void> _addComment() async {
    if (comment?.isNotEmpty ?? false) {
      setState(() {
        _isLoading = true;
      });
      var reqData = {
        'mediaId': widget.id,
        'comment': comment,
      };
      try {
        var response = await HomeService.postcomment(reqData);
        log.i('Add to Like: $response');
        await _commentGet();
        setState(() {
          comment = '';
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _DeleteMycomment(String commentId) async {
    try {
      var response = await HomeService.deletemycomment(commentId);
      log.i('Delete Comment: $response');
      Fluttertoast.showToast(
        msg: "Comment deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 14.0,
      );
      await _commentGet();
    } catch (e) {
      log.e('Error deleting comment: $e');
      Fluttertoast.showToast(
        msg: "Failed to delete comment",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> _commentGet() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await HomeService.comment(widget.id);
      setState(() {
        commentlist = response;
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }


  Future<void> _commentreplayGet() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await HomeService.commentreplay(widget.id);
      setState(() {
        commentreplaylist = response;
      });
    } catch (e) {
      print('Error fetching comments replay: $e');
    }
  }

  @override
  void initState() {
    _commentGet();
    _commentreplayGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: commentlist != null && commentlist['results'] != null && (commentlist['results'] as List).isNotEmpty
                ? ListView.builder(
              itemCount: commentlist['results'].length,
              itemBuilder: (context, index) {
                bool isMyComment = commentlist['results'][index]['isMyComment'] ?? false;
                String profilePicUrl = commentlist['results'][index]['profilePic'] ?? '';
                bool isValidUrl = Uri.tryParse(profilePicUrl)?.isAbsolute ?? false;
                List<dynamic> replies = commentlist['results'][index]['replies'] ?? [];

                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isValidUrl)
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProfileInnerPage(
                                //       id: commentlist['results'][index]['userId'],
                                //     ),
                                //   ),
                                // );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(profilePicUrl),
                                radius: 20,
                              ),
                            ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commentlist['results'][index]['firstName'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  commentlist['results'][index]['comment'] ?? '',
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                          if (isMyComment)
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Comment?'),
                                      content: Text('Delete this comment?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            _DeleteMycomment(commentlist['results'][index]['commentId']);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.delete, size: 20, color: Colors.red),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  width: 300,
                                  height: 106,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Write your reply here...',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Implement reply logic here
                                              Navigator.pop(context);
                                            },
                                            child: Text('Reply'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          "Reply",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReplies = !showReplies;
                          });
                        },
                        child: Text(
                          showReplies ? "-------Hide replies" : "-------View replies",
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),
                      ),
                      if (showReplies)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int replyIndex) {
                            return ListTile(
                              leading: const Icon(Icons.reply),
                              title: Text("helloo"),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            )
                : Center(
              child: Text("No comments available"),
            ),
          ),
          SizedBox(height: 16),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox(),
          _isLoading
              ? SizedBox()
              : TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: buttoncolor),
                onPressed: () async {
                  if (comment?.isNotEmpty ?? false) {
                    await _addComment();
                  }
                },
              ),
            ),
            onChanged: (text) {
              setState(() {
                comment = text;
              });
            },
          ),
        ],
      ),
    );
  }
}