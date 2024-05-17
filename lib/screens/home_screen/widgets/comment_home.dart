import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../profile_screen/inner_page/profile_inner_page.dart';

class CommentBottomSheet extends StatefulWidget {
  final String id;
  const CommentBottomSheet({super.key, required this.id});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool isExpanded = false;
  var userid;
  List<dynamic> commentList = [];
  String? comment;
  String? replaycomment;
  bool _isLoading = false;
  bool showReplies = false;
  List<bool> showRepliesList = [];

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
        log.i('Add Comment: $response');
        await _fetchComments();
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

  Future<void> _addreplayComment() async {
    if (replaycomment?.isNotEmpty ?? false) {
      setState(() {
        _isLoading = true;
      });
      var reqData = {
        'commentId': commentList[0]['commentId'],
        'comment': replaycomment,
      };
      try {
        var response = await HomeService.postreplaycomment(reqData);
        log.i('Add Reply Comment: $response');
        await _fetchComments();
        setState(() {
          replaycomment = '';
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
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
      await _fetchComments();
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

  Future<void> _fetchComments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await HomeService.comment(widget.id);

      if (response['status'] == '01' && response['msg'] == 'Success') {
        setState(() {
          commentList = response['results'] ?? [];
          showRepliesList = List<bool>.filled(commentList.length, false);

          // Assuming you want the first postId
          if (commentList.isNotEmpty) {
            String postId = commentList[0]['postId'];
            print('First postId: $postId');
          }
        });
      } else {
        print('Failed to fetch comments: ${response['msg']}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComments().then((_) {
      setState(() {
        showRepliesList = List<bool>.filled(commentList.length, false);
      });
    });
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
            child: commentList.isNotEmpty
                ? ListView.builder(
              itemCount: commentList.length,
              itemBuilder: (context, index) {
                var commentItem = commentList[index];
                bool isMyComment = commentItem['isMyComment'] ?? false;
                String profilePicUrl = commentItem['profilePic'] ?? '';
                bool isValidUrl = Uri.tryParse(profilePicUrl)?.isAbsolute ?? false;
                List<dynamic> replies = commentItem['replyComment'] ?? [];

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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => profileinnerpage(
                                      id: commentItem['userId'],
                                    ),
                                  ),
                                );
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
                                  commentItem['firstName'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(commentItem['comment'] ?? ''),
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
                                            _deleteComment(commentItem['commentId']);
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
                                  height: 50,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _isLoading ? Center(child: CupertinoActivityIndicator())
                                          : SizedBox(),
                                      !_isLoading
                                          ? TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Write your reply here...',
                                          hintStyle: TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w600),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.send, color: buttoncolor),
                                            onPressed: () async {
                                              if (replaycomment?.isNotEmpty ?? false) {
                                                await _addreplayComment();
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            replaycomment = text;
                                          });
                                        },
                                      )
                                          : SizedBox(),
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
                            showRepliesList[index] = !showRepliesList[index];
                          });
                        },
                        child: Visibility(
                          visible: replies.isNotEmpty, // Only show if there are replies
                          child: Text(
                            showRepliesList[index] ? "-------Hide replies" : "-------View replies",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ),
                      ),
                      if (showRepliesList[index])
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: replies.length,
                          itemBuilder: (BuildContext context, int replyIndex) {
                            var replyItem = replies[replyIndex];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                child: Image.network(
                                  'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                replyItem['userId']['firstName'],
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black),
                              ),
                              subtitle: Text(
                                replyItem['comment'] ?? '',
                                style: TextStyle(fontSize: 10),
                              ),
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
          _isLoading ? Center(child: CupertinoActivityIndicator()) : SizedBox(),
          !_isLoading
              ? TextField(
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
          )
              : SizedBox(),
        ],
      ),
    );
  }
}
