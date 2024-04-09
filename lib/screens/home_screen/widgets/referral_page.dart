import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class referralpage extends StatefulWidget {
  const referralpage({super.key});

  @override
  State<referralpage> createState() => _referralpageState();
}

class _referralpageState extends State<referralpage> {

  var userid;
  var walletmarketvalue;
  var walletbalance;
  bool _isLoading = true;
  String balance = '';
  bool isFavorite = false;
  var profiledetails;
  bool isLoading = false;
  var refferals;


  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future _refferalhistoryapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await HomeService.refferalhistory();
    log.i('refferal details show.. $response');
    setState(() {
      refferals = response;
    });
  }



  Future<void> fetchBalance() async {
    final url = 'https://pwyfklahtrh.rubideum.net/basic/getBalance';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "payId": "RBD968793034",
        "uniqueId": "64eaf0a9cec8b5bb72f56d01",
        "currency": "RBD",
      }),

    );

    print(profiledetails?['user']?['payId'] ?? '',);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        balance = data['balance'].toString();
      });
    } else {

    }
  }

  Future _initLoad() async {
    await Future.wait(

      [
        _profiledetailsapi(),
        fetchBalance(),
        _refferalhistoryapi()
      ],

    );
    _isLoading = false;
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
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: bluetext,
      //   title: Text("Referral Page",style: TextStyle(fontSize: 12),),
      // ),
      backgroundColor: bluetext,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 100,),

            //
            // Text(profiledetails['user']['payId']),
            // Text(profiledetails['user']['uniqueId']),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 177,


                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text("Available Balance",style:TextStyle(color: white,fontSize: 16,fontWeight: FontWeight.w300),),

                    SizedBox(height: 10,),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/verify.svg",
                          height: 30,
                        ),

                        SizedBox(width: 10,),

                        Text(profiledetails['user']['totalReferralAmount'].toString(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18,color: white),)
                      ],
                    ),

                    SizedBox(height: 20,),


                    InkWell(
                      onTap: (){
                        Share.share("https://admin.rubidya.com/register/$userid");
                      },
                      child: Container(
                        height: 36,
                        width: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: white,
                                width: .2
                            ),
                            gradient: LinearGradient(
                              colors: [gradnew, gradnew1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("REFER NOW",style: TextStyle(fontSize: 10,color: white,fontWeight: FontWeight.w600),),
                            SizedBox(width: 10,),
                            SvgPicture.asset(
                              "assets/svg/arrow.svg",
                              height: 7,
                            ),

                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),


            SizedBox(height: 40,),


            Container(
              width: 600,
                height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65),
                  topRight: Radius.circular(65))
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text("Referral History",
                        style: TextStyle(fontWeight: FontWeight.w500,color: bluetext),)),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: refferals != null && refferals['referrals'] != null
                          ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: refferals['referrals'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SvgPicture.asset(
                                          "assets/svg/circlearrow.svg",
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(refferals['referrals'][index]['firstName'],style: TextStyle(fontSize: 14,color: bluetext),),
                                          // Text(refferals['referrals'][index]['lastName'],style: TextStyle(fontSize: 10,color: bluetext),)
                                        ],
                                      ),

                                      Expanded(child: SizedBox()),

                                      Text(
                                        refferals['referrals'][index]['isVerified']
                                            ? 'Verified'
                                            : 'Not Verified',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: refferals['referrals'][index]['isVerified']
                                              ? Colors.green  // Set color to green if verified
                                              : appBlueColor, // Set color to appBlueColor if not verified
                                        ),
                                      )

                                    ],
                                  ),
                                  Divider(color: bluetext,thickness: .1,)
                                ],
                              ),
                            );
                          })
                          : Center(
                        // Handle the case where refferals or refferals['referrals'] is null
                        child: Text('No referrals available'),
                      ),
                    ),
                  )

                ],
              ),
            )

          ],
        ),
      ),

    );
  }
}
