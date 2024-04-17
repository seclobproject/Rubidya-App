import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Floating Action Button with Circular Menu'),
      ),
      body: Center(
        child: Text('Press the FAB'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: IconThemeData(size: 20.0),
        backgroundColor: Colors.white,
        visible: true,
        curve: Curves.bounceIn,
        children: [

          SpeedDialChild(
            child: Icon(Icons.photo_camera_back_rounded),
            backgroundColor: Colors.white,
            onTap: () {
              // Add functionality for the first button
            },
            label: 'Gellary',

            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.white,
          ),


          SpeedDialChild(
            child: Icon(Icons.camera),
            backgroundColor: Colors.white,
            onTap: () {
              // Add functionality for the second button
            },
            label: 'Camara',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.white,
          ),
          // Add more SpeedDialChild widgets for additional menu items
        ],
      ),
    );
  }
}
