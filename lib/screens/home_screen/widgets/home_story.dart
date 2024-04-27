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
                  'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10,),
              Text("Loading...", style: TextStyle(fontSize:10),)
            ],
          ),
        );
      },
    );
  }
}
