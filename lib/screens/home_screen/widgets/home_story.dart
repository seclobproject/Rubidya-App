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
                  'https://t4.ftcdn.net/jpg/04/75/01/23/360_F_475012363_aNqXx8CrsoTfJP5KCf1rERd6G50K0hXw.jpg',
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10,),
              Text("Processing", style: TextStyle(fontSize:10),)
            ],
          ),
        );
      },
    );
  }
}
