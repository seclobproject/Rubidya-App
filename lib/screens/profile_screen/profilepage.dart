import 'package:flutter/material.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/widget/verification_page.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/widget/wallet.dart';

import '../../resources/color.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> with TickerProviderStateMixin{

  late TabController _tabController;



  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: const Text("Rayan_Photographer_",style: TextStyle(fontSize: 12),),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
               height: 40,
                width: 40,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [grad1, grad2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),
                child: Icon(Icons.more_horiz),
              ),
            ), //IconButton
          ], //<Widget>[]
          backgroundColor: white,
          // elevation: 50.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: 'Menu Icon',
            onPressed: () {

            },
          ),
        ),


      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 70,),

            Container(
              height: 355,
              // width: 400,
              decoration: BoxDecoration(
                  color: profilebg,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(84),
                      topRight: Radius.circular(84)
                  )),

              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      top: -40.0,
                      right: 25,
                      child: Column(
                        children: [
                          Container(
                            height: 86,
                            width: 86,
                            decoration: BoxDecoration(
                              color: bluetext,
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://burst.shopifycdn.com/photos/model-in-gold-fashion.jpg?width=1000&format=pjpg&exif=0&iptc=0',
                                fit: BoxFit.cover,
                                width: 86,  // Set the width to match the container's width
                                height: 86, // Set the height to match the container's height
                              ),
                            ),
                          ),


                          SizedBox(height: 10,),

                          Text("Rayan Moon",
                            style: TextStyle(color: bluetext,fontSize: 14,
                                fontWeight: FontWeight.w500),) ,

                          Text("Photographer",
                            style: TextStyle(color: bluetext,fontSize: 10,
                                fontWeight: FontWeight.w500),),
                          SizedBox(height: 10,),

                          Text(
                            "📸 Capturing life's moments, one click at a time | Visual\nstoryteller with a passion for authenticity | Exploring the \nworld through my lens | Turning emotions into pixels \n| #PhotographyAdventures 🌍✨",
                            style: TextStyle(
                              color: bluetext,
                              fontSize: 10,
                              fontWeight: FontWeight.w200
                            ),
                            textAlign: TextAlign.center, // Center-align the text
                          ),

                          SizedBox(height: 20,),

                          Row(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification()));
                                },
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: buttoncolor,
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(child: Text("Verify Account",style: TextStyle(color: white,fontSize: 12),)),
                                ),
                              ),

                              SizedBox(width: 20,),

                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => wallet()));
                                },
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: blueshade,
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(child: Text("Wallet",style: TextStyle(color: white,fontSize: 12),)),
                                ),
                              ),
                            ],
                          ),

                      SizedBox(height: 20,),

                      Container(
                        width: 345.0,
                        height: 64.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [grad1, grad2],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10)
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10,),
                                Text("50",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: bluetext),),
                                Text("Post",style: TextStyle(fontSize: 10,color:bluetext ))
                              ],
                            ),
                            Column(

                              children: [
                                SizedBox(height: 10,),
                                Text("564",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: bluetext)),
                                Text("Followers",style: TextStyle(fontSize: 10,color:bluetext ))
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: 10,),
                                Text("564",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: bluetext)),
                                Text("Following",style: TextStyle(fontSize: 10,color:bluetext ),)
                              ],
                            ),
                          ],
                        ),
                      ),

                          SizedBox(height: 12,),

                          Row(
                            children: [
                              Container(
                                height: 31,
                                width: 165,
                                decoration: BoxDecoration(
                                  color: conainer220,
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Center(child: Text("Edit profile",style: TextStyle(fontSize: 10,color: bluetext),)),
                              ),
                              SizedBox(width: 15,),
                              Container(
                                height: 31,
                                width: 165,
                                decoration: BoxDecoration(
                                    color: conainer220,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Center(child: Text("Contact",style: TextStyle(fontSize: 10,color: bluetext),)),
                              ),
                            ],
                          ),

                        ],
                      )
                  ),


                ],
              ),
            ),


            Container(
              height: 30,
              decoration: BoxDecoration(
                color: white,
                  boxShadow: [
                    BoxShadow(
                    color: white1,
                    blurRadius: 1.0,
                      offset: Offset(1, 0),

                  ),]
              ),
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
              height: 600,
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

    );
  }
}



