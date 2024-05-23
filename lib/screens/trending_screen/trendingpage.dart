// import 'package:flutter/material.dart';
// import 'package:rubidya/resources/color.dart';
// import 'package:rubidya/screens/trending_screen/widget/topSixThisallGridview.dart';
// import 'package:rubidya/screens/trending_screen/widget/topSixThisdayGridview.dart';
// import 'package:rubidya/screens/trending_screen/widget/topSixThismonthGridview.dart';
// import 'package:rubidya/screens/trending_screen/widget/topSixThisweekGridview.dart';
// import 'package:rubidya/screens/trending_screen/widget/trending_list.dart';
// import 'package:rubidya/services/trending_service.dart';
// import 'package:rubidya/support/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../home_screen/widgets/referral_page.dart';
//
// class TrendingPage extends StatefulWidget {
//   @override
//   _TrendingPageState createState() => _TrendingPageState();
// }
//
// class _TrendingPageState extends State<TrendingPage> {
//   var userid;
//   var trendingprice;
//   var trendingcardprice;
//   var trendingpoint;
//   bool _isLoading = true;
//   String _selectedDropdownValue = 'This Week';
//   var status = 'month';
//
//   Future _trendingdetailsapi() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString('userid');
//     var response = await TrendingService.tendingapi();
//     log.i('trending details show.. $response');
//     setState(() {
//       trendingprice = response;
//     });
//   }
//
//   Future _trendingcarddetailsapi() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString('userid');
//     var response = await TrendingService.tendingcard();
//     log.i('trending details show.. $response');
//     setState(() {
//       trendingcardprice = response;
//     });
//   }
//
//   Future _trendingtopSixapi(String status) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userid = prefs.getString('userid');
//     try {
//       var response = await TrendingService.TrendingtopSix(status);
//       log.i('trending by days .. $response');
//       setState(() {
//         trendingcardprice = response;
//       });
//     } catch (e) {
//       // Handle error appropriately here
//       print('Error in _trendingtopSixapi: $e');
//     }
//   }
//
//
//   Future _trendingpoint() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString('userid');
//     var response = await TrendingService.tendingprofile();
//     log.i('trending details show.. $response');
//     setState(() {
//       trendingpoint = response;
//     });
//   }
//
//
//   Future _initLoad() async {
//     try {
//       await Future.wait([
//         _trendingdetailsapi(),
//         _trendingtopSixapi(status),
//         _trendingcarddetailsapi(),
//         _trendingpoint()
//       ]);
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Initialization error: $e');
//       // Handle initialization errors here
//     }
//   }
//
//   @override
//   void initState() {
//     _initLoad();
//     super.initState();
//   }
//
//   Widget _getDropdownWidget(String value) {
//     switch (value) {
//       case 'This Day':
//         return Container(
//           height: 400,
//           child: TopSixGridviewday(), // Widget for 'This Day'
//         );
//       case 'This Week':
//         return Container(
//           height: 400,
//           child: TopSixGridviewweek(),
//         );
//       case 'This Month':
//         return Container(
//           height: 400,
//           child: TopSixGridviewmonth(),
//         );
//       case 'All time':
//         return Container(
//           height: 400,
//           child: TopSixGridviewall(),
//         );
//       default:
//         return Container();
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bluetext,
//       appBar: AppBar(
//         backgroundColor: bluetext,
//         title: Text("On trend", style: TextStyle(fontSize: 14, color: Colors.white)),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Image.asset('assets/logo/rubidyalogosmall.png',height: 12,),
//                   SizedBox(width: 5,),
//
//                   Text(trendingpoint['totalPoints'].toString(),style: TextStyle(fontSize: 12,color: white),),
//                   SizedBox(width: 10,),
//
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(45),
//                     child: Container(
//                       width: 25,
//                       height: 25,
//                       color: Colors.white,
//                       child: (trendingpoint['profilePic'] != null && trendingpoint['profilePic'].isNotEmpty)
//                           ? Image.network(
//                         trendingpoint['profilePic'],
//                         fit: BoxFit.fill,
//                         width: 30,
//                         height: 30,
//                       )
//                           : Icon(
//                         Icons.person, // or any default icon or image
//                         size: 25,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//
//
//
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 10,),
//
//
//
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   "assets/svg/warning.svg",
//                 ),
//
//                 SizedBox(width: 20,),
//
//
//                 Text("You will get rewards only if you get a minimum of \n1000 points.",style: TextStyle(fontSize: 12,color: white),)
//
//               ],
//             ),
//             Container(
//               decoration: BoxDecoration(color: bluetext),
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: SizedBox(
//                       height: 90,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: 3,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(7.0),
//                             child: Container(
//                               width: 110,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: bluetext, width: 0.3),
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.all(Radius.circular(5)),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     height: 35,
//                                     decoration: BoxDecoration(color: blueshade),
//                                     child: Center(
//                                       child: Text(
//                                         trendingprice['result'][index]['rank'].toString(),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SizedBox(height: 40),
//                                       Text(
//                                         '₹' + trendingprice['result'][index]['indianRupee'].toString(),
//                                         style: TextStyle(
//                                           color: bluetext,
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                       SizedBox(width: 5),
//                                       Image.asset(
//                                         "assets/logo/rubidyalogosmall.png",
//                                         height: 12,
//                                       ),
//                                       Text(
//                                         trendingprice['result'][index]['convertedAmount'].toString(),
//                                         style: TextStyle(
//                                           color: bluetext,
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Text("Today Topper", style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         child: Center(
//                           child: Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               color: blueshade,
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: DropdownButton<String>(
//                               value: _selectedDropdownValue,
//                               items: <String>['This Day', 'This Week', 'This Month'].map((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       value,
//                                       style: TextStyle(fontSize: 10, color: Colors.white), // Ensuring text color is black
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _selectedDropdownValue = newValue!;
//                                   _trendingtopSixapi(newValue.toLowerCase());
//                                 });
//                               },
//                               underline: Container(),
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               dropdownColor: blueshade , // Setting the dropdown menu background color
//                             ),
//                           ),
//                         ),
//                       )
//
//
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Container(
//                       width: 500,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [gradnew, gradnew1],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           _getDropdownWidget(_selectedDropdownValue),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Align(
//                               alignment: Alignment.bottomRight,
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => TrendingList()),
//                                   );
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text("More", style: TextStyle(color: Colors.white, fontSize: 12)),
//                                     Icon(Icons.arrow_forward_ios, color: Colors.white, size: 13),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 20,),
//
//
//                   InkWell(
//                     onTap: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) =>  referralpage()),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Container(
//                           height: 40,
//                           width: 400,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.white, width: 0.2),
//                             gradient: LinearGradient(
//                               colors: [gradnew, gradnew1],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Center(child: Text("Invite & Share",style: TextStyle(fontSize: 12,color: white),)),
//                           )
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 20,),
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/trending_screen/widget/topSixThisallGridview.dart';
import 'package:rubidya/screens/trending_screen/widget/topSixThisdayGridview.dart';
import 'package:rubidya/screens/trending_screen/widget/topSixThismonthGridview.dart';
import 'package:rubidya/screens/trending_screen/widget/topSixThisweekGridview.dart';
import 'package:rubidya/screens/trending_screen/widget/trending_list.dart';
import 'package:rubidya/screens/trending_screen/widget/trending_list_all.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home_screen/widgets/referral_page.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  var userid;
  var trendingprice;
  var trendingcardprice;
  var trendingpoint;
  bool _isLoading = true;
  String _selectedDropdownValue = 'This Week';
  var status = 'month';

  Future _trendingdetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await TrendingService.tendingapi();
    log.i('trending details show.. $response');
    setState(() {
      trendingprice = response;
    });
  }

  Future _trendingcarddetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await TrendingService.tendingcard();
    log.i('trending details show.. $response');
    setState(() {
      trendingcardprice = response;
    });
  }

  Future _trendingtopSixapi(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    try {
      var response = await TrendingService.TrendingtopSix(status);
      log.i('trending by days .. $response');
      setState(() {
        trendingcardprice = response;
      });
    } catch (e) {
      // Handle error appropriately here
      print('Error in _trendingtopSixapi: $e');
    }
  }


  Future _trendingpoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await TrendingService.tendingprofile();
    log.i('trending details show.. $response');
    setState(() {
      trendingpoint = response;
    });
  }


  Future _initLoad() async {
    try {
      await Future.wait([
        _trendingdetailsapi(),
        _trendingtopSixapi(status),
        _trendingcarddetailsapi(),
        _trendingpoint()
      ]);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Initialization error: $e');
      // Handle initialization errors here
    }
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  Widget _getDropdownWidget(String value) {
    switch (value) {
      case 'This Day':
        return Container(
          height: 400,
          child: TopSixGridviewday(), // Widget for 'This Day'
        );
      case 'This Week':
        return Container(
          height: 400,
          child: TopSixGridviewweek(),
        );
      case 'This Month':
        return Container(
          height: 400,
          child: TopSixGridviewmonth(),
        );
      case 'All time':
        return Container(
          height: 400,
          child: TopSixGridviewall(),
        );
      default:
        return Container();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text("On trend", style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/logo/rubidyalogosmall.png',height: 12,),
                  SizedBox(width: 5,),

                  Text(trendingpoint['totalPoints'].toString(),style: TextStyle(fontSize: 12,color: white),),
                  SizedBox(width: 10,),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Container(
                      width: 25,
                      height: 25,
                      color: white,
                      child: Image.network(
                        trendingpoint['profilePic'],
                        fit: BoxFit.fill,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),


                ],
              ),
            ),

            SizedBox(height: 10,),




            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/warning.svg",
                ),

                SizedBox(width: 20,),


                Text("You will get rewards only if you get a minimum of \n1000 points.",style: TextStyle(fontSize: 12,color: white),)

              ],
            ),
            Container(
              decoration: BoxDecoration(color: bluetext),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(color: bluetext, width: 0.3),
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(color: blueshade),
                                    child: Center(
                                      child: Text(
                                        trendingprice['result'][index]['rank'].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 40),
                                      Text(
                                        '₹' + trendingprice['result'][index]['indianRupee'].toString(),
                                        style: TextStyle(
                                          color: bluetext,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Image.asset(
                                        "assets/logo/rubidyalogosmall.png",
                                        height: 12,
                                      ),
                                      Text(
                                        trendingprice['result'][index]['convertedAmount'].toString(),
                                        style: TextStyle(
                                          color: bluetext,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Today Topper", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Center(
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: blueshade,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedDropdownValue,
                              items: <String>['This Day', 'This Week', 'This Month','All time'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 10, color: Colors.white), // Ensuring text color is black
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDropdownValue = newValue!;
                                  _trendingtopSixapi(newValue.toLowerCase());
                                });
                              },
                              underline: Container(),
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              dropdownColor: blueshade , // Setting the dropdown menu background color
                            ),
                          ),
                        ),
                      )


                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      width: 500,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [gradnew, gradnew1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _getDropdownWidget(_selectedDropdownValue),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TrendingListAll()),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("More", style: TextStyle(color: Colors.white, fontSize: 12)),
                                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 13),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),


                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  referralpage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                          height: 40,
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.2),
                            gradient: LinearGradient(
                              colors: [gradnew, gradnew1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(child: Text("Invite & Share",style: TextStyle(fontSize: 12,color: white),)),
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}