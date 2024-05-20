import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/resources/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/trending_screen/widget/trending_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import '../../services/trending_service.dart';
import '../../support/logger.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  var userid;
  var trendingprice;
  var trendingcardprice;
  bool _isLoading = true;

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

  Future _initLoad() async {
    await Future.wait(
      [
        _trendingdetailsapi(),
        _trendingcarddetailsapi()

      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text("Trending", style: TextStyle(fontSize: 14, color: white)),
        actions: [],
      ),
      body: SingleChildScrollView(
    child: _isLoading
    ? Center(
    child: CircularProgressIndicator(),
    )
        :SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: bluetext),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 94,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 115,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: bluetext, width: 0.3),
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: blueshade,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'price: ' + trendingprice['result'][index]['rank'].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Text(
                                          '₹' +trendingprice['result'][index]['indianRupee'].toString(),
                                          style: TextStyle(
                                            color: bluetext,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          "assets/logo/rubidyalogosmall.png",
                                          height: 15,
                                        ),
                                        Text(
                                          trendingprice['result'][index]['convertedAmount'].toString(),
                                          style: TextStyle(
                                            color: bluetext,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "This day",
                          style: TextStyle(color: white),
                        )),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      // height: 450,
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
                          SizedBox(
                            height: 410,
                            child: GridView.builder(
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
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Container(
                                    height: 190,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 1),
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
                                                      width: 1,
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
                                                    trendingcardprice['response'][index]['profilePic']),
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
                                                    trendingcardprice['response'][index]['rank'].toString(),
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
                                            trendingcardprice['response'][index]['userName'],
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
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => TrendingList()),
                                  // );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "More",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: white,
                                      size: 13,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )

                  // SizedBox(
                  //   height: 30,
                  //   child: Tabbar(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(5, 5, 4, 5),
    child: Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: bluetext, width: 0.5),
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
              color: bluetext,
            ),
            child: Center(
              child: Text(
                "1 st price",
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "₹1000",
                      style: TextStyle(
                        color: bluetext,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 35,
                ),
                Image.asset(
                  "assets/image/applogoicon.png",
                  height: 20,
                ),
                Text(
                  "0",
                  style: TextStyle(
                    color: bluetext,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
