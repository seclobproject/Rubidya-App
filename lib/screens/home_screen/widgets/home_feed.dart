import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class homefeed extends StatefulWidget {
  const homefeed({super.key});

  @override
  State<homefeed> createState() => _homefeedState();
}

class _homefeedState extends State<homefeed> {


  bool isFavorite = false;
  var userid;
  var profiledetails;
  var profilelist;
  var suggestfollow;
  bool isLoading = false;
  bool _isLoading = true;


  bool isFollowing = false;


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
        _profileapi(),

      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: profilelist != null && profilelist['media'] != null ? profilelist['media'].length : 0,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            width: 345,
            height: 517,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.1,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 50,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profilelist != null && profilelist['media'] != null && profilelist['media'][index]['userId']['firstName'] != null ? profilelist['media'][index]['userId']['firstName'] : '', // Use empty string if value is null
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text("5h ago", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Icon(Icons.more_vert, color: Colors.grey,),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Stack(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              child: Image.network(
                                'https://stimg.cardekho.com/images/carexteriorimages/930x620/Skoda/Octavia/7514/1607588488757/front-left-side-47.jpg',
                                height: 51,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 28,
                            left: 28,
                            child: Image.asset('assets/image/verificationlogo.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      // child: YoutubePlayer(
                      //   controller: _controller,
                      //   showVideoProgressIndicator: true,
                      //   onReady: () {
                      //
                      //     // Do something when the video is ready to play
                      //   },
                      // ),
                      child: Image.network(
                        profilelist != null && profilelist['media'] != null && profilelist['media'][index]['filePath'] != null ? '$baseURL/' + profilelist['media'][index]['filePath'] : '',
                        fit: BoxFit.cover,
                        height: 400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 25,
                        ),
                        onPressed: () {
                          // Handle like button tap
                        },
                      ),
                      Text("Liked by", style: TextStyle(color: Colors.blue, fontSize: 10)),
                      SizedBox(width: 2,),
                      Text("Faizal", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
                      SizedBox(width: 2,),
                      Text("78 others", style: TextStyle(color: Colors.blue, fontSize: 10)),
                      Expanded(child: SizedBox()),
                      SvgPicture.asset(
                        "assets/svg/comment.svg",
                        height: 20,
                      ),
                      SizedBox(width: 20,),
                      SvgPicture.asset(
                        "assets/svg/share.svg",
                        height: 20,
                      ),
                      SizedBox(width: 20,),
                      SvgPicture.asset(
                        "assets/svg/save.svg",
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );


  }
}
