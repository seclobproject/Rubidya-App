import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSixGridviewweek extends StatefulWidget {
  @override
  _TopSixGridviewday createState() => _TopSixGridviewday();
}

class _TopSixGridviewday extends State<TopSixGridviewweek> {
  String _selectedDropdownValue = 'Thisday';
  var trendingthisweektopsix;
  bool _isLoading = true;

  var trendingalltimepoints;

  Future _trendingtopSixapithisweek(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    try {
      var response = await TrendingService.trendingapiThisweek();
      log.i('tranding by days .. $response');
      setState(() {
        trendingthisweektopsix = response;
      });
    } catch (e) {
      print('Error in _trendingtopSixapi: $e');
    }
  }


  Future<int> _fetchfullpoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      return response['fullPoint'];  // Assuming the API response contains the 'likes' field
    } catch (e) {
      print('Error fetching likes: $e');
      return 0;  // Default to 0 if there's an error
    }
  }





  Future<int> _fetchfirstCommentPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'comment',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching comment points: $e');
      return 0; // Default to 0 if there's an error
    }
  }


  Future<int> _fetchRefferalPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'referal',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching referal points: $e');
      return 0; // Default to 0 if there's an error
    }
  }



  Future<int> _fetchPostPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'referal',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching referal points: $e');
      return 0; // Default to 0 if there's an error
    }
  }





  Future<int> _fetchFirst_Points(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'first_post',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching referal points: $e');
      return 0; // Default to 0 if there's an error
    }
  }


  Future<int> _fetchfollow_Points(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'follow',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching follow points: $e');
      return 0; // Default to 0 if there's an error
    }
  }




  Future<int> _fetchCommentPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'comment',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching follow points: $e');
      return 0; // Default to 0 if there's an error
    }
  }



  Future<int> _fetchLikes(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisday(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'like',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching follow points: $e');
      return 0; // Default to 0 if there's an error
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
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            String userName = trendingthisweektopsix['response'][index]['userName'];
            String userId = trendingthisweektopsix['response'][index]['userId'];
            var profile_pic_url = trendingthisweektopsix['response'][index]['profilePic'];
            int points = await _fetchfullpoints(userId);
            int likes = await _fetchLikes(userId);

            int refferal = await _fetchRefferalPoints(userId);
            int Comment = await _fetchCommentPoints(userId);
            int follow = await _fetchFirst_Points(userId);

            int post = await _fetchFirst_Points(userId);

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
                        height: 325,
                        width: 315,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                        profile_pic_url,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                                    children: [
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0), // Add top padding
                                        child: Text(
                                          userName,
                                          style: TextStyle(
                                            color: bluetext,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Points: $points',
                                        style: TextStyle(
                                          color: bluetext,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

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
                                            '$likes',
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
                                            "comment",
                                            style: TextStyle(
                                                fontSize: 12, color: bluetext),
                                          ),
                                          Text(
                                            '$Comment',
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
                                            '$refferal',
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
                                            '$post',
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
                                            "Other",
                                            style: TextStyle(
                                                fontSize: 12, color: bluetext),
                                          ),
                                          Text(
                                            '$follow',
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
                    },
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                color: blueshade,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            border: Border.all(width: 0.5, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueshade,
                          border: Border.all(width: 5, color: bluetext),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: bluetext,
                          backgroundImage: NetworkImage(trendingthisweektopsix['response'][index]['profilePic']),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: gradnew,
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Center(
                            child: Text(
                              trendingthisweektopsix['response'][index]['rank'].toString(),
                              style: TextStyle(color: Colors.white, fontSize: 8),
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
                      trendingthisweektopsix['response'][index]['userName'],
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        trendingthisweektopsix['response'][index]['totalPoints'].toString(),
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
                      borderRadius: BorderRadius.all(Radius.circular(8)),
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