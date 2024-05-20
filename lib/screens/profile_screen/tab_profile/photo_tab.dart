import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';


class phototab extends StatefulWidget {
  const phototab({super.key});

  @override
  State<phototab> createState() => _phototabState();
}

class _phototabState extends State<phototab> {


  var userid;
  var profilelist;
  bool isLoading = false;



  var userId;
  var profileDetails;
  bool _isLoading = true;
  bool isExpanded = false;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    _initLoad();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
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
      if (profilelist == null) {
        profilelist = response;
      } else {
        profilelist['media'].addAll(response['media']);
      }
    });
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
    return profilelist != null && profilelist['media'] != null
        ? GridView.builder(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: profilelist['media'].length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: GestureDetector(
            onTap: () {
              List<dynamic> imageUrls =
              profilelist['media'].map((item) => item['filePath']).toList();
              int selectedIndex = index;
              _showFullScreenImage(context, imageUrls, selectedIndex, profilelist);
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 112,
                    height: 300,
                    child: Image.network(
                      profilelist['media'][index]['filePath'],
                      fit: BoxFit.fill, // Use BoxFit.cover to stretch and maintain aspect ratio
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
                        profilelist['media'][index]['likeCount'].toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      )
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
                        '200', // This is a placeholder, should be replaced with dynamic data
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      )
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
}





void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls, int initialIndex,dynamic profilelist) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Using a ScrollController to manage the scroll position
      ScrollController scrollController = ScrollController(initialScrollOffset: initialIndex * 650.0); // Assuming image height is 600. Adjust as needed.

      return Scaffold(
        appBar: AppBar(
          title: Text("Posts",style: TextStyle(fontSize: 14),),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    // Handle double tap here
                    child: Container(
                      // height: 610,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onDoubleTap: () {},
                                child: Row(
                                  children: [
                                    SizedBox(width: 60),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profilelist['media'][index]['firstName'],
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                        // Text(
                                        //   profilelist['media'][index]['userId']['lastName'],
                                        //   style: TextStyle(fontSize: 11, color: Colors.grey),
                                        // ),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(Icons.more_vert, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => profileinnerpage(
                                  //       id: widget.userId,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent, // Set background color to transparent
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          child: Image.network(
                                            profilelist['media'][index]['profilePic'],
                                            height: 51,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 28,
                                        left: 28,
                                        child: Image.asset('assets/image/verificationlogo.png'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.scaleDown,
                              // height: 400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
                            child: Row(
                              children: [
                                // FavoriteButton(
                                //   iconSize: 40,
                                //   isFavorite: widget.likeCount,
                                //   iconDisabledColor: Colors.black26,
                                //   valueChanged: (_) {
                                //     widget.onLikePressed(); // Call the callback function when like button is pressed
                                //   },
                                // ),
                                SizedBox(width: 10),
                                Text("Likes", style: TextStyle(color: Colors.blue, fontSize: 10)),
                                SizedBox(width: 2),
                                Text(
                                  profilelist['media'][index]['likeCount'].toString(), // Convert int to String
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Expanded(child: SizedBox()),
                                SvgPicture.asset(
                                  "assets/svg/comment.svg",
                                  height: 20,
                                ),
                                SizedBox(width: 20),
                                SvgPicture.asset(
                                  "assets/svg/share.svg",
                                  height: 20,
                                ),
                                SizedBox(width: 20),
                                SvgPicture.asset(
                                  "assets/svg/save.svg",
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: Container(
                          //     height: isExpanded ? null : 40, // Adjust height when expanded
                          //     child: Text(
                          //       widget.description,
                          //       maxLines: isExpanded ? null : 2,
                          //       style: TextStyle(fontSize: 11),
                          //     ),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       isExpanded = !isExpanded;
                          //     });
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 10),
                          //     child: Align(
                          //       alignment: Alignment.bottomRight,
                          //       child: Text(
                          //         isExpanded ? 'See Less' : 'See More',
                          //         style: TextStyle(color: bluetext,fontSize: 8),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 50,)
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
    },
  );
}