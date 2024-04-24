import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import '../inner_page/profile_inner_page.dart';


class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowersList> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  late SharedPreferences prefs;

  late List<Map<String, dynamic>> followingList = [];
  int _pageNumber = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

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
    var response = await HomeService.followersList(page: _pageNumber);
    log.i('Following list details show.. $response');
    setState(() {
      followingList.addAll(List<Map<String, dynamic>>.from(response['followers']));
      _isLoading = false; // Set loading state to false once data is loaded
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await HomeService.followersList(page: _pageNumber + 1);
      final List<Map<String, dynamic>> newFollowingList = List<Map<String, dynamic>>.from(response['following']);
      setState(() {
        _pageNumber++;
        _isLoadingMore = false;
        followingList.addAll(newFollowingList);

        if (newFollowingList.isEmpty) {
          _hasMore = false;
        }
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      if (followingList[index]['isFollowing'] != null) {
        followingList[index]['isFollowing'] = !followingList[index]['isFollowing'];
      }
    });

    var followerId = followingList[index]['_id'];
    if (followingList[index]['isFollowing'] != null && followingList[index]['isFollowing']) {
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
        actions: [],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(), // Display circular indicator while loading
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 400,
              height: 40,
              decoration: BoxDecoration(
                color: blackshade,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                controller: _searchController,
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
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update the filtered list
                },
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_isLoadingMore &&
                  scrollInfo.metrics.pixels == 0 &&
                  _hasMore) {
                _loadMoreData();
              }
              return true;
            },
            child: Expanded(
              child: ListView.builder(
                itemCount: followingList.length,
                itemBuilder: (BuildContext context, int index) {
                  // Check if the name contains the search query
                  bool matchesSearch = followingList[index]['firstName']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());

                  // Only display the item if it matches the search query
                  if (!matchesSearch) return SizedBox.shrink();

                  return MembersListing(
                    name: followingList[index]['firstName'],
                    id: followingList[index]['_id'], // assuming _id is a String
                    img: followingList[index]['profilePic'] != null
                        ? followingList[index]['profilePic']['filePath']
                        : '',
                    onFollowToggled: () => toggleFollow(index),
                  );
                },
              ),
            ),
          ),
          _isLoadingMore
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox(),
        ],
      ),
    );
  }
}

class MembersListing extends StatefulWidget {
  const MembersListing({
    required this.name,
    required this.img,
    required this.id, // changed type to String
    required this.onFollowToggled,
    Key? key,
  }) : super(key: key);

  final String name;
  final String img;
  final String id; // changed type to String
  final VoidCallback onFollowToggled;

  @override
  _MembersListingState createState() => _MembersListingState();
}

class _MembersListingState extends State<MembersListing> {
  bool isFollowing = false;

  Future<void> _toggleFollowStatus() async {
    if (widget.id != null) {
      if (isFollowing) {
        // Unfollow logic
        var reqData = {
          'followerId': widget.id!,
        };
        var response = await HomeService.unfollow(reqData);
        log.i('Unfollowed Done...... $response');
      } else {
        // Follow logic
        // Add your follow logic here
      }
      setState(() {
        isFollowing = !isFollowing; // Toggle follow status
      });
      widget.onFollowToggled(); // Notify parent widget about follow status change
    } else {
      print("Error: widget.id is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => profileinnerpage(
              id: widget.id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: widget.img.isNotEmpty
                        ? Image.network(
                      widget.img,
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
                ),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _toggleFollowStatus,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: buttoncolor,
                      ),
                      child: Text(
                        isFollowing ? "unfollow" : "following", // Toggle text based on follow status
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
              child: Divider(
                color: Colors.black,
                thickness: .1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
