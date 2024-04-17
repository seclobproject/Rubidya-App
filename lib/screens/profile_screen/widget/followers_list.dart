import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:favorite_button/favorite_button.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  bool _isLoading = true;
  late SharedPreferences prefs;
  late List<Map<String, dynamic>> followerList = [];

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  Future<void> _initLoad() async {
    prefs = await SharedPreferences.getInstance();
    await _followingFollowList();
  }

  Future<void> _followingFollowList() async {
    var response = await HomeService.followersList();
    log.i('Following list details show.. $response');
    setState(() {
      followerList = List<Map<String, dynamic>>.from(response['followers']);
      _isLoading = false; // Set loading state to false once data is loaded
    });
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      followerList[index]['isFollowing'] = !followerList[index]['isFollowing'];
    });

    var followerId = followerList[index]['_id'];
    if (followerList[index]['isFollowing']) {
      await follow(followerId);
    } else {
      await unfollow(followerId);
    }
  }

  Future<void> follow(String followerId) async {
    var reqData = {'followerId': followerId};
    var response = await HomeService.follow(reqData);
    log.i('add to follow. $response');
  }

  Future<void> unfollow(String followerId) async {
    var reqData = {'followerId': followerId};
    var response = await HomeService.unfollow(reqData);
    log.i('removed from follow. $response');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers List", style: TextStyle(fontSize: 14)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show circular loading indicator if data is still loading
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: followerList.length,
              itemBuilder: (BuildContext context, int index) {
                return MembersListing(
                  name: followerList[index]['firstName'],
                  status: followerList[index]['isFollowing'],
                  img: followerList[index]['profilePic'] != null
                      ? '${baseURL}/${followerList[index]['profilePic']['filePath']}'
                      : '',
                  onFollowToggled: () => toggleFollow(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MembersListing extends StatelessWidget {
  const MembersListing({
    required this.name,
    required this.img,
    required this.status,
    required this.onFollowToggled,
    Key? key,
  }) : super(key: key);

  final String name;
  final String img;
  final bool status;
  final VoidCallback onFollowToggled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: img.isNotEmpty
                    ? Image.network(
                  img,
                  height: 65,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 65,
                  height: 65,
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small/user-profile-icon-free-vector.jpg',
                  ),
                ),
              ),
              SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11),
                ),
              ),
              Expanded(child: SizedBox()),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: onFollowToggled,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: status ? bluetext : buttoncolor,
                    ),
                    child: Text(
                      status ? 'Following' : 'Follow Back',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(color: Colors.black, thickness: .1),
          )
        ],
      ),
    );
  }
}

