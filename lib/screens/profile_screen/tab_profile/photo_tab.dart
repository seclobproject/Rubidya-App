import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/color.dart';
class phototab extends StatefulWidget {
  const phototab({super.key});

  @override
  State<phototab> createState() => _phototabState();
}

class _phototabState extends State<phototab> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // You can adjust the number of columns as needed
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 10, // Adjust the number of items as needed
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 112,
                  height: 200,
                  child: Image.network(
                    'https://burst.shopifycdn.com/photos/model-in-gold-fashion.jpg?width=1000&format=pjpg&exif=0&iptc=0',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 85,
                left: 30,
                child:Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/heart.svg",
                      height: 18,
                    ),
                    Text("1.5k",style: TextStyle(fontSize: 10,color: white),)
                  ],
                ),
              ),
              Positioned(
                top: 85,
                right: 30,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/coment2.svg",
                      height: 18,
                    ),
                    Text("200",style: TextStyle(fontSize: 10,color: white),)
                  ],
                ),
                ),

            ],
          );
        },
      ),
    );
  }
}


