import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Commentbottomsheet extends StatefulWidget {
  final String id;
  const Commentbottomsheet({super.key,required this.id});

  @override
  State<Commentbottomsheet> createState() => _commentState();
}

class _commentState extends State<Commentbottomsheet> {


  bool isExpanded = false;
  var userid;
  var commentlist;
  String? comment;
  bool _isLoading = false;



  Future<void> _addComment() async {
    if (comment?.isNotEmpty ?? false) {
      setState(() {
        _isLoading = true; // Show loader when posting comment
      });

      var reqData = {
        'mediaId': widget.id,
        'comment': comment,
      };

      try {
        var response = await HomeService.postcomment(reqData);
        log.i('Add to Like: $response');

        // After posting comment successfully, fetch updated comments
        await _commentGet();

        setState(() {
          comment = ''; // Clear the comment field
          _isLoading = false; // Hide loader after comment is posted
        });
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loader if there's an error
        });
        // Handle error here
      }
    }
  }



  Future<void> _DeleteMycomment() async {
    try {
      var response = await HomeService.deletemycomment(commentlist['results'][0]['commentId']);
      log.i('Delete Comment: $response');

      // Show toast message after successful deletion
      Fluttertoast.showToast(
        msg: "Comment deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 14.0,
      );

      // Refresh comment list after deletion
      await _commentGet();
    } catch (e) {
      // Handle error
      log.e('Error deleting comment: $e');
      // Optionally show an error toast message here
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

        print(commentlist['results'][0]['commentId']);
        print(commentlist['results'][0]['isMyComment']);

      });
    } catch (e) {
      // Handle error
      print('Error fetching comments: $e');
    }
  }


  @override
  void initState() {
    _commentGet();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric( vertical: 24),
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
          child: commentlist != null &&
              commentlist['results'] != null &&
              (commentlist['results'] as List).isNotEmpty
              ? ListView.builder(
            itemCount: commentlist['results'].length,
            itemBuilder: (context, index) {
              bool isMyComment = commentlist['results'][index]['isMyComment'] ?? false;
              String profilePicUrl = commentlist['results'][index]['profilePic'] ?? '';

              // Check if profilePicUrl is a valid URL
              bool isValidUrl = Uri.tryParse(profilePicUrl)?.isAbsolute ?? false;

              return ListTile(
                  leading: isValidUrl
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(profilePicUrl),
                    radius: 30, // Adjust the radius as needed
                  )
                      : Text(""),
                title: Text(
                  commentlist['results'][index]['firstName'] ?? '',
                ),
                subtitle: Text(
                  commentlist['results'][index]['comment'] ?? '',
                ),
                trailing: isMyComment
                    ? GestureDetector(
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
                                _DeleteMycomment(); // Assuming this method exists
                                Navigator.pop(context);
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 50,
                      child: Icon(Icons.delete, size: 20, color: buttoncolor)),
                )
                    : null,
              );
            },
          )
              : Center(
            child: Text(""),
          ),
        ),



        SizedBox(height: 16),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox(), // Show loader widget if _isLoading is true
          _isLoading
              ? SizedBox() // Hide TextField when loading
              : TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              hintStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                comment = text; // Update the comment text as the user types
              });
            },
          ),
        ],
      ),
    );
  }
}
