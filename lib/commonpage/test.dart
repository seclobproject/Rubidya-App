import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart'; // Import the necessary package for debouncing

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isLoading = false;

  void deductbalance() {
    // Your deductbalance logic goes here
    // This is just a placeholder function
    print('Deducting balance...');
  }

  void _handleTap() {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Debounce the deductbalance function with a delay of 2000 milliseconds (2 seconds)
    EasyDebounce.debounce(
      'deductbalance', // unique ID for debounce
      Duration(milliseconds: 2000),
      deductbalance,
    );

    // After 3 seconds, hide the loading indicator
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100,),

      Center(
        child: InkWell(
        onTap: isLoading ? null : _handleTap, // Prevent tapping when loading
          child: Container(
            height: 36,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.blue, // Change to your desired color
              border: Border.all(color: Colors.white, width: .3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pay from wallet",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        ],
      ),

    );

  }
}

