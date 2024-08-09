import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:favorite_button/favorite_button.dart';

import '../../services/search_service.dart';
import '../profile_screen/inner_page/profile_inner_page.dart';

class searchpage extends StatefulWidget {
  const searchpage({Key? key}) : super(key: key);

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  bool isLoading = false;
  late SharedPreferences prefs;
  late List<Map<String, dynamic>> searchlist = [];
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _hasMoreData = true;
  String _searchQuery = '';

  @override
  void initState() {
    _initLoad();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initLoad() async {
    prefs = await SharedPreferences.getInstance();
    await _searchFollowList();
  }

  Future<void> _searchFollowList() async {
    if (!isLoading && _hasMoreData) {
      setState(() {
        isLoading = true;
      });
      try {
        var response = await SearchService.searchpage(page: _currentPage, search: _searchQuery);
        if (mounted) {
          setState(() {
            if (_currentPage == 1) {
              searchlist = List<Map<String, dynamic>>.from(response['users']);
            } else {
              searchlist.addAll(List<Map<String, dynamic>>.from(response['users']));
            }
            // Ensure 'isFollowing' is not null by providing a default value
            for (var user in searchlist) {
              if (user['isFollowing'] == null) {
                user['isFollowing'] = false;
              }
            }
            _hasMoreData = response['users'].length > 0;
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching search data: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      searchlist[index]['isFollowing'] = !searchlist[index]['isFollowing'];
    });

    var followerId = searchlist[index]['_id'];
    if (searchlist[index]['isFollowing']) {
      await follow(followerId);
    } else {
      await unfollow(followerId);
    }
  }

  Future<void> follow(String followerId) async {
    var reqData = {
      'followerId': followerId};
    var response = await HomeService.follow(reqData);
    log.i('add to follow. $response');
  }

  Future<void> unfollow(String followerId) async {
    var reqData = {'followerId': followerId};
    var response = await HomeService.unfollow(reqData);
    log.i('removed from follow. $response');
  }

  void _onSearchTextChanged(String text) {
    if (mounted) {
      setState(() {
        _searchQuery = text;
        _currentPage = 1;
        _hasMoreData = true;
        _searchFollowList();
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMoreData) {
      _currentPage++;
      _searchFollowList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search", style: TextStyle(fontSize: 14)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: 400,
              height: 40,
              decoration: BoxDecoration(
                color: blackshade,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  suffixIcon: Icon(Icons.search),
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: searchlist.isEmpty && _searchController.text.isNotEmpty && !isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'No results found',
                style: TextStyle(
                  color: greybg,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: searchlist.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == searchlist.length) {
                  return isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                return MembersListing(
                  name: searchlist[index]['firstName'],
                  id: searchlist[index]['_id'],
                  status: searchlist[index]['isFollowing'],
                  img: searchlist[index]['profilePic'] != null
                      ? searchlist[index]['profilePic']['filePath']
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
  final String id;
  final bool status;
  final VoidCallback onFollowToggled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => profileinnerpage(id: id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                        status ? 'Unfollow' : 'Follow',
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