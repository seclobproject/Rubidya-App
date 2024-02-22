import 'package:flutter/material.dart';

import '../resources/color.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [

          SizedBox(height: 150,),
          Center(
            child: Image.asset(
              'assets/image/forgottbg.png',
            ),
          ),
          
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text("Forgot Password",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: bluetext),)),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text("To reset your password, enter your email id and verify",style: TextStyle(fontSize: 12),)),
          ),

          SizedBox(height: 10,),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                hintStyle: TextStyle(color: textblack,fontSize: 12),
                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: bordercolor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: bordercolor),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  size: 15,// You can replace 'Icons.email' with the icon you want
                  color: bordercolor,
                ),
              ),

              onChanged: (text) {
                setState(() {

                });
              },
              style: TextStyle(color: textblack,fontSize: 14),
            ),
          ),


          SizedBox(height: 20,),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 48,
              width: 400,
              decoration: BoxDecoration(
                  color: buttoncolor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text("Submit",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,color: white),),
              ),

            ),
          ),

          SizedBox(height: 40,),



        ],
      ),
    );
  }
}
