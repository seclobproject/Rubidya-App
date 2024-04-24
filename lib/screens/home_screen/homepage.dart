// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../resources/color.dart';
//
// class homepage extends StatefulWidget {
//   const homepage({super.key});
//
//   @override
//   State<homepage> createState() => _homepageState();
// }
//
// class _homepageState extends State<homepage> {
//
//   bool isFavorite = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             SizedBox(height: 50,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset(
//                   'assets/logo/logo2.png',
//                   fit: BoxFit.cover,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: SvgPicture.asset(
//                     "assets/svg/notification.svg",
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 15,),
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Container(
//                 height: 92,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 0.1,
//                       blurRadius: 5,
//                       offset: Offset(0,1),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(0),
//                     bottomRight: Radius.circular(0),
//                     bottomLeft: Radius.circular(10),
//                     topLeft: Radius.circular(10),
//                   ),
//                 ),
//                 child: Container(
//                   height: 92,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: 20,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                         child: Column(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(36),
//                                 topLeft: Radius.circular(36),
//                                 bottomLeft: Radius.circular(10),
//                                 bottomRight: Radius.circular(36),
//                               ),
//                               child: Image.network(
//                                 'https://assets.vogue.in/photos/5d288836e2f0130008fa5d30/1:1/w_1080,h_1080,c_limit/model%20nidhi%20sunil.jpg',
//                                 height: 51,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(height: 10,),
//                             Text("Samuel", style: TextStyle(fontSize: 8),)
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 10,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Container(
//                       width: 345,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 0.1,
//                             blurRadius: 5,
//                             offset: Offset(0, 1),
//                           ),
//                         ],
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                       child: Column(
//                         children: [
//                           Stack(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 child: Row(
//                                   children: [
//                                     Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: Stack(
//                                         children: [
//                                           Container(
//                                             height: 40,
//                                             width: 40,
//                                             child: ClipRRect(
//                                               borderRadius: BorderRadius.all(Radius.circular(100)),
//                                               child: Image.network(
//                                                 'https://stimg.cardekho.com/images/carexteriorimages/930x620/Skoda/Octavia/7514/1607588488757/front-left-side-47.jpg',
//                                                 height: 51,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                               top: 28,
//                                               left: 28,
//                                               child: Image.asset('assets/image/verificationlogo.png')
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 10,),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text("Samuel", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
//                                         Text("5h ago", style: TextStyle(fontSize: 9, color: Colors.grey)),
//                                       ],
//                                     ),
//                                     Expanded(child: SizedBox()),
//                                     Icon(Icons.more_vert, color: Colors.grey,),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10,),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(Radius.circular(10))
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 child: Image.network('https://images.carandbike.com/car-images/large/skoda/octavia/skoda-octavia.jpg?v=28',
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 15),
//                             child: Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.favorite,
//                                     color: Colors.red,
//                                     size: 25,
//                                   ),
//                                   onPressed: () {
//                                     // Handle like button tap
//                                   },
//                                 ),
//                                 Text("Liked by", style: TextStyle(color: Colors.blue, fontSize: 10)),
//                                 SizedBox(width: 2,),
//                                 Text("Faizal", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
//                                 SizedBox(width: 2,),
//                                 Text("78 others", style: TextStyle(color: Colors.blue, fontSize: 10)),
//                                 Expanded(child: SizedBox()),
//                                 SvgPicture.asset(
//                                   "assets/svg/comment.svg",
//                                   height: 20,
//                                 ),
//                                 SizedBox(width: 20,),
//                                 SvgPicture.asset(
//                                   "assets/svg/share.svg",
//                                   height: 20,
//                                 ),
//                                 SizedBox(width: 20,),
//                                 SvgPicture.asset(
//                                   "assets/svg/save.svg",
//                                   height: 20,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
// }



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/home_screen/widgets/home_feed.dart';
import 'package:rubidya/screens/home_screen/widgets/home_follow.dart';
import 'package:rubidya/screens/home_screen/widgets/home_story.dart';
import 'package:rubidya/screens/home_screen/widgets/referral_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commonpage/test.dart';
import '../../networking/constant.dart';
import '../../services/home_service.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../profile_screen/inner_page/profile_inner_page.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool isFavorite = false;
  var userid;
  var profiledetails;
  var profilelist;
  var suggestfollow;
  bool isLoading = false;
  bool _isLoading = true;
  late YoutubePlayerController _controller;


  bool isFollowing = false;
  void toggleFollow() {
    setState(() {
      if (isFollowing) {
        isFollowing = false;
        print("follow");
      } else {
        isFollowing = true;
        print("unfollow");
      }
    });
  }

  Future _profileapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfileimage();
    log.i('profile data Show.. $response');
    setState(() {
      profilelist = response; // This line is causing the error
    });
  }


  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future _homefeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await HomeService.getFeed();
    log.i('homefeed data Show.. $response');
    setState(() {
      profilelist = response; // This line is causing the error
    });
  }


  Future _suggestfollowlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await HomeService.usersuggetionlistfollow();
    log.i('refferal details show.. $response');
    setState(() {
      suggestfollow = response;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
        _profileapi(),
        _suggestfollowlist(),
        _homefeed()
      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    _controller = YoutubePlayerController(
      initialVideoId: 'dpm2FUS8oWU', // Use only the video ID here
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
      ),
    );
    super.initState();
  }

  Future<void> _refresh() async {
    await _profiledetailsapi();
    await _profileapi();
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.1,
        backgroundColor: Colors.white,
      ),

      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor : AlwaysStoppedAnimation(bluetext),
        ),
      )
          :RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(right:20),
                    child: Row(

                      children: [
                        Image.asset(
                          'assets/logo/logo4.png',
                          fit: BoxFit.cover,
                          width: 150,
                        ),
                        Expanded(child: SizedBox()),


                        SizedBox(width: 20,),

                        InkWell(
                          onTap: (){
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) =>  HomeFeeds()),
                            // );
                          },
                          child: SvgPicture.asset(
                            "assets/svg/massage.svg",
                          ),
                        ),
                        SizedBox(width: 20,),

                        SvgPicture.asset(
                          "assets/svg/notification.svg",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      height: 109,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.1,
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Container(

                        child: homestory(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("New People",style: TextStyle(fontWeight: FontWeight.w500,color: bluetext),)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 160,
                      child: HomeFollow()
                    ),
                  ),


                  SizedBox(height: 15,),

                  HomeFeed()
                ],
              ),
            ),
          ),
    );
  }
}


