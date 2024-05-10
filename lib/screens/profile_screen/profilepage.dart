// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rubidya/services/home_service.dart';
// import 'package:rubidya/screens/profile_screen/inner_page/profile_inner_page.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../resources/color.dart';
// import '../support/logger.dart';
// import 'package:favorite_button/favorite_button.dart';
//
// class Homepages extends StatefulWidget {
//   const Homepages({Key? key}) : super(key: key);
//
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepages> {
//   var userId;
//   var profileDetails;
//   var homeList;
//   bool isLoading = false;
//   bool _isLoading = true;
//   bool isExpanded = false;
//   int _pageNumber = 1;
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     _initLoad();
//     _scrollController.addListener(_scrollListener);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       _loadMore();
//     }
//   }
//
//   Future<void> _homeFeed({int page = 1}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString('userId');
//     var response = await HomeService.getFeed(page: page);
//     log.i('Home feed data: $response');
//     setState(() {
//       if (homeList == null) {
//         homeList = response;
//       } else {
//         homeList['posts'].addAll(response['posts']);
//       }
//     });
//   }
//
//   Future<void> _initLoad() async {
//     await _homeFeed();
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _loadMore() async {
//     setState(() {
//       _pageNumber++;
//       isLoading = true;
//     });
//     await _homeFeed(page: _pageNumber);
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   String _calculateTimeDifference(String createdAt) {
//     DateTime createdDateTime = DateTime.parse(createdAt);
//     Duration difference = DateTime.now().difference(createdDateTime);
//
//     if (difference.inDays > 0) {
//       return '${difference.inDays} days ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hours ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minutes ago';
//     } else {
//       return 'just now';
//     }
//   }
//
//   void _toggleLikePost(String postId) {
//     setState(() {
//       bool isLiked = !homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked'];
//       homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked'] = isLiked;
//       int likeCount = homeList['posts'].firstWhere((post) => post['_id'] == postId)['likeCount'];
//       homeList['posts'].firstWhere((post) => post['_id'] == postId)['likeCount'] = isLiked ? likeCount + 1 : likeCount - 1;
//     });
//     _addLike(postId, homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked']);
//   }
//
//   Future<void> _addLike(String postId, bool isLiked) async {
//     var reqData = {
//       'postId': postId,
//       'isLiked': isLiked,
//     };
//     var response = await HomeService.like(reqData);
//     log.i('Add to Like: $response');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Feed'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           : ListView.builder(
//         controller: _scrollController,
//         itemCount: homeList != null && homeList['posts'] != null ? homeList['posts'].length : 0,
//         itemBuilder: (BuildContext context, int index) {
//           if (index == homeList['posts'].length - 1) {
//             return Column(
//               children: [
//                 ProductCard(
//                   createdTime: _calculateTimeDifference(homeList['posts'][index]['createdAt']),
//                   name: homeList['posts'][index]['username'] ?? '',
//                   description: homeList['posts'][index]['description'] ?? '',
//                   likes: homeList['posts'][index]['likeCount']?.toString() ?? '',
//                   img: homeList['posts'][index]['filePath'] ?? '',
//                   profilepic: homeList['posts'][index]['filePath'] ?? '',
//                   id: homeList['posts'][index]['_id'] ?? '',
//                   userId: homeList['posts'][index]['userId'] ?? '',
//                   likeCount: homeList['posts'][index]['isLiked'] ?? false,
//                   onLikePressed: () {
//                     _toggleLikePost(homeList['posts'][index]['_id']);
//                   },
//                   onDoubleTapLike: () {
//                     _toggleLikePost(homeList['posts'][index]['_id']);
//                   },
//                 ),
//                 if (isLoading)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircularProgressIndicator(),
//                   ),
//               ],
//             );
//           } else {
//             return ProductCard(
//               createdTime: _calculateTimeDifference(homeList['posts'][index]['createdAt']),
//               name: homeList['posts'][index]['username'] ?? '',
//               description: homeList['posts'][index]['description'] ?? '',
//               likes: homeList['posts'][index]['likeCount']?.toString() ?? '',
//               img: homeList['posts'][index]['filePath'] ?? '',
//               profilepic: homeList['posts'][index]['filePath'] ?? '',
//               id: homeList['posts'][index]['_id'] ?? '',
//               userId: homeList['posts'][index]['userId'] ?? '',
//               likeCount: homeList['posts'][index]['isLiked'] ?? false,
//               onLikePressed: () {
//                 _toggleLikePost(homeList['posts'][index]['_id']);
//               },
//               onDoubleTapLike: () {
//                 _toggleLikePost(homeList['posts'][index]['_id']);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
//
// class ProductCard extends StatefulWidget {
//   const ProductCard({
//     Key? key,
//     required this.img,
//     required this.profilepic,
//     required this.name,
//     required this.likes,
//     required this.createdTime,
//     required this.id,
//     required this.userId,
//     required this.likeCount,
//     required this.description,
//     required this.onLikePressed,
//     required this.onDoubleTapLike,
//   }) : super(key: key);
//
//   final String img;
//   final String name;
//   final String createdTime;
//   final String id;
//   final String userId;
//   final String likes;
//   final String profilepic;
//   final String description;
//   final bool likeCount;
//
//   final VoidCallback onLikePressed;
//   final VoidCallback onDoubleTapLike;
//
//   @override
//   _ProductCardState createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   bool isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onDoubleTap: widget.onDoubleTapLike, // Handle double tap here
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               InkWell(
//                 onDoubleTap: () {},
//                 child: Row(
//                   children: [
//                     SizedBox(width: 60),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.name,
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                         ),
//                         Text(
//                           widget.createdTime,
//                           style: TextStyle(fontSize: 11, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                     Expanded(child: SizedBox()),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Icon(Icons.more_vert, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => profileinnerpage(
//                         id: widget.userId,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.transparent, // Set background color to transparent
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(Radius.circular(100)),
//                           child: Image.network(
//                             'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
//                             height: 51,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 28,
//                         left: 28,
//                         child: Image.asset('assets/image/verificationlogo.png'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Container(
//             decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Image.network(
//               widget.img,
//               fit: BoxFit.fill,
//               // height: 400,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
//             child: Row(
//               children: [
//                 FavoriteButton(
//                   iconSize: 40,
//                   isFavorite: widget.likeCount,
//                   iconDisabledColor: Colors.black26,
//                   valueChanged: (_) {
//                     widget.onLikePressed(); // Call the callback function when like button is pressed
//                   },
//                 ),
//                 SizedBox(width: 10),
//                 Text("Likes", style: TextStyle(color: Colors.blue, fontSize: 10)),
//                 SizedBox(width: 2),
//                 Text(widget.likes, style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
//                 SizedBox(width: 2),
//                 Expanded(child: SizedBox()),
//                 SvgPicture.asset(
//                   "assets/svg/comment.svg",
//                   height: 20,
//                 ),
//                 SizedBox(width: 20),
//                 SvgPicture.asset(
//                   "assets/svg/share.svg",
//                   height: 20,
//                 ),
//                 SizedBox(width: 20),
//                 SvgPicture.asset(
//                   "assets/svg/save.svg",
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10,),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Container(
//               height: isExpanded ? null : 40, // Adjust height when expanded
//               child: Text(
//                 widget.description,
//                 maxLines: isExpanded ? null : 2,
//                 style: TextStyle(fontSize: 11),
//               ),
//             ),
//           ),
//
//           if (widget.description.split('\n').length > 2) // Check for multiline
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isExpanded = !isExpanded; // Toggle the isExpanded state
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//                     isExpanded ? 'See Less' : 'See More',
//                     style: TextStyle(color: bluetext, fontSize: 8),
//                   ),
//                 ),
//               ),
//             ),
//
//
//
//
//           SizedBox(height: 15,)
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:rubidya/screens/profile_screen/widget/edit_profile.dart';
import 'package:rubidya/screens/profile_screen/widget/followers_list.dart';
import 'package:rubidya/screens/profile_screen/widget/following_list.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/my_wallet.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/verification_page.dart';
import '../../resources/color.dart';
import '../home_screen/widgets/referral_page.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication_page/login_page.dart';

import '../../services/profile_service.dart';
import '../../support/logger.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentIndex = 0;


  late TabController _tabController;

  var userid;
  var profiledetails;
  var profilepagestatus;
  var profileimgshow;
  var postcount;
  bool isLoading = false;
  bool _isLoading = true;
  String? imageUrl;

  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future _postcount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfileimage();
    log.i('post count data Show.. $response');
    setState(() {
      postcount = response; // This line is causing the error
    });
  }

  Future _profilestatussapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.profilestatus();
    log.i('profile statsus show.. $response');
    setState(() {
      profilepagestatus = response;
    });
  }

  Future _profileimgget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.ProfileImageget();
    log.i('profile statsus show.. $response');
    setState(() {
      profileimgshow = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
        _profileimgget(),
        _profilestatussapi(),
        _postcount()
      ],
    );
    _isLoading = false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => login()), (route) => false);
  }

  // Future<void> uploadImage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userid = (prefs.getString('userid') ?? "");
  //   try {
  //     if (imageUrl == null) {
  //       print("Please pick an image first");
  //       return;
  //     }
  //     FormData formData = FormData.fromMap({
  //       'media': await MultipartFile.fromFile(imageUrl!),
  //     });
  //     var response = await ProfileService.verificationimage(formData);
  //     if (response.statusCode == 201) {
  //       print("Image uploaded successfully");
  //       print(response.data);
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(builder: (context) => Bottomnav()),
  //       // );
  //     } else {
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(builder: (context) => Bottomnav()),
  //       // );
  //       print(response.statusCode);
  //       print(response.data);
  //     }
  //   } catch (e) {
  //     print("Exception during image upload: $e");
  //   }
  // }



  Future<void> _refresh() async {
    await _profiledetailsapi();
    await _profileimgget();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {

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
    return DefaultTabController(
      initialIndex: _currentIndex,
      length: 2,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            ("Profile"),
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[

            InkWell(
              onTap: (){
                // Share.share("https://rubidya.com/register/$userid");

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  referralpage()),
                );



                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) =>  MyHomePages()),
                // );

              },
              child: SvgPicture.asset(
                "assets/svg/reffer.svg",
              ),
            ),


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
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/settings.svg",
                                      height: 14,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Setting and privacy',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: bluetext,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/saved.svg",
                                      height: 14,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Saved',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: bluetext,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/ads.svg",
                                      height: 14,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Ads',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: bluetext,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),

                            SizedBox(
                              height: 100,
                            ),
                            InkWell(
                              onTap: () {
                                logout();
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  height: 40,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      color: bluetext),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/logout.svg",
                                            height: 14,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Logout",
                                            style: TextStyle(color: white),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [grad1, grad2],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Icon(Icons.more_horiz),
                ),
              ),
            ), //IconButton
          ],
          //<Widget>[]
          backgroundColor: white,

        ),
        body: Column(
          children: [

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
                          child: Container(
                            width: 90,
                            height: 90,
                            child: profileimgshow != null &&
                                profileimgshow['profilePic'] != null &&
                                profileimgshow['profilePic']
                                ['filePath'] !=
                                    null
                                ? Image.network(
                              profileimgshow['profilePic']
                              ['filePath'],
                              fit: BoxFit.cover,
                            )
                                : Center(
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: grad2,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100))),
                                child: Center(
                                    child: Text(
                                      "No Img",
                                      style: TextStyle(color: greybg),
                                    )),
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
                            postcount != null && postcount['postCount'] != null
                                ? postcount['postCount'].toString()
                                : '0', // Default value if postcount or postCount is null
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

                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FollowersList()));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text((profiledetails?['user']?['followersCount'].toString() ??
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
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FollowingList()));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text((profiledetails?['user']?['followingCount'].toString() ??
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
            SizedBox(height: 10,),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      (profiledetails?['user']?['firstName'] ??
                          'loading...'),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: bluetext),
                    ),
                  ),
                ),
                SizedBox(width: 5,),

                Text(
                  (profiledetails?['user']?['lastName'] ??
                      'loading...'),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: bluetext),
                ),
              ],
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                    (profiledetails?['user']?['bio'] ?? ''),
                    style: TextStyle(
                        color: bluetext,
                        fontSize: 12,
                        fontWeight: FontWeight.w200),
                    textAlign:
                    TextAlign.center, // Center-align the text
                    overflow: TextOverflow.ellipsis,
                    maxLines:3
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => editprofile(
                          bio: profiledetails['user']['bio'] ?? "",
                          firstname: profiledetails['user']
                          ['firstName'] ??
                              "",
                          lastName: profiledetails['user']
                          ['lastName'] ??
                              "",
                          countryCode: profiledetails['user']
                          ['countryCode']
                              ?.toString() ??
                              "",
                          phone: profiledetails['user']['phone']
                              ?.toString() ??
                              "",
                          email:
                          profiledetails['user']['email'] ?? "",
                          // dateOfBirth: profiledetails['user']
                          //         ['updatedDOB'] ??
                          //     "",
                          gender: profiledetails['user']
                          ['gender'] ??
                              "",
                          location: profiledetails['user']
                          ['location'] ??
                              "",
                          profession: profiledetails['user']
                          ['profession'] ??
                              "",
                          district: profiledetails['user']
                          ['district'] ??
                              "",
                        ),
                      ));
                    },
                    child: Container(
                      height: 31,
                      width: 110,
                      decoration: BoxDecoration(
                          color: conainer220,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10))),
                      child: Center(
                          child: Text(
                            "Edit profile",
                            style: TextStyle(
                                fontSize: 10, color: bluetext),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 31,
                    width: 110,
                    decoration: BoxDecoration(
                        color: conainer220,
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text(
                          "Contact",
                          style:
                          TextStyle(fontSize: 10, color: bluetext),
                        )),
                  ),

                  SizedBox(
                    width: 10,
                  ),




                  // profiledetails?['user']['isVerified'] == true
                  //     ? InkWell(
                  //   onTap: () {
                  //     // Navigator.of(context).push(
                  //     //     MaterialPageRoute(
                  //     //         builder: (context) =>
                  //     //             wallet()));
                  //     Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 MyWallet()));
                  //   },
                  //   child: Container(
                  //     height: 31,
                  //     width: 110,
                  //     decoration: BoxDecoration(
                  //         color: blueshade,
                  //         borderRadius: BorderRadius.all(
                  //             Radius.circular(10))),
                  //     child: Center(
                  //         child: Text(
                  //           "Wallet",
                  //           style: TextStyle(
                  //               color: white, fontSize: 12),
                  //         )),
                  //   ),
                  // )
                  //     : InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 Verification()));
                  //   },
                  //   child: Container(
                  //     height: 31,
                  //     width: 110,
                  //     decoration: BoxDecoration(
                  //         color: blueshade,
                  //         borderRadius: BorderRadius.all(
                  //             Radius.circular(10))),
                  //     child: Center(
                  //         child: Text(
                  //           "Wallet",
                  //           style: TextStyle(
                  //               color: white, fontSize: 12),
                  //         )),
                  //   ),
                  // ),

                  InkWell(
                    onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyWallet()));
                    },
                    child: Container(
                      height: 31,
                      width: 110,
                      decoration: BoxDecoration(
                          color: blueshade,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10))),
                      child: Center(
                          child: Text(
                            "Wallet",
                            style: TextStyle(
                                color: white, fontSize: 12),
                          )),
                    ),
                  ),



                ],
              ),
            ),


            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBar(
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            'Photo',
                            style: TextStyle(fontSize: 12), // Adjust the font size as needed
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Video',
                            style: TextStyle(fontSize: 12), // Adjust the font size as needed
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height - 400,
                      child: TabBarView(
                        // physics: NeverScrollableScrollPhysics(), // Prevent swiping
                        children: [
                          phototab(),
                          vediotab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







