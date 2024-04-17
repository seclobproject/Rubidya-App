import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:rubidya/screens/profile_screen/widget/edit_profile.dart';
import 'package:rubidya/screens/profile_screen/widget/followers_list.dart';
import 'package:rubidya/screens/profile_screen/widget/following_list.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidya_premium.dart';
import 'package:rubidya/screens/profile_screen/widget/verification_page.dart';
import 'package:rubidya/screens/profile_screen/widget/wallet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../authentication_page/login_page.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

import '../../home_screen/widgets/referral_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'dart:io';


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




  Future _profileimgget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.Profileinnerpage(widget.id);
    log.i('profile statsus show.. $response');
    setState(() {
      profileinnerpageshow = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _profileimgget()

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
          (profileinnerpageshow?['result']?[0]['firstName'] ??
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Container(
              height: 300,
              // width: 400,
              decoration: BoxDecoration(
                  color: profilebg,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(84),
                      topRight: Radius.circular(84))),

              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      top: -40.0,
                      right: 25,
                      child: Column(
                        children: [
                          // Container(
                          //   height: 86,
                          //   width: 86,
                          //   decoration: BoxDecoration(
                          //     color: bluetext,
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(100)),
                          //   ),
                          //   child: ClipOval(
                          //     child: Image.asset(
                          //       'assets/logo/logo3.png',
                          //       fit: BoxFit.cover,
                          //       width: 86,
                          //       // Set the width to match the container's width
                          //       height:
                          //           86, // Set the height to match the container's height
                          //     ),
                          //   ),
                          // ),

                          Stack(children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 20, // Set a specific height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.blue, // Example background color
                              ),
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                width: 90,
                                height: 90,
                                child: profileinnerpageshow != null &&
                                    profileinnerpageshow?['result'][0]['profilePic'] != null &&
                                    profileinnerpageshow?['result'][0]['profilePic']
                                    ['filePath'] !=
                                        null
                                    ? Image.network(
                                  '$baseURL/' +
                                      profileinnerpageshow?['result'][0]['profilePic']['filePath'],
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

                            // Container(
                            //   height: 150,
                            //   width: 300,
                            //   child: imageUrl != null
                            //       ? Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            //     child: Image.file(File(imageUrl!)),
                            //   )
                            //       : Container(), // This will render an empty container if imageUrl is null
                            // ),
                          ]),

                          SizedBox(
                            height: 5,
                          ),

                          Text(
                            (profileinnerpageshow?['result']?[0]['firstName'] ??
                                'loading...'),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: bluetext),
                          ),

                          // Text(
                          //   (profiledetails?['user']?['lastName'] ?? 'loading...'),
                          //   style: TextStyle(color: bluetext,fontSize: 10,
                          //       fontWeight: FontWeight.w500),),
                          SizedBox(
                            height: 10,
                          ),
                      //    profileinnerpageshow?['user']?['bio'] ??
                          Text(
                            ('helloo'),
                            style: TextStyle(
                                color: bluetext,
                                fontSize: 12,
                                fontWeight: FontWeight.w200),
                            textAlign:
                            TextAlign.center, // Center-align the text
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: gradnew,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                child: Center(
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                          color: white, fontSize: 12),
                                    )),
                              ),

                              SizedBox(width: 20,),

                              Container(
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    color: lightblue,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                child: Center(
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                          color: g2button, fontSize: 12),
                                    )),
                              )

                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            width: 345.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [grad1, grad2],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
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
                                      (profileinnerpageshow?['result']?[0]['post'].toString() ??
                                          'loading...'), // Default value if 'post' or its parent keys are null
                                      style: TextStyle(
                                        fontSize: 15,
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
                                      Text((profileinnerpageshow?['result']?[0]['followers'].toString() ??
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
                                      Text((profileinnerpageshow?['result']?[0]['following'].toString() ??
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

                          SizedBox(
                            height: 12,
                          ),


                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
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
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 112,
                          height: 200,
                          child: Image.network(
                            '$baseURL/' + profileinnerpageshow['result'][index]['media'] [index]['filePath'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 85,
                        left: 30,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/heart.svg",
                              height: 18,
                            ),
                            Text(
                              '0',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 85,
                        right: 30,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/coment2.svg",
                              height: 18,
                            ),
                            Text(
                              "200",
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
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
