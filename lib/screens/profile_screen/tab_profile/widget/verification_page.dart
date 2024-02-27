import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/color.dart';
import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  var payid;
  var uniqueid;
  bool isLoading = false;
  var userid;
  String? payId;
  late http.Response response; // Initialize as http.Response
  String uid = '';
  String pid = '';

  // Future addData() async {
  //   setState(() {});
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userid = prefs.getString('userid');
  //   var reqData = {
  //     'payId': pid,
  //     'uniqueId': uid,
  //   };
  //
  //   try {
  //     var response = await ProfileService.checkpayid(reqData);
  //     log.i('add member create . $response');
  //
  //     // Check for success in the response and show a success SnackBar
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.data);
  //
  //       if (responseData['sts'] == '01') {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(responseData['msg']),
  //             duration: Duration(seconds: 3),
  //           ),
  //         );
  //       } else {
  //         // Handle other cases if needed
  //       }
  //     } else {
  //       // Handle non-200 status codes
  //       log.e('Request failed with status: ${response.statusCode}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to add member. Please try again.'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     // Handle other errors
  //     log.e('Error adding member: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error adding member. Please try again.'),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }



  Future addmember() async {
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var reqData = {
        'payId': pid,
        'uniqueId': uid,

      };

      var response = await ProfileService.checkpayid(reqData);
      log.i('add member create . $response');

      // Check for success in the response and show a success SnackBar
      if (response['msg'] == 'User Add Successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Bottomnav()),
      // );
    } catch (error) {
      // Handle specific error cases
      if (error.toString().contains("User Already Exist")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Handle other errors
        print('Error: $error');
        // You may choose to show a generic error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  Future<void> fetchBalance() async {
    final url = 'https://pwyfklahtrh.rubideum.net/basic/checkPayIdExist';

    response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "payId": payid,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        uid = data['uniqueId'].toString();
        pid = data['payId'].toString();
      });
    } else {
      print('Failed to load balance: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> _initLoad() async {
    try {
      await fetchBalance();
      // Do additional tasks if needed
    } catch (error) {
      print('Error: $error');
      // Handle errors appropriately, e.g., show an error message to the user
    }
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
      appBar: AppBar(
        title: Text("Verification", style: TextStyle(fontSize: 14)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Please provide your Pay ID from your Rubidium exchange"),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 15,
                    color: bordercolor,
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    payid = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),

            SizedBox(height: 40,),

            Text(
              'Unique ID: $uid',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'P ID: $pid',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            InkWell(
              onTap: () async {
                setState(() {
                  addmember();
                  isLoading = true;
                });
                await _initLoad();
                setState(() {
                  isLoading = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  width: 400,
                  decoration: BoxDecoration(
                    color: bluetext,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(child: Text("Submit", style: TextStyle(fontSize: 12, color: white))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
