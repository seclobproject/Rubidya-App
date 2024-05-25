import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/trending_screen/trendingpage.dart';
import 'package:rubidya/screens/trending_screen/widget/trending_Inner_Details.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrendingListWeek extends StatefulWidget {
  @override
  State<TrendingListWeek> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingListWeek> {
  String? userid;
  var trendingprice;
  var trendingcardprice;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _pageNumber = 1;
  bool _hasMore = true;
  var trendingthisalltopsix;
  String _selectedDropdownValue = 'Thisweek';
  List<Map<String, dynamic>> trendinglist = [];

  Future<void> _trendingcarddetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      var response = await TrendingService.trendingapiThisweek(page: _pageNumber);
      log.i('trending card details show.. $response');
      setState(() {
        trendingcardprice = response;
        trendinglist = List<Map<String, dynamic>>.from(response['response']);
        _hasMore = _pageNumber < response['totalPages'];
      });
    } else {
      log.e('User ID is null');
    }
  }



  Future _trendingtopSixapithisall(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    try {
      var response = await TrendingService.trendingapiThismonth();
      log.i('tranding by all .. $response');
      setState(() {
        trendingthisalltopsix = response;
      });
    } catch (e) {
      // Handle error appropriately here
      print('Error in _trendingtopSixapi: $e');
    }
  }

  Future<void> _trendingdetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    if (userid != null) {
      var response = await TrendingService.trendingapiThisweek();
      log.i('trending details show.. $response');
      setState(() {
        trendingprice = response;
      });
    } else {
      log.e('User ID is null');
    }
  }

  Future<void> _initLoad() async {
    await Future.wait([
      _trendingdetailsapi(),
      _trendingcarddetailsapi(),
      _trendingtopSixapithisall(_selectedDropdownValue)
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await TrendingService.trendingapiThisweek(page: _pageNumber + 1);
      final List<Map<String, dynamic>> newTrendingList = List<Map<String, dynamic>>.from(response['response']);
      setState(() {
        _pageNumber ++;
        _isLoadingMore = false;
        trendinglist.addAll(newTrendingList);
        _hasMore = _pageNumber < response['totalPages'];
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoadingMore = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluetext,
        foregroundColor: Colors.white,
        title: Text("On trend", style: TextStyle(fontSize: 14, color: white)),
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
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 0.6,
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
                                padding: EdgeInsets.all(2.0),
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
                                      trendinglist[index]['profilePic'] ?? ''),
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
                                      trendinglist[index]['rank'].toString(),
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
                              trendinglist != null && trendinglist[index] != null && trendinglist[index].containsKey('userName')
                                  ? trendinglist[index]['userName'] ?? ''
                                  : '',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                                trendinglist[index]['totalPoints'].toString(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_isLoadingMore &&
                      scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      _hasMore) {
                    _loadMoreData();
                  }
                  return true;
                },
                child: ListView.builder(


                  // itemCount: trendinglist.length - 3 + (_isLoadingMore ? 1 : 0),
                  itemCount: 100,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < trendinglist.length ) {
                      return InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrendingInnerPage(id: trendingthisalltopsix['response'][index]['_id'],dayidentifier: 'thisall')),);
                        },
                        child: Container(
                          color: Color(0xFFE6E8F4),
                          child: ListTile(
                            title: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: white,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(
                                    trendinglist[index]['rank'].toString(),
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
                                    backgroundImage: NetworkImage(trendinglist[index]['profilePic'] ?? ''),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    trendinglist[index]['userName'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: bluetext,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    trendinglist[index]['totalPoints'].toString() + " Pts ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: bluetext,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 20)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _isLoadingMore
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : Container(); // Adjust loading widget as needed
                    }
                  },
                ),
              ),
            ),

            SizedBox()
          ],
        ),
      ),
    );
  }
}