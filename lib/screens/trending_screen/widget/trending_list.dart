import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/trending_screen/trendingpage.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendingList extends StatefulWidget {
  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  String? userid;
  var trendingprice;
  var trendingcardprice;
  bool _isLoading = true;

  Future<void> _trendingcarddetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      var response = await TrendingService.tendingcard();
      log.i('trending details show.. $response');
      setState(() {
        trendingcardprice = response;
      });
    } else {
      log.e('User ID is null');
    }
  }

  Future<void> _trendingdetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      var response = await TrendingService.tendingapi();
      log.i('trending details show.. $response');
      setState(() {
        trendingprice = response;
      });
    } else {
      log.e('User ID is null');
    }
  }

  Future<void> _initLoad() async {
    await Future.wait(
      [
        _trendingdetailsapi(),
        _trendingcarddetailsapi()
      ],
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }
//oregroundColor: Colors.white,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: bluetext,
        title: Text("Trending", style: TextStyle(fontSize: 14, color: white)),
        actions: [],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(color: bluetext),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of items per row
                  crossAxisSpacing: 5.0, // Horizontal space between items
                  mainAxisSpacing: 5.0, // Vertical space between items
                  childAspectRatio: 0.6, // Aspect ratio of each item
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(


                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.0), // Adjust padding as needed
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
                                top: 20, // Adjust position as needed
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: blueshade,
                                  border: Border.all(width: 5, color: blueshade),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: bluetext,
                                  backgroundImage: NetworkImage(
                                      trendingcardprice['response'][index]['profilePic'] ?? ''),
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
                                      trendingcardprice['response'][index]['rank'].toString(),
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
                              trendingcardprice['response'][index]['userName'] ?? '',
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
                                trendingcardprice['response'][index]['totalPoints'].toString(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Container(
                          //   height: 20,
                          //   width: 60,
                          //   alignment: Alignment.center,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: blueshade),
                          //     color: bluetext,
                          //     borderRadius: BorderRadius.all(Radius.circular(8)),
                          //   ),
                          //   // child: Text(
                          //   //   "Good job",
                          //   //   style: TextStyle(
                          //   //     color: Colors.white,
                          //   //     fontSize: 9,
                          //   //     fontWeight: FontWeight.w600,
                          //   //   ),
                          //   // ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Adding space between the Row and ListView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: ListView.builder(
                    itemCount: trendingcardprice != null ? trendingcardprice['response'].length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Color(0xFFE6E8F4),
                        child: ListTile(
                          title: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),
                                Text(
                                  trendingcardprice['response'][index]['rank'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: bluetext,
                                  ),
                                ),
                                SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: bluetext,
                                  backgroundImage: NetworkImage(
                                      trendingcardprice['response'][index]['profilePic'] ?? ''),
                                ),
                                SizedBox(width: 10), // Add space between the avatar and the name
                                Text(
                                  trendingcardprice['response'][index]['userName'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bluetext,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Spacer(), // Add a spacer to push the points to the end
                                Text(
                                  trendingcardprice['response'][index]['totalPoints'].toString()+" Pts ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bluetext,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 20,)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}