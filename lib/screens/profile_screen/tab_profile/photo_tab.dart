import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import '../../home_screen/widgets/comment_home.dart';

class PhotoTab extends StatefulWidget {
  const PhotoTab({super.key});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  var userId;
  var profileList;
  var homeList;
  bool isLoading = false;
  bool _isLoading = true;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initLoad();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  Future<void> _ProfileImage({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response = await ProfileService.getProfileimage(page: page);
    log.i('Profile Image Loading........: $response');
    setState(() {
      if (profileList == null) {
        profileList = response;
      } else {
        profileList['media'].addAll(response['media']);
      }
    });
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  Future<void> _initLoad() async {
    await _ProfileImage();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _pageNumber++;
      isLoading = true;
    });
    await _ProfileImage(page: _pageNumber);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return profileList != null && profileList['media'] != null
        ? GridView.builder(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
            ),
            itemCount: profileList['media'].length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    List<dynamic> imageUrls = profileList['media']
                        .map((item) => item['filePath'])
                        .toList();
                    int selectedIndex = index;
                    _showFullScreenImage(context, imageUrls, selectedIndex,
                        profileList, homeList);
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 112,
                          height: 300,
                          child: Image.network(
                            profileList['media'][index]['filePath'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 78,
                        left: 30,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/heart.svg",
                              height: 18,
                            ),
                            Text(
                              profileList['media'][index]['likeCount']
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 78,
                        right: 30,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/coment2.svg",
                              height: 18,
                            ),
                            Text(
                              profileList['media'][index]['commentCount']
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    "No images available",
                    style: TextStyle(color: Colors.black),
                  ),
          );
  }

// void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls, int initialIndex, dynamic profileList) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       ScrollController scrollController = ScrollController(initialScrollOffset: initialIndex * 650.0);
//
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("Posts", style: TextStyle(fontSize: 14)),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 controller: scrollController,
//                 itemCount: imageUrls.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onDoubleTap: () {
//                       _toggleLike(index, profileList['media'][index]['_id']);
//                     },
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Stack(
//                             children: [
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       // Navigate to profile inner page
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Stack(
//                                         children: [
//                                           Container(
//                                             height: 40,
//                                             width: 40,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.transparent,
//                                             ),
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.all(Radius.circular(100)),
//                                               child: Image.network(
//                                                 profileList['media'][index]['profilePic'],
//                                                 height: 51,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: 28,
//                                             left: 28,
//                                             child: Image.asset('assets/image/verificationlogo.png'),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 20),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         profileList['media'][index]['firstName'],
//                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   ),
//                                   Expanded(child: SizedBox()),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                                     child: Icon(Icons.more_vert, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Container(
//                             decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
//                             child: Image.network(
//                               imageUrls[index],
//                               fit: BoxFit.scaleDown,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onDoubleTap: () {
//                                         _toggleLike(index, profileList['media'][index]['_id']);
//                                       },
//                                       child: Icon(
//                                         profileList['media'][index]['isLiked'] ?? false
//                                             ? Icons.favorite
//                                             : Icons.favorite_border,
//                                         color: profileList['media'][index]['isLiked'] ?? false
//                                             ? Colors.red
//                                             : Colors.grey,
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     SvgPicture.asset(
//                                       "assets/svg/comment.svg",
//                                       height: 20,
//                                     ),
//                                     SizedBox(width: 20),
//                                     SvgPicture.asset(
//                                       "assets/svg/save.svg",
//                                       height: 20,
//                                     ),
//                                     Expanded(child: SizedBox()),
//                                     SvgPicture.asset(
//                                       "assets/svg/share.svg",
//                                       height: 20,
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text("Likes", style: TextStyle(color: Colors.blue, fontSize: 10)),
//                                     Text(
//                                       profileList['media'][index]['likeCount'].toString(),
//                                       style: TextStyle(
//                                         color: Colors.blue,
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     SizedBox(width: 2),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           SizedBox(height: 50),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
}

class FullScreenImageDialog extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;
  final dynamic profileList;
  final dynamic homeList;

  FullScreenImageDialog({
    required this.imageUrls,
    required this.initialIndex,
    required this.profileList,
    required this.homeList,
  });

  @override
  _FullScreenImageDialogState createState() => _FullScreenImageDialogState();
}

class _FullScreenImageDialogState extends State<FullScreenImageDialog> {
  late ScrollController scrollController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(initialScrollOffset: widget.initialIndex * 650.0);
  }

  void _toggleLikePost(int index, String postId) {
    setState(() {
      // Find the post once and store it in a variable
      var post = widget.profileList['media']
          .firstWhere((post) => post['_id'] == postId, orElse: () => null);

      if (post != null) {
        bool isLiked = post['isLiked'] ??
            false; // Ensure isLiked is treated as a bool and not null
        post['isLiked'] = !isLiked;
        post['likeCount'] =
            (post['likeCount'] ?? 0) + (post['isLiked'] ? 1 : -1);
      }
    });

    // Call _addLike only if the post exists
    var post = widget.profileList['media']
        .firstWhere((post) => post['_id'] == postId, orElse: () => null);
    if (post != null) {
      _addLike(postId, post['isLiked']);
    }
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  void _showComments(BuildContext context, String postId) {
    showModalBottomSheet<void>(
      backgroundColor: white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0)
              .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CommentBottomSheet(id: postId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts", style: TextStyle(fontSize: 14)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onDoubleTap: () {
                    _toggleLikePost(
                        index, widget.profileList['media'][index]['_id']);
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to profile inner page
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Image.network(
                                              widget.profileList['media'][index]
                                                  ['profilePic'],
                                              height: 51,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 28,
                                          left: 28,
                                          child: Image.asset(
                                              'assets/image/verificationlogo.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.profileList['media'][index]
                                          ['firstName'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child:
                                      Icon(Icons.more_vert, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0))),
                          child: Image.network(
                            widget.imageUrls[index],
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 23, top: 10, left: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _toggleLikePost(
                                          index,
                                          widget.profileList['media'][index]
                                              ['_id']);
                                    },
                                    child: Image.asset(
                                      widget.profileList['media'][index]
                                                  ['isLiked'] ??
                                              false
                                          ? 'assets/image/rubred.png'
                                          : 'assets/image/rubblack.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        backgroundColor: white,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          late Map<String, dynamic>? homeList;
                                          return Padding(
                                            padding: const EdgeInsets.all(20.0)
                                                .copyWith(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                            child: CommentBottomSheet(
                                                id: widget.profileList['media']
                                                    [index]['_id']),
                                          );
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svg/comment.svg",
                                      height: 20,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SvgPicture.asset(
                                    "assets/svg/save.svg",
                                    height: 20,
                                  ),
                                  Expanded(child: SizedBox()),
                                  SvgPicture.asset(
                                    "assets/svg/share.svg",
                                    height: 20,
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text("Likes",
                              //         style: TextStyle(
                              //             color: Colors.blue, fontSize: 10)),
                              //     Text(
                              //       widget.profileList['media'][index]
                              //               ['likeCount']
                              //           .toString(),
                              //       style: TextStyle(
                              //         color: Colors.blue,
                              //         fontSize: 13,
                              //         fontWeight: FontWeight.w700,
                              //       ),
                              //     ),
                              //     SizedBox(width: 2),
                              //   ],
                              // ),

                              SizedBox(height: 10,),


                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: bluetext,
                                        fontSize: 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Liked by ",
                                          style: TextStyle(),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.profileList['media'][index]['likeCount'].toString()}",
                                          style: TextStyle(
                                            color: bluetext,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " and",
                                          style: TextStyle(
                                            color: bluetext,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                      "${widget.profileList['media'][index]['lastLikedUserName'].toString()} Others ",
                                      style: TextStyle(
                                          color: bluetext,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(width: 2),
                                ],
                              ),

                              InkWell(

                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      backgroundColor: white,
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        late Map<String, dynamic>? homeList;
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0)
                                              .copyWith(
                                              bottom:
                                              MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: CommentBottomSheet(
                                              id: widget.profileList['media']
                                              [index]['_id']),
                                        );
                                      },
                                    );
                                  },
                                child: Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: bluetext,
                                          fontSize: 12,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "View All",
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text("${widget.profileList['media'][index]['commentCount'].toString()} Comments ",
                                        style: TextStyle(
                                          color: bluetext,
                                          fontSize: 13,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              height: isExpanded ? null : 40,
                              // Adjust height when expanded
                              child: Text(
                                widget.profileList['media'][index]
                                    ['description'],
                                maxLines: isExpanded ? null : 2,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        if (widget.profileList['media'][index]['description']
                                .split('\n')
                                .length >
                            2) // Check for multiline
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded =
                                    !isExpanded; // Toggle the isExpanded state
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  isExpanded ? 'See Less' : 'See More',
                                  style:
                                      TextStyle(color: bluetext, fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls,
    int initialIndex, dynamic profileList, dynamic homeList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FullScreenImageDialog(
            imageUrls: imageUrls,
            initialIndex: initialIndex,
            profileList: profileList,
            homeList: homeList,
          ),
        ),
      );
    },
  );
}
