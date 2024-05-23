import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../resources/color.dart';
import '../../../../services/home_service.dart';
import '../../../../services/wallet_service.dart';
import '../../../../support/logger.dart';

class TransactionHistory extends StatefulWidget {
   TransactionHistory({Key? key,required this.id}) : super(key: key);

   String? id;

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  int _pageNumber = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _isLoading = true;
  List<dynamic> _transactionhistory = [];

  var userid;
  var transactionHistory;
  String balance = '';

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  // Future<void> _initLoad() async {
  //   await Future.wait([
  //     _profiledetailsapi(),
  //     _loadMoreData(),
  //   ]);
  // }


  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
        _loadMoreData(),

      ],
    );
    _isLoading = false;
  }

  Future<void> _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await WalletService.TransactionHistory(widget.id);
    log.i('transactionHistory History show....... $response');
    setState(() {
      transactionHistory = response;
      transactionHistory.length;
    });
  }


  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final response = await WalletService.TransactionHistory(
        widget.id, // Access id from the widget
        page: _pageNumber,
        limit: 10,
      );
      final newReferrals = response['result'];
      setState(() {
        _pageNumber++;
        _isLoadingMore = false;
        _transactionhistory.addAll(newReferrals);

        if (newReferrals.length < 10) {
          _hasMore = false;
        }
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
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoadingMore &&
            scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
          _loadMoreData();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          // toolbarHeight: 0.1,
          backgroundColor: white,
          title: Text("Transaction history",style: TextStyle(fontSize: 14),),
        ),
        // backgroundColor: bluetext,
        body: SingleChildScrollView(
          child:  _isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              :Column(
            children: [
              SizedBox(height: 20,),

              
              // Text(transactionHistory['result'][0]['amount'])

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              //   child: Align(
              //       alignment: Alignment.topLeft,
              //       child: Text("Transaction history",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: bluetext),)),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: transactionHistory['result'] != null ? transactionHistory['result'].length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (transactionHistory['result'] == null) {
                      return SizedBox(); // or any other fallback widget
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                      Container(
                      height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color:lightpink,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/svg/transaction.svg",
                            height: 20,
                          ),
                        ),
                      ),
                              SizedBox(width: 35),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transactionHistory['result'][index]['typeofTransaction'] ?? '',
                                    style: TextStyle(fontSize: 14, color: tranactionclr,fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    transactionHistory['result'][index]['fromWhom'] ?? '',
                                    style: TextStyle(fontSize: 10, color: bluetext),
                                  ),

                                  Text(
                                    transactionHistory['result'][index]['kind'] ?? '',
                                    style: TextStyle(fontSize: 8, color: appBlueColor),
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                transactionHistory.isEmpty
                                    ? 'No Transactions'
                                    : transactionHistory['result'][index]['amount'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: transactionHistory['result'][index]['amount'].isEmpty ? Colors.grey : bluetext,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: bluetext, thickness: .1),
                        ],
                      ),
                    );
                  },
                ),
              ),

              _isLoadingMore
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
