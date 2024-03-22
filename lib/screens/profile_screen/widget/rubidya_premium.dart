import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/profile_screen/widget/premium_inner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  var packages;

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
      var reqData = {'amount': deductedAmount};

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
    } catch (error) {
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

  Future peremiumapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getpackage();
    log.i('packages show....... $response');
    setState(() {
      packages = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [_profiledetailsapi(),
        peremiumapi(),
        deductbalance()],
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
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bluetext,
        title: Text(
          "Rubidya Premium",
          style: TextStyle(fontSize: 14, color: white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            Text(
              "Get premium today",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: white),
            ),

            SizedBox(
              height: 30,
            ),

            Container(
              height: 46,
              width: 157,
              decoration: BoxDecoration(
                  color: gradnew,
                  border: Border.all(color: white, width: .3),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset(
                    'assets/svg/whitelogorubidia.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  SvgPicture.asset(
                    'assets/svg/logoyellowrubidia.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  SvgPicture.asset(
                    'assets/svg/logogoldrubidia.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Text(
              "Rubideum Premium Account Activation",
              style: TextStyle(fontSize: 16, color: white),
            ),

            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "If you debit coins from Rubideum account after verified you\nwill be credited back within 48 hours.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: white,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),


            SizedBox(
              height: 1280,
              child: packages != null && packages['packages'] != null // Check if packages is not null and 'packages' key exists
                  ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: packages['packages'].length,
                itemBuilder: (BuildContext context, int index) {
                  return premiumListing(
                    id: packages['packages'][index]['_id'],
                    amount: packages['packages'][index]['amount'].toString(),
                    packageName: packages['packages'][index]['packageName'],
                  );
                },
              )
                  : Container(), // Return an empty container or some default widget if packages is null or 'packages' key doesn't exist
            ),


            SizedBox(
              height: 50,
            ),

            // Text(
            //   (profiledetails?['user']?['payId'] ?? 'loading...'),
            //   style: TextStyle(fontSize: 14),
            // ),
            //
            // Text(
            //   (profiledetails?['user']?['uniqueId'] ?? 'loading...'),
            //   style: TextStyle(fontSize: 14),
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Rubideum to be deducted:"),
            //     Text(
            //       ' ${deductedAmount.isEmpty ? "N/A" : deductedAmount}',
            //       style: TextStyle(color: appBlueColor),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // InkWell(
            //   onTap: () {
            //     // ScaffoldMessenger.of(context).showSnackBar(
            //     //   SnackBar(
            //     //     content: Text('Successfully Updated'),
            //     //     duration: Duration(seconds: 3),
            //     //   ),
            //     // );
            //
            //     // ScaffoldMessenger.of(context).showSnackBar(
            //     //   SnackBar(
            //     //     content: Text('$deductedmsg'),
            //     //     duration: Duration(seconds: 3),
            //     //   ),
            //     // );
            //
            //     // addData(
            //     //   profiledetails?['user']?['payId'] ?? '',
            //     //   profiledetails?['user']?['uniqueId'] ?? '',
            //     // );
            //
            //     verifyuser();
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     child: Container(
            //       height: 40,
            //       width: 400,
            //       decoration: BoxDecoration(
            //           color: white,
            //           borderRadius: BorderRadius.all(Radius.circular(10))),
            //       child: Center(
            //           child: Text(
            //         "Confirm",
            //         style: TextStyle(color: textblack),
            //       )),
            //     ),
            //   ),
            // ),

            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}

class premiumListing extends StatelessWidget {
  const premiumListing({
    required this.id,
    required this.amount,
    required this.packageName,
    super.key,
  });

  final String id;
  final String amount;
  final String packageName;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => premiuminnerpage(id: id,amount: amount,packageName:packageName)),);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Container(
              height: 400,
              width: 354,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [premiumcard1, premiumcard2],
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              packageName,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: white),
                            ),
                            Text(
                              amount,
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/trueicon.svg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'You will debit 500 rupees worth of\nrubideum coin.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/trueicon.svg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Rubideum coins value was not certain.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/trueicon.svg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'If your friend shares your post and their\nfriend likes it, you will earn a certain\npercentage of income.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/trueicon.svg',
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'This benefit also comes with Prime and\nGolden membership.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 35,
                      width: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [g1button, g2button],
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          "Choose Your Plan",
                          style: TextStyle(color: white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 20, // Adjust this value as needed
            child: SvgPicture.asset(
              'assets/svg/whiteshape.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
          Positioned(
            top: 40,
            right: 20, // Adjust this value as needed
            child: Image.asset(
              'assets/image/wave.png',
              height: 360,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
