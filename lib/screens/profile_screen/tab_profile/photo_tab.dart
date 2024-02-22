import 'package:flutter/material.dart';

class phototab extends StatefulWidget {
  const phototab({super.key});

  @override
  State<phototab> createState() => _phototabState();
}

class _phototabState extends State<phototab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: [
          Expanded(
            child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: const Icon(Icons.list),
                  trailing: const Text(
                    "GFG",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  title: Text("List item $index"));
            }),
          ),
    
        ],
      ),
      
    );
  }
}
