import 'package:flutter/material.dart';

class homestory extends StatefulWidget {
  const homestory({super.key});

  @override
  State<homestory> createState() => _homestoryState();
}

class _homestoryState extends State<homestory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,

      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(100)
                ),
                child: Image.network(
                  'https://assets.vogue.in/photos/5d288836e2f0130008fa5d30/1:1/w_1080,h_1080,c_limit/model%20nidhi%20sunil.jpg',
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10,),
              Text("Samuel", style: TextStyle(fontSize:10),)
            ],
          ),
        );
      },
    );
  }
}
