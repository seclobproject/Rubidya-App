import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/profile_screen/widget/success_page.dart';
import 'package:rubidya/screens/profile_screen/widget/wallet.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/profile_service.dart';
import '../../../support/logger.dart';


class premiuminnerpage extends StatefulWidget {
   premiuminnerpage({super.key,required this.amount,required this.id,required this.packageName});

  String? amount;
  String? id;
  String? packageName;

  @override
  State<premiuminnerpage> createState() => _premiuminnerpageState();
}

class _premiuminnerpageState extends State<premiuminnerpage> {


  var userid;
  String? uniqueId;
  String? amount;
  String? currency;
  String? payId;

  var packages;

  var profiledetails;
  bool isLoading = false;

  String deductedAmount = '';
  String deductedmsg = '';

  Future<void> deductbalance() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      String packageamount = widget.amount ?? ''; // Initialize 'amount' here

      var reqData = {
        'amount': packageamount,
      };

      var response = await ProfileService.deductrubideum(reqData);
      log.i('Done deducting.... . $response');
      verifyuser();
      if (response['sts'] == '01') {
        setState(() {
          deductedAmount = response['rubideumToPass'].toString();
          deductedmsg = response['msg'].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deducting Rubideum failed. Check your Rubideum balance'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      // Handle specific error cases
      if (error.toString().contains("Erorr deducting")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient Balance'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  Future verifyuser() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');


      String packageid = widget.id ?? '';
      var reqData = {

        'amount': deductedAmount,
        'packageId':packageid,
      };

      SnackBar(
        content: Text('verify user create'),
        duration: Duration(seconds: 3),
      );
      var response = await ProfileService.verifyuser(reqData);
      log.i('verify user create . $response');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => successpage()),
      );

      // Check for success in the response and show a success SnackBar
      if (response['sts'] == 1) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('verify user create'),
        //     duration: Duration(seconds: 3),
        //   ),
        // );
      }
    } catch (error) {
      // Handle specific error cases
      if (error.toString().contains("Insufficient Balance")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient Balance'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future convertinr() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      String packageamount = widget.amount ?? ''; // Initialize 'amount' here

      var reqData = {
        'amount': packageamount,
      };

      var response = await ProfileService.onvertinr(reqData);
      log.i('Done deducting.... . $response');

      if (response['sts'] == '01') {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Rubideum deducted successfully'),
        //     duration: Duration(seconds: 3),
        //   ),
        // );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Bottomnav()),
        // );

        setState(() {
          deductedAmount = response['convertedAmount'].toString();
          deductedmsg = response['msg'].toString();
        });
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('verify user create'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );


      SnackBar(
        content: Text('Insufficient Balance'),
        duration: Duration(seconds: 3),
      );
    } catch (error) {
      // Handle specific error cases
      if (error.toString().contains("Erorr deducting")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erorr deducting'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  Future _initLoad() async {
    await Future.wait(
      [
        convertinr()
      ],
    );
    isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bluetext,
        title: Text(
          "Plans",
          style: TextStyle(fontSize: 14, color: white),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
        
          children: [
        
            SizedBox(
              height: 20,
            ),
        
        
            Align(
              alignment: Alignment.center,
              child: Text(
                "${widget.packageName ?? '0'}",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900, color: golden),
              ),
            ),
        
            SizedBox(
              height: 10,
            ),
        
        
            // Text(
            //   ' ${deductedAmount.isEmpty ? "N/A" : deductedAmount}',
            //   style: TextStyle(color: appBlueColor),
            // ),
        
            Align(
              alignment: Alignment.center,
              child: Text(
                "\₹${widget.amount ?? '0'}", // Display the amount here
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: white,
                ),
              ),
            ),
        
            SizedBox(height: 10,),
        
        
            SvgPicture.asset(
              'assets/svg/whitelogorubidia.svg',
              fit: BoxFit.cover,
              height: 50,
            ),
        
            // Align(
            //   alignment: Alignment.center,
            //   child: Text(
            //     "\₹${widget.id ?? 'N/A'}", // Display the amount here
            //     style: TextStyle(
            //       fontSize: 10,
            //       fontWeight: FontWeight.w900,
            //       color: white,
            //     ),
            //   ),
            // ),
        
        
            SizedBox(
              height: 30,
            ),
        
            Container(
              height: 207,
              width: 345,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [premiuminner1, premiuminner2],
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("RBD",style: TextStyle(color: white),),
        
                  Text( '\₹ ${deductedAmount.isEmpty ? "0" : deductedAmount}',style: TextStyle(color: white,fontWeight: FontWeight.w700,fontSize: 24),),
        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: white,
                      thickness: .1,
                    ),
                  ),
        
                  // Text("Your wallet balance is insufficient",style: TextStyle(fontSize: 10,color: pink),),
        
        
                  SizedBox(height: 10,),
        
                  InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => wallet()));
                    },
                    child: Container(
                      height: 36,
                      width: 100,
                      decoration: BoxDecoration(
                          color: gradnew,
                          border: Border.all(color: white, width: .3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Get Wallet",style: TextStyle(color: white,fontSize: 12),),
                          SvgPicture.asset(
                            'assets/svg/trueicon.svg',
                            fit: BoxFit.cover,
                          ),
        
                        ],
                      )),
        
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(
              height: 180,
            ),
        
            InkWell(
              onTap: (){
                deductbalance();
              },
              child: Container(
                height: 36,
                width: 150,
                decoration: BoxDecoration(
                    color: gradnew,
                    border: Border.all(color: white, width: .3),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pay from wallet",style: TextStyle(color: white,fontSize: 12),),
        
                      ],
                    )),
        
              ),
            ),
        
            SizedBox(height: 60,),
        
          ],
        ),
      ),


    );
  }
}




