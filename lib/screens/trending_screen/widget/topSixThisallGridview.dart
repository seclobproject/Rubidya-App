import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSixGridviewall extends StatefulWidget {
  @override
  _TopSixGridviewall createState() => _TopSixGridviewall();
}

class _TopSixGridviewall extends State<TopSixGridviewall> {
  

    String _selectedDropdownValue = 'Thisday';
      var trendingthisalltopsix;
        bool _isLoading = true;



      Future _trendingtopSixapithisweek(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    try {
      var response = await TrendingService.trendingapiThisall();
      log.i('tranding by all .. $response');
      setState(() {
        trendingthisalltopsix = response;
      });
    } catch (e) {
      // Handle error appropriately here
      print('Error in _trendingtopSixapi: $e');
    }
  }

  Future _initLoad() async {
    try {
      await Future.wait([
        _trendingtopSixapithisweek(_selectedDropdownValue),
        
       
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 6,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        // Number of items per row
                                        crossAxisSpacing: 5.0,
                                        // Horizontal space between items
                                        mainAxisSpacing: 5.0,
                                        // Vertical space between items
                                        childAspectRatio:
                                        0.6, // Aspect ratio of each item
                                      ),
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector( onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                content: StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return Container(
                                                        height: 325, //
                                                        width: 315, //
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(3.0), // Border width
                                                                    decoration: BoxDecoration(
                                                                      color: bluetext, // Border color
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: CircleAvatar(
                                                                      radius: 25,
                                                                      backgroundColor: Colors.white,
                                                                      backgroundImage: NetworkImage(
                                                                        "https://www.befunky.com/images/wp/wp-2021-01-linkedin-profile-picture-focus-face.jpg?auto=avif,webp&format=jpg&width=1200",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 10),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment
                                                                        .start, // Align text to start
                                                                    children: [
                                                                      SizedBox(height: 20,),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top: 15.0), // Add top padding
                                                                        child: Text(
                                                                          'Lachu',
                                                                          style: TextStyle(
                                                                              color: bluetext,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'Points: 654',
                                                                        style: TextStyle(
                                                                            color: bluetext,
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.w600
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 10,),
    
                                                              DropdownButton<String>(
                                                                value: _selectedDropdownValue,
                                                                items: <String>['Today', 'Week', 'Month'].map((String value) {
                                                                  return DropdownMenuItem<String>(
                                                                    value: value,
                                                                    child: Text(value, style: TextStyle(fontSize: 10)),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (String? newValue) {
                                                                  setState(() {
                                                                    _selectedDropdownValue = newValue!;
                                                                  });
                                                                },
                                                                underline: Container(),
                                                                style: TextStyle(
                                                                  color: bluetext,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
    
    
    
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(2.0),
                                                                    child: Container(
                                                                      height: 60,
                                                                      width: 84,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.all(Radius.circular(10)),
                                                                          color: Colors.white,
                                                                          border: Border.all(
                                                                              width: .5, color: bluetext)),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Like",
                                                                            style: TextStyle(
                                                                                fontSize: 12, color: bluetext),
                                                                          ),
                                                                          Text(
                                                                            "24",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: bluetext),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(2.0),
                                                                    child: Container(
                                                                      height: 60,
                                                                      width: 84,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.all(Radius.circular(10)),
                                                                          color: Colors.white,
                                                                          border: Border.all(
                                                                              width: .5, color: bluetext)),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Comment",
                                                                            style: TextStyle(
                                                                                fontSize: 12, color: bluetext),
                                                                          ),
                                                                          Text(
                                                                            "24",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: bluetext),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(2.0),
                                                                    child: Container(
                                                                      height: 60,
                                                                      width: 84,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.all(Radius.circular(10)),
                                                                          color: Colors.white,
                                                                          border: Border.all(
                                                                              width: .5, color: bluetext)),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Referal",
                                                                            style: TextStyle(
                                                                                fontSize: 12, color: bluetext),
                                                                          ),
                                                                          Text(
                                                                            "24",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: bluetext),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(2.0),
                                                                    child: Container(
                                                                      height: 60,
                                                                      width: 84,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.all(Radius.circular(10)),
                                                                          color: Colors.white,
                                                                          border: Border.all(
                                                                              width: .5, color: bluetext)),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Photo",
                                                                            style: TextStyle(
                                                                                fontSize: 12, color: bluetext),
                                                                          ),
                                                                          Text(
                                                                            "24",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: bluetext),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
    
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                ),
                                              );
    
                                            },
                                          );
                                        },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Container(
                                              height: 190,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white, width:0.5),
                                                color: blueshade,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(2.0),
                                                        // Adjust padding as needed
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Image.asset(
                                                          "assets/image/congratulation.png",
                                                          height: 90,
                                                          width: 90,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 20,
                                                        // Adjust position as needed
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: blueshade,
                                                          border: Border.all(
                                                              width: 5, color: bluetext),
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: bluetext,
                                                          backgroundImage: NetworkImage(
                                                              trendingthisalltopsix['response'][index]['profilePic']),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 70,
                                                        child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                            color: gradnew,
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(100)),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              trendingthisalltopsix['response'][index]['rank'].toString(),
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 8),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 0),
                                                  Container(
                                                    height: 15,
                                                    child: Text(
                                                      trendingthisalltopsix['response'][index]['userName'],
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                      overflow: TextOverflow.ellipsis, // Ensures text overflow is handled
                                                      maxLines: 1, // Limits the text to a single line
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Points:',
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        trendingthisalltopsix['response'][index]['totalPoints'].toString(),
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
    
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    height: 20,
                                                    width: 60,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: bluetext,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(8)),
                                                    ),
                                                    child: Text(
                                                      "Good job",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
  }
}

