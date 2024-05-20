import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/trending_screen/trendingpage.dart';

class TrendingList extends StatelessWidget {
  // Define a list of avatar image URLs
  final List<String> avatarImages = [
    'assets/image/applogoicon.png', // Replace with your image URLs
    'assets/image/applogoicon.png',
    'assets/image/applogoicon.png',
    // Add more URLs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white, // This removes the back arrow button
        title: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Text(
            "Trending",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: bluetext, // Assuming bluetext is a defined color
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 254,
                    color: bluetext,
                    child: Center(
                      child: ProfileCard(),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 254,
                    color: bluetext,
                    child: Center(
                      child: ProfileCard(),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 254,
                    color: bluetext,
                    child: Center(
                      child: ProfileCard(),
                    ),
                  ),
                ),
              ],
            ),
             // Adding space between the Row and ListView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: ListView.builder(
                    itemCount: 10, // Assuming there are 10 items in the list
                    itemBuilder: (BuildContext context, int index) {
                      String number = (index + 1).toString();
                      String name = "User $number";
                      String points = ((index + 1) * 100).toString();
                      return Container(
                        color: Color(0xFFE6E8F4), 
                        child: ListTile(
                          title: Container(
                            height: 50,
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: white,
                              
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10,),
                                Text(
                                  "$number ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: bluetext
                                  ),
                                ),
                                CircleAvatar(
                                  // You can add avatar image here
                                  backgroundImage: AssetImage(avatarImages[index % avatarImages.length]),
                                ),
                                SizedBox(width: 10), // Add space between the avatar and the name
                                Text(
                                  "$name ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: bluetext,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Spacer(), // Add a spacer to push the points to the end
                                Text(
                                  "$points Pts",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: bluetext,
                                    fontWeight: FontWeight.w800
                                  ),
                                ),
                                SizedBox(width: 20,)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}















class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 180,
        width: 100, // Adjusted width for better text fitting
        decoration: BoxDecoration(
          
          color: bluetext, // Changed 'blueshade' to 'Colors.blue.shade400'
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2.0), // Adjust padding as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "assets/image/congratulation.png",
                    height: 110,
                    width: 150,
                  ),
                ),
                Positioned(
                  top: 20, // Adjust position as needed
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                     // Change to your desired color
                    
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: blueshade, // Changed 'blueshade' to 'Colors.blue.shade400'
                    border: Border.all(width: 5, color: bluetext), // Changed 'bluetext' to 'Colors.blueAccent'
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: blueshade, // Changed 'bluetext' to 'Colors.blueAccent'
                    backgroundImage: NetworkImage(
                        "https://www.befunky.com/images/wp/wp-2021-01-linkedin-profile-picture-focus-face.jpg?auto=avif,webp&format=jpg&width=1200"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0),
            Text(
              "Lachu",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Points: 876 ",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SvgPicture.asset("assets/svg/ratingstar.svg", height: 8),
                SizedBox(width: 3),
                SvgPicture.asset("assets/svg/ratingstar.svg", height: 8),
              ],
            ),
            SizedBox(height: 10),
           
          ],
        ),
      ),
    );
  }
}
