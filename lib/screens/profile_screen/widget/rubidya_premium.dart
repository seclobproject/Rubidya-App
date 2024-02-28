import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class premiumpage extends StatefulWidget {
  const premiumpage({super.key});

  @override
  State<premiumpage> createState() => _premiumpageState();
}

class _premiumpageState extends State<premiumpage> {


  var userid;



  String? uniqueId;
  String? amount;
  String? currency;
  String? payId;

  var profiledetails;
  bool isLoading = false;




  Future addData(String payId, String uniqueId) async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var reqData = {
        'payId': payId,
        'uniqueId': uniqueId,
        'currency': 'RBD',
        'amount': '5',

      };

      var response = await ProfileService.deductbalance(reqData);
      log.i('add member create . $response');
      verifyuser();

      // Check for success in the response and show a success SnackBar
      if (response['msg'] == 'PayId added successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pay Id Added Successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      }

    }
    catch (error) {
      // Handle specific error cases
      if (error.toString().contains("User Already Exist")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists!'),
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
      var reqData = {
        'amount': '1000'
      };

      var response = await ProfileService.verifyuser(reqData);
      log.i('verify user create . $response');

      // Check for success in the response and show a success SnackBar
      if (response['sts'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('verify user create'),
            duration: Duration(seconds: 3),
          ),
        );
      }


    }catch (error) {
      // Handle specific error cases
      if (error.toString().contains("User Already Exist")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('verify already exists!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }



  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi()
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
      appBar: AppBar(
        title: Text("Rubidya Premium",style:TextStyle(fontSize: 14),),
      ),
      body: Column(
        children: [

          SizedBox(height: 20,),
          
          Center(child: Image.asset('assets/image/logopngrubidya.png')),
          
          
          Text("Rubidya Premium",
            style: TextStyle(fontSize: 14,
                color: bluetext,fontWeight:
                FontWeight.w500),),

          SizedBox(height: 40,),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Text("Enjoy Rubidya Premium starting from 100 RBD",
              style: TextStyle(fontSize: 14,
                  color: bluetext,fontWeight:
                  FontWeight.w700),),
          ),

          SizedBox(height: 20,),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Text("We will verify your identity after payment, which may take up to 48 hours. We'll return your money if we can't verify your identity.",
              style: TextStyle(fontSize: 14,
                  color: bluetext,fontWeight:
                  FontWeight.w400),),
          ),


          SizedBox(height: 20,),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Text("You’ll billed 2.5 Rubidya coins in your wallet per month on this profile, the 2.5 Rubidya coins was 500 Indian rupees.",
              style: TextStyle(fontSize: 14,
                  color: textblack,fontWeight:
                  FontWeight.w400),),
          ),

          SizedBox(height: 250,),

          Text(
            (profiledetails?['user']?['payId'] ?? 'loading...'),
            style: TextStyle(fontSize: 14),
          ),

          Text(
            (profiledetails?['user']?['uniqueId'] ?? 'loading...'),
            style: TextStyle(fontSize: 14),
          ),



          InkWell(
            onTap: (){
              addData(
                profiledetails?['user']?['payId'] ?? '',
                profiledetails?['user']?['uniqueId'] ?? '',
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                width: 400,
                decoration: BoxDecoration(
                  color: bluetext,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Center(child: Text("Confirm",style: TextStyle(color: white),)),
              ),
            ),
          )

        ],
      ),

    );
  }
}
