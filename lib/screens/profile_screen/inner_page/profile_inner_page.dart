import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:rubidya/screens/profile_screen/widget/edit_profile.dart';
import 'package:rubidya/screens/profile_screen/widget/followers_list.dart';
import 'package:rubidya/screens/profile_screen/widget/following_list.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/rubidya_premium.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/verification_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../authentication_page/login_page.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

import '../../home_screen/widgets/referral_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'follower_inner_list.dart';
import 'following_inner_list.dart';


class profileinnerpage extends StatefulWidget {
   profileinnerpage({super.key,required this.id});

  String? id;

  @override
  State<profileinnerpage> createState() => _profileinnerpageState();
}

class _profileinnerpageState extends State<profileinnerpage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  var userid;
  var profileinnerpageshow;
  var profilepagestatus;
  var profileimgshow;
  var postcount;
  bool isLoading = false;
  bool _isLoading = true;
  String? imageUrl;
  var followCount;
  bool isFollowing = false;
  final fallbackImageUrl = 'https://pbs.twimg.com/media/CidJXBuUUAEgAYu.jpg';



  void _toggleFollow() async {
    // Toggle the follow status
    setState(() {
      isFollowing = !isFollowing;
    });

    if (isFollowing) {
      await _Follow();
      // Update followCount if follow is successful
      setState(() {
        followCount = true;
      });
    } else {
      await _UnFollow();
      // Update followCount if unfollow is successful
      setState(() {
        followCount = false;
      });
    }
  }



  Future _profileInner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.Profileinnerpage(widget.id);

    if (response != null && response['media'] != null) {
      // Accessing 'isFollowing' directly from the response
      bool initialFollowStatus = response['media'][0]['isFollowing'];

      // Set the initial follow status
      setState(() {
        isFollowing = initialFollowStatus;
        profileinnerpageshow = response;
      });
    }
  }



  Future _Follow() async {
    var reqData = {
      'followerId': widget.id,
    };
    var response = await HomeService.follow(reqData);
    log.i('add to Follow. $response');

  }

  Future _UnFollow() async {
    var reqData = {
      'followerId': widget.id,
    };
    var response = await HomeService.unfollow(reqData);
    log.i('add to UnFollow. $response');

  }


  Future _initLoad() async {
    await Future.wait(
      [
        _profileInner(),

      ],
    );
    _isLoading = false;
  }


  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _initLoad();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          (profileinnerpageshow?['media']?[0]['firstName'] ??
              'loading...'),
          style: TextStyle(fontSize: 14),
        ),
        actions: <Widget>[



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          )),
                      height: 400.0,
                      child: Column(
                        children: [

                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.more_horiz),
            ),
          ), //IconButton
        ],
        //<Widget>[]
        backgroundColor: white,
        // elevation: 50.0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   tooltip: 'Menu Icon',
        //   onPressed: () {
        //
        //   },
        // ),
      ),
      backgroundColor: white,
      body:  _isLoading
          ? Center(
        child: CircularProgressIndicator(), // Display circular indicator while loading
      )
          :SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: profileinnerpageshow != null &&
                              profileinnerpageshow['media'] != null &&
                              profileinnerpageshow['media'].isNotEmpty &&
                              profileinnerpageshow['media'][0]['profilePic'] != null
                              ? SizedBox(
                            width: 90,  // Set a fixed width for the image container
                            height: 90,
                            child: Image.network(
                              profileinnerpageshow['media'][0]['profilePic'],
                              fit: BoxFit.contain,
                            ),
                          )
                              : Center(
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: grad2,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  "No Img",
                                  style: TextStyle(color: greybg),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                    ),

                  ],
                ),


                Container(
                  width: 250.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            (profileinnerpageshow?['media']?[0]['post'].toString() ??
                                'loading...'),// Default value if postcount or postCount is null
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: bluetext,
                            ),
                          ),
                          Text("Post",
                              style: TextStyle(
                                  fontSize: 10, color: bluetext))
                        ],
                      ),
                      InkWell(
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Followerinnerlist(
                                id: widget.id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text((profileinnerpageshow?['media']?[0]['followers'].toString() ??
                                'loading...'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: bluetext)),
                            Text("Followers",
                                style: TextStyle(
                                    fontSize: 10, color: bluetext))
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Followinginnerpage(
                                id: widget.id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text((profileinnerpageshow?['media']?[0]['following'].toString() ??
                                'loading...'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: bluetext)),
                            Text(
                              "Following",
                              style: TextStyle(
                                  fontSize: 10, color: bluetext),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (profileinnerpageshow?['media']?[0]['firstName'] ??
                          'loading...'),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: bluetext),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    (profileinnerpageshow?['media']?[0]['lastName'] ??
                        'loading...'),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: bluetext),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  (profileinnerpageshow?['media']?[0]['bio'] ??
                      'loading...'),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: bluetext),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,

                ),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _toggleFollow,
                    child: Container(
                      height: 31,
                      width: 180,
                      decoration: BoxDecoration(
                          color: bluetext,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10))),
                      child: Center(
                          child: Text(
                              isFollowing ? "Unfollow" : "Follow",
                            style: TextStyle(
                                fontSize: 10, color: white),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),


                  Container(
                    height: 31,
                    width: 150,
                    decoration: BoxDecoration(
                        color: conainer220,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text(
                          "Message",
                          style:
                          TextStyle(fontSize: 10, color: bluetext),
                        )),
                  ),

                  SizedBox(
                    width: 10,
                  ),




                  // Container(
                  //   height: 31,
                  //   width: 110,
                  //   decoration: BoxDecoration(
                  //       color: blueshade,
                  //       borderRadius: BorderRadius.all(
                  //           Radius.circular(10))),
                  //   child: Center(
                  //       child: Text(
                  //         "Wallet",
                  //         style: TextStyle(
                  //             color: white, fontSize: 12),
                  //       )),
                  // ),

                ],
              ),
            ),



            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 0,
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(color: white, boxShadow: [
                BoxShadow(
                  color: white1,
                  blurRadius: 1.0,
                  offset: Offset(1, 0),
                ),
              ]),
              child: TabBar(
                controller: _tabController,
                labelColor: bluetext,
                unselectedLabelColor: bluetext,
                labelStyle: TextStyle(fontSize: 10.0),
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Photos',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Videos',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1000,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // phototab(),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

              child: profileinnerpageshow != null && profileinnerpageshow['media'] != null
                  ?GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: profileinnerpageshow['media'].length,
                itemBuilder: (BuildContext context, int index) {


                  return GestureDetector(
                    onTap: () {
                      List<dynamic> imageUrls = profileinnerpageshow['media'].map((item) => item['filePath']).toList();
                      int selectedIndex = index; // This is the index of the tapped image
                      _showFullScreenImage(context, imageUrls, selectedIndex,profileinnerpageshow);
                    },

                    child: Stack(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 112,
                            height: 300,
                            child: profileinnerpageshow['media'] != null &&
                                profileinnerpageshow['media'][index] != null &&
                                profileinnerpageshow['media'][index]['filePath'] != null
                                ? Image.network(
                              profileinnerpageshow['media'][index]['filePath'],
                              fit: BoxFit.fill,
                            )
                                : Image.network('https://pbs.twimg.com/media/CidJXBuUUAEgAYu.jpg')
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
                                profileinnerpageshow['media'][index]['likeCount'].toString(),
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
                                '200',
                                style: TextStyle(fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Center(
                // Show a placeholder or message when there is no data
                child: Text("No data available",style: TextStyle(color: textblack),),
              ),

              ),
                  vediotab()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls, int initialIndex,dynamic profileinnerpageshow) {
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
                                          profileinnerpageshow['media'][index]['firstName'],
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                          child: profileinnerpageshow['media'][index]['profilePic'] != null
                                              ? Image.network(
                                            profileinnerpageshow['media'][index]['profilePic'],
                                            height: 51,
                                            fit: BoxFit.cover,
                                          )
                                              : Container(
                                            width: 51,
                                            height: 51,
                                            color: Colors.grey, // Placeholder color or provide a custom placeholder widget
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
                            child: imageUrls[index] != null
                                ? Image.network(
                              imageUrls[index],
                              fit: BoxFit.scaleDown,
                            )
                                : Container(
                              color: Colors.grey, // Placeholder container color
                              child: Center(
                                child: Image.network('https://pbs.twimg.com/media/CidJXBuUUAEgAYu.jpg')
                              ),
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
                                  profileinnerpageshow['media'][index]['likeCount'].toString(), // Convert int to String
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
                          SizedBox(height: 15,)
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



