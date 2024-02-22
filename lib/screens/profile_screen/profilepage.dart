import 'package:flutter/material.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';

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
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Setting Icon',
              onPressed: () {},
            ), //IconButton
          ], //<Widget>[]
          backgroundColor: profilebg,
          // elevation: 50.0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu Icon',
            onPressed: () {
            },
          ),
        ),

      backgroundColor: profilebg,
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [

          SizedBox(height: 70,),

          Column(
            children: [
              Container(
                height: 355,
                // width: 400,
                decoration: BoxDecoration(
                    color: white,
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
                                borderRadius: BorderRadius.all(Radius.circular(100))
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
                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: buttoncolor,
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(child: Text("Verification",style: TextStyle(color: white,fontSize: 12),)),
                                ),

                                SizedBox(width: 20,),

                                Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: buttoncolor,
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Center(child: Text("Wallet",style: TextStyle(color: white,fontSize: 12),)),
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
            ],
          ),

          SizedBox(height: 01,),


          SizedBox(
            height: 500,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.0,
                          offset: Offset(1, 0),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue, // Change to your color
                      unselectedLabelColor: Colors.blue, // Change to your color
                      labelStyle: TextStyle(fontSize: 10.0),
                      tabs: [
                        Tab(text: 'Photos'),
                        Tab(text: 'Videos'),
                      ],
                    ),
                  ),
                  // Wrap the TabBarView with Expanded to fix layout issues
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // ... Your existing code for the first tab
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 20,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: const Icon(Icons.list),
                              title: Text("List item $index"),
                            );
                          },
                        ),
                        // ... Your existing code for the second tab
                        ListView.builder(
                          itemCount: 20,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: const Icon(Icons.list),
                              title: Text("List item $index"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container(
          //   height: 30,
          //   decoration: BoxDecoration(
          //     color: white,
          //       boxShadow: [
          //         BoxShadow(
          //         color: white1,
          //         blurRadius: 1.0,
          //           offset: Offset(1, 0),
          //
          //       ),]
          //   ),
          //   child: TabBar(
          //     controller: _tabController,
          //
          //     labelColor: bluetext,
          //     unselectedLabelColor: bluetext,
          //     labelStyle: TextStyle(fontSize: 10.0),
          //     tabs: [
          //       // first tab [you can add an icon using the icon property]
          //       Tab(
          //         text: 'Photos',
          //       ),
          //
          //       // second tab [you can add an icon using the icon property]
          //       Tab(
          //         text: 'Videos',
          //       ),
          //     ],
          //   ),
          // ),
          //
          // TabBarView(
          //   controller: _tabController,
          //   children: [
          //     ListView.builder(
          //         physics: const ScrollPhysics(),
          //         shrinkWrap: true,
          //
          //         itemCount: 100,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ListTile(
          //               leading: const Icon(Icons.list),
          //               trailing: const Text(
          //                 "GFG",
          //                 style: TextStyle(color: Colors.green, fontSize: 15),
          //               ),
          //               title: Text("List item $index"));
          //         }),
          //
          //     ListView.builder(
          //         itemCount: 5,
          //         physics: const ScrollPhysics(),
          //         shrinkWrap: true,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ListTile(
          //               leading: const Icon(Icons.list),
          //               trailing: const Text(
          //                 "GFG",
          //                 style: TextStyle(color: Colors.green, fontSize: 15),
          //               ),
          //               title: Text("List item $index"));
          //         }),
          //
          //   ],
          // ),

        ],
      ),

    );
  }
}


