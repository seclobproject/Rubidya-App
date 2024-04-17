import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';


class phototab extends StatefulWidget {
  const phototab({super.key});

  @override
  State<phototab> createState() => _phototabState();
}

class _phototabState extends State<phototab> {


  var userid;
  var profilelist;
  bool isLoading = false;


  Future _profileapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfileimage();
    log.i('profile data Show.. $response');
    setState(() {
      profilelist = response; // This line is causing the error
    });
  }



  Future _initLoad() async {
    await Future.wait(
      [
        _profileapi()
      ],
    );
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initLoad();
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: profilelist != null && profilelist['media'] != null
          ? GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: profilelist['media'].length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 112,
                  height: 200,
                  child: Image.network(
                    '$baseURL/' + profilelist['media'][index]['filePath'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 85,
                left: 30,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/heart.svg",
                      height: 18,
                    ),
                    Text(
                      profilelist['media'][index]['likeCount'].toString(),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    )
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
                    Text(
                      "200",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      )
          : Center(
        // Show a placeholder or message when there is no data
        child: Text("No data available",style: TextStyle(color: textblack),),
      ),
    );

  }
}


