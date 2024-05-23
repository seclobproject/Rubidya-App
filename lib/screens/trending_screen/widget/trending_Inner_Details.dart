import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/trending_service.dart';


class trendinginnerpage extends StatefulWidget {
   trendinginnerpage({super.key,required this.id});
  String? id;

  @override
  State<trendinginnerpage> createState() => _trendinginnerpageState();
}

class _trendinginnerpageState extends State<trendinginnerpage> {

  var userid;
  var trendingdayInner;
  bool _isLoading = true;




  Future _profileInner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await TrendingService.TrendingDayinnerpage(widget.id);
    setState(() {
      trendingdayInner = response;
    });
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
    _initLoad();

    super.initState();
  }

// _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        title: Text(
          trendingdayInner != null && trendingdayInner.containsKey('userName')
              ? trendingdayInner['userName']
              : 'Unknown',
          style: TextStyle(fontSize: 12,color: white),
        ),
      ),

      body: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: trendingdayInner?['userProfilePic'] != null
                  ? Image.network(
                trendingdayInner['userProfilePic'],
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              )
                  : Icon(Icons.person, size: 60, color: Colors.grey), // Fallback icon
            ),
          ),




          SizedBox(height: 10),
          Text(
            trendingdayInner?['userName'] ?? 'Unknown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Ensure you use Colors.white if white is not defined
            ),
          ),

          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Points  :  ",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: white),
              ),
              Text(
                trendingdayInner?['fullPoint']?.toString() ?? '0', // Default to '0' if null
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Ensure you use Colors.white if white is not defined
                ),
              ),

            ],
          ),
          SizedBox(height: 50),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 05,
                childAspectRatio: (100 / 50),
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 60, // Updated height
                    width: 60,  // Updated width
                    decoration: BoxDecoration(
                      color: gridclr,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          trendingdayInner?['response']?[index]?['pointType'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white, // Ensure you use Colors.white if white is not defined
                          ),
                        ),

                        Text(
                          trendingdayInner?['response']?[index]?['totalPoints']?.toString() ?? '0', // Default to '0' if null
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white, // Ensure you use Colors.white if white is not defined
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),


          SizedBox(height: 20),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../resources/color.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   var userid;
//   var trendingdayInner;
//   bool _isLoading = true;
//
//
//
//
//   Future _profileInner() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = prefs.getString('userid');
//     var response = await TrendingService.TrendingDayinnerpage(widget.id);
//     setState(() {
//       trendingdayInner = response;
//     });
//   }
//
//   Future _initLoad() async {
//     await Future.wait(
//       [
//         _profileInner(),
//
//       ],
//     );
//     _isLoading = false;
//   }
//
//
//   @override
//   void initState() {
//     _initLoad();
//
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff29416D),
//       body: ListView(
//         children: <Widget>[
//           Column(
//             children: [
//               CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.yellow,
//                 child: Image.network('src'),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Lachu',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white),
//               ),
//               SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Points : ',
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300,
//                         color: Colors.white),
//                   ),
//                   Text(
//                     '676',
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300,
//                         color: Colors.white),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               'Today',
//               style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 16,
//                   color: Colors.white),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 height: 160,
//                 width: 152,
//                 decoration: BoxDecoration(
//                     color: Color(0xff3C62CD),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Lick',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       '454',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 160,
//                 width: 152,
//                 decoration: BoxDecoration(
//                     color: Color(0xff3C62CD),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Lick',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       '454',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 height: 160,
//                 width: 152,
//                 decoration: BoxDecoration(
//                     color: Color(0xff3C62CD),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Lick',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       '454',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 160,
//                 width: 152,
//                 decoration: BoxDecoration(
//                     color: Color(0xff3C62CD),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Lick',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       '454',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 height: 160,
//                 width: 152,
//                 decoration: BoxDecoration(
//                     color: Color(0xff3C62CD),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Lick',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       '454',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 160,
//                 width: 152,
//                 decoration: BoxDecoration(
//                     color: Color(0xff3C62CD),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Lick',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       '454',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 50,
//           ),
//         ],
//       ),
//     );
//   }
// }



