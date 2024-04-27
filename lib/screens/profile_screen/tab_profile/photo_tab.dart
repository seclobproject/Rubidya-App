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


  Future _profileapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfileimage();
    log.i('profile data Show.. $response');
    setState(() {
      profilelist = response; // This line is causing the error
    });
  }



  Future _initLoad() async {
    await Future.wait(
      [
        _profileapi()
      ],
    );
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initLoad();
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: profilelist != null && profilelist['media'] != null
          ? GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: profilelist['media'].length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<dynamic> imageUrls = profilelist['media'].map((item) => item['filePath']).toList();
              int selectedIndex = index; // This is the index of the tapped image
              _showFullScreenImage(context, imageUrls, selectedIndex);
            },

            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 112,
                    height: 250,
                    child: Image.network(
                       profilelist['media'][index]['filePath'],
                      fit: BoxFit.cover,
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
                        "200",
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
    );

  }
}


// void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls, int initialIndex) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       // Using a ScrollController to manage the scroll position
//       ScrollController scrollController = ScrollController(initialScrollOffset: initialIndex * 300.0); // Assuming image height is 600. Adjust as needed.
//
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("Posts",style: TextStyle(fontSize: 14),),
//         ),
//         body: Column(
//           children: [
//           Expanded(
//             child: ListView.builder(
//             controller: scrollController,
//             itemCount: imageUrls.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: Center(
//                   child: Image.network(
//                     imageUrls[index],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//                     ),
//           ),
//           ],
//         ),
//       );
//     },
//   );
// }


void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls, int initialIndex) {
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
                      height: 610,
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
                                          "kkkkk",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "12635656",
                                          style: TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
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
                                            'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
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
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                              height: 500,
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
                                Text('1', style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
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


