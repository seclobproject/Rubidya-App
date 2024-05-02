import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:rubidya/screens/profile_screen/widget/edit_profile.dart';
import 'package:rubidya/screens/profile_screen/widget/followers_list.dart';
import 'package:rubidya/screens/profile_screen/widget/following_list.dart';
import 'package:rubidya/screens/profile_screen/widget/my_wallet.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidya_premium.dart';
import 'package:rubidya/screens/profile_screen/widget/verification_page.dart';
import 'package:rubidya/screens/profile_screen/widget/wallet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication_page/login_page.dart';
import '../../authentication_page/splash.dart';
import '../../commonpage/test.dart';
import '../../networking/constant.dart';
import '../../resources/color.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../home_screen/widgets/referral_page.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage>
    with TickerProviderStateMixin {
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

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _refresh() async {
    await _profiledetailsapi();
    await _profileimgget();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _initLoad();
    // _postcount();
    // _profiledetailsapi(); _profileimgget(); _profilestatussapi();

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
      backgroundColor: white,
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
              SizedBox(
                height: 40,
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
                      Align(
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




                    profiledetails?['user']['isVerified'] == true
                        ? InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             wallet()));
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
                    )
                        : InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Verification()));
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

              // Container(
              //   height: 300,
              //
              //   decoration: BoxDecoration(
              //       color: profilebg,
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(84),
              //           topRight: Radius.circular(84))),
              //
              //   child: Stack(
              //     clipBehavior: Clip.none,
              //     children: [
              //       Positioned(
              //           top: -40.0,
              //           right: 25,
              //           child: Column(
              //             children: [
              //               Stack(children: [
              //                 Container(
              //                   margin: EdgeInsets.only(top: 20),
              //                   height: 20, // Set a specific height
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(16.0),
              //                     color: Colors.blue, // Example background color
              //                   ),
              //                 ),
              //
              //
              //               ]),
              //
              //
              //              // old subcription
              //               // Row(
              //               //   children: [
              //               //     profiledetails?['user']['isVerified'] == false
              //               //         ? Container(
              //               //             height: 40,
              //               //             width: 130,
              //               //             decoration: BoxDecoration(
              //               //                 color: greybg,
              //               //                 borderRadius: BorderRadius.all(
              //               //                     Radius.circular(20))),
              //               //             child: Center(
              //               //                 child: Text(
              //               //               "Subscription",
              //               //               style: TextStyle(
              //               //                   color: white, fontSize: 12),
              //               //             )),
              //               //           )
              //               //         : GestureDetector(
              //               //             onTap: () {
              //               //               Navigator.of(context).push(
              //               //                   MaterialPageRoute(
              //               //                       builder: (context) =>
              //               //                           premiumpage()));
              //               //             },
              //               //             child: Container(
              //               //               height: 40,
              //               //               width: 130,
              //               //               decoration: BoxDecoration(
              //               //                   color: buttoncolor,
              //               //                   borderRadius: BorderRadius.all(
              //               //                       Radius.circular(20))),
              //               //               child: Center(
              //               //                   child: Text(
              //               //                 "Subscription",
              //               //                 style: TextStyle(
              //               //                     color: white, fontSize: 12),
              //               //               )),
              //               //             ),
              //               //           ),
              //               //     SizedBox(
              //               //       width: 20,
              //               //     ),
              //               //
              //               //   ],
              //               // ),
              //
              //             ],
              //           )),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),


             // oldpackage

              // SizedBox(
              //   height: 65,
              //   child: ListView.builder(
              //     itemCount: profilepagestatus != null &&
              //             profilepagestatus.containsKey('memberProfits')
              //         ? profilepagestatus['memberProfits'].length
              //         : 0,
              //     // Check if profilepagestatus is not null and contains 'memberProfits'
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 SizedBox(
              //                   height: 5,
              //                 ),
              //                 Container(
              //                   width: 175,
              //                   decoration: BoxDecoration(
              //                     border: Border.all(color: yellowborder),
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5)),
              //                   ),
              //                   child: Column(
              //                     children: [
              //                       SizedBox(
              //                         height: 5,
              //                       ),
              //                       Text(
              //                         profilepagestatus != null &&
              //                                 profilepagestatus
              //                                     .containsKey('memberProfits')
              //                             ? profilepagestatus['memberProfits']
              //                                 [index]['packageName']
              //                             : '',
              //                         // Check again before accessing nested keys
              //                         style: TextStyle(
              //                             fontSize: 12, color: yellowborder1),
              //                       ),
              //                       Row(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.center,
              //                         mainAxisAlignment: MainAxisAlignment.center,
              //                         children: [
              //                           Column(
              //                             children: [
              //                               Text(
              //                                 "Members",
              //                                 style: TextStyle(fontSize: 10),
              //                               ),
              //                               Text(
              //                                 profilepagestatus != null &&
              //                                         profilepagestatus
              //                                             .containsKey(
              //                                                 'memberProfits')
              //                                     ? profilepagestatus[
              //                                                 'memberProfits']
              //                                             [index]['usersCount']
              //                                         .toString()
              //                                     : '',
              //                                 // Check again before accessing nested keys
              //                                 style: TextStyle(fontSize: 12),
              //                               ),
              //                             ],
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.symmetric(
              //                                 vertical: 5),
              //                             child: VerticalDivider(
              //                               color: Colors.black,
              //                               thickness: .2,
              //                             ),
              //                           ),
              //                           Column(
              //                             children: [
              //                               Text(
              //                                 "Amount",
              //                                 style: TextStyle(
              //                                   fontSize: 10,
              //                                 ),
              //                               ),
              //                               Text(
              //                                 profilepagestatus != null &&
              //                                         profilepagestatus
              //                                             .containsKey(
              //                                                 'memberProfits')
              //                                     ? profilepagestatus[
              //                                                 'memberProfits']
              //                                             [index]['splitAmount']
              //                                         .toString()
              //                                     : '',
              //                                 // Check again before accessing nested keys
              //                                 style: TextStyle(
              //                                   fontSize: 12,
              //                                   fontWeight: FontWeight.w700,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: 15,
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
                    phototab(),
                    vediotab()
                  ],
                ),
              ),
            ],
                    ),
                  ),
          ),
    );
  }
}
