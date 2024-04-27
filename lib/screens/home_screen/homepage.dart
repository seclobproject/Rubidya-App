import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/home_screen/widgets/home_feed.dart';
import 'package:rubidya/screens/home_screen/widgets/home_follow.dart';
import 'package:rubidya/screens/home_screen/widgets/home_story.dart';
import 'package:rubidya/screens/home_screen/widgets/referral_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commonpage/test.dart';
import '../../networking/constant.dart';
import '../../services/home_service.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../profile_screen/inner_page/profile_inner_page.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool isFavorite = false;
  var userid;
  var profiledetails;
  var profilelist;
  var suggestfollow;
  bool isLoading = false;
  bool _isLoading = true;
  late YoutubePlayerController _controller;

  bool isFollowing = false;
  void toggleFollow() {
    setState(() {
      if (isFollowing) {
        isFollowing = false;
        print("follow");
      } else {
        isFollowing = true;
        print("unfollow");
      }
    });
  }

  Future _profileapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfileimage();
    log.i('profile data Show.. $response');
    setState(() {
      profilelist = response; // This line is causing the error
    });
  }

  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future _homefeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await HomeService.getFeed();
    log.i('homefeed data Show.. $response');
    setState(() {
      profilelist = response; // This line is causing the error
    });
  }

  Future _suggestfollowlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await HomeService.usersuggetionlistfollow();
    log.i('refferal details show.. $response');
    setState(() {
      suggestfollow = response;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _initLoad() async {
    await Future.wait([
      _profiledetailsapi(),
      _profileapi(),
      _suggestfollowlist(),
      _homefeed()
    ]);
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    _controller = YoutubePlayerController(
      initialVideoId: 'dpm2FUS8oWU', // Use only the video ID here
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
      ),
    );
    super.initState();
  }

  Future<void> _refresh() async {
    await _profiledetailsapi();
    await _profileapi();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.1,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation(bluetext),
        ),
      )
          : RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo/logo4.png',
                      fit: BoxFit.cover,
                      width: 150,
                    ),
                    Expanded(child: SizedBox()),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  ExpandableText()),
                        // );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/massage.svg",
                      ),
                    ),
                    SizedBox(width: 20),
                    SvgPicture.asset(
                      "assets/svg/notification.svg",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  height: 109,
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
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    child: homestory(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "New People",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: bluetext,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(height: 160, child: HomeFollow()),
              ),
              SizedBox(height: 15),
              HomeFeed(),
            ],
          ),
        ),
      ),
    );
  }
}
