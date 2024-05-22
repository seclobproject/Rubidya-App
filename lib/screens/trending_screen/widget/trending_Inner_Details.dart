import 'package:flutter/material.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [

          Text(trendingdayInner['response'][0]['pointType']),



        ],
      ),
    );
  }
}
