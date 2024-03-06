import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../navigation/bottom_navigation.dart';
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

  String deductedAmount = '';
  String deductedmsg = '';


  Future deductbalance() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var reqData = {
        'amount': '500'
      };

      var response = await ProfileService.deductrubideum(reqData);
      log.i('Done deducting.... . $response');

      if (response['sts'] == '01') {
        setState(() {
          deductedAmount = response['rubideumToPass'].toString();
          deductedmsg = response['msg'].toString();
        });
      }
    }
    catch (error) {
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





  // Future addData(String payId, String uniqueId) async {
  //   setState(() {});
  //   try {
  //     setState(() {});
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     userid = prefs.getString('userid');
  //     var reqData = {
  //       'payId': payId,
  //       'uniqueId': uniqueId,
  //       'currency': 'RBD',
  //       'amount': '5',
  //
  //     };
  //     SnackBar(
  //       content: Text('Rubidya Successfully'),
  //       duration: Duration(seconds: 3),
  //     );
  //
  //     var response = await ProfileService.deductbalance(reqData);
  //     log.i('add member create . $response');
  //     verifyuser();
  //
  //     // Check for success in the response and show a success SnackBar
  //     if (response['msg'] == 'PayId added successfully') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Pay Id Added Successfully'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //
  //   }
  //   catch (error) {
  //     // Handle specific error cases
  //     if (error.toString().contains("User Already Exist")) {
  //       // Show a SnackBar to inform the user
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('User already exists!'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   }
  // }

  Future verifyuser() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var reqData = {
        'amount': deductedAmount
      };

      SnackBar(
        content: Text('verify user create'),
        duration: Duration(seconds: 3),
      );
      var response = await ProfileService.verifyuser(reqData);

      log.i('verify user create . $response');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Bottomnav()),
      );

      // Check for success in the response and show a success SnackBar
      if (response['sts'] == 1) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('verify user create'),
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
        _profiledetailsapi(),
        deductbalance()
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
      body: SingleChildScrollView(
        child: Column(
          children: [


            SizedBox(height: 20,),

            Text('Deducted Amount: ${deductedAmount.isEmpty ? "N/A" : deductedAmount}'),


            Center(child: Image.asset('assets/image/logopngrubidya.png')),
            
            
            Text("Rubidya Premium",
              style: TextStyle(fontSize: 14,
                  color: bluetext,fontWeight:
                  FontWeight.w500),),

            SizedBox(height: 40,),

            // Padding(
            //   padding:  EdgeInsets.symmetric(horizontal: 20),
            //   child: Text("Enjoy Rubidya Premium starting from 100 RBD",
            //     style: TextStyle(fontSize: 14,
            //         color: bluetext,fontWeight:
            //         FontWeight.w700),),
            // ),

            SizedBox(height: 20,),


         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: Align(
             alignment: Alignment.topLeft,
             child: Text("RUBIDEUM PREMIUM ACCOUNT ACTIVATION",style: TextStyle(
               fontWeight: FontWeight.bold,
               color: bluetext
             ),),
           ),
         ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("If you lose coins from Rubideum account after verified you will be credited back within 48 hours.",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: bluetext
                ),),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: bluetext,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: 'Royal Membership – ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextSpan(
                      text: 'You will lose 500 rupees worth of rubideum coin. \nRubideum coins value was not fixed',
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: bluetext,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: 'Benefit - ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextSpan(
                      text: ' If your friend shares your post and their friend likes it, you will earn a certain percentage of income.\n',
                    ),

                    TextSpan(
                      text: '* This benefit also comes with Prime and Golden membership.*',
                    ),

                  ],
                ),
              ),
            ),

            


            SizedBox(height: 200,),

            // Text(
            //   (profiledetails?['user']?['payId'] ?? 'loading...'),
            //   style: TextStyle(fontSize: 14),
            // ),
            //
            // Text(
            //   (profiledetails?['user']?['uniqueId'] ?? 'loading...'),
            //   style: TextStyle(fontSize: 14),
            // ),

            InkWell(
              onTap: (){
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Successfully Updated'),
                //     duration: Duration(seconds: 3),
                //   ),
                // );

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('$deductedmsg'),
                //     duration: Duration(seconds: 3),
                //   ),
                // );

                // addData(
                //   profiledetails?['user']?['payId'] ?? '',
                //   profiledetails?['user']?['uniqueId'] ?? '',
                // );

                verifyuser();


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
      ),

    );
  }
}
