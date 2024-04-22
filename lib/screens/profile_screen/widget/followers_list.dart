import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:favorite_button/favorite_button.dart';

import '../inner_page/profile_inner_page.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  bool _isLoading = true;
  late SharedPreferences prefs;
  late List<Map<String, dynamic>> followerList = [];
  late List<Map<String, dynamic>> filteredList = [];

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
      filteredList = followerList; // Initialize filtered list with all followers initially
      _isLoading = false; // Set loading state to false once data is loaded
    });
  }

  void _filterList(String searchText) {
    setState(() {
      filteredList = followerList.where((follower) {
        final name = follower['firstName'].toString().toLowerCase();
        return name.contains(searchText.toLowerCase());
      }).toList();
    });
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      filteredList[index]['isFollowing'] = !filteredList[index]['isFollowing'];
    });

    var followerId = filteredList[index]['_id'];
    if (filteredList[index]['isFollowing']) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 40,
              decoration: BoxDecoration(
                  color: blackshade,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey, // You can adjust the hint text color
                    fontSize: 14, // You can adjust the font size of the hint text
                  ),
                  border: InputBorder.none, // Remove the border
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  suffixIcon: Icon(Icons.search),
                  // Center align the hint text
                ),
                onChanged: _filterList,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return MembersListing(
                  name: filteredList[index]['firstName'],
                  id: filteredList[index]['_id'],
                  status: filteredList[index]['isFollowing'],
                  img: filteredList[index]['profilePic'] != null
                      ? '${baseURL}/${filteredList[index]['profilePic']['filePath']}'
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
    required this.id,
    required this.onFollowToggled,
    Key? key,
  }) : super(key: key);

  final String name;
  final String img;
  final bool status;
  final String id;
  final VoidCallback onFollowToggled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  profileinnerpage(
            id: id,
          )),
        );
      },
      child: Padding(
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
      ),
    );
  }
}
