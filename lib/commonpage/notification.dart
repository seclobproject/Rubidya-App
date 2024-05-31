import 'package:flutter/material.dart';

class notificationpage extends StatefulWidget {
  const notificationpage({super.key});

  @override
  State<notificationpage> createState() => _notificationpageState();
}

class _notificationpageState extends State<notificationpage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      appBar: AppBar(
        automaticallyImplyLeading: false, // This will add a default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start
          ,
          children: [
            Text("Notifications", style: TextStyle(fontSize: 14),),
          ],
        ),
      ),
      body: Center(
        child: Text("The Notification feature Will be Released Soon..."),
      ),

    );
  }
}