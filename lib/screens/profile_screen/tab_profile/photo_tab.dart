import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class PhotoTab extends StatefulWidget {
  const PhotoTab({super.key});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  var userId;
  var profileList;
  bool isLoading = false;
  bool _isLoading = true;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initLoad();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  Future<void> _ProfileImage({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response = await ProfileService.getProfileimage(page: page);
    log.i('Profile Image Loading........: $response');
    setState(() {
      if (profileList == null) {
        profileList = response;
      } else {
        profileList['media'].addAll(response['media']);
      }
    });
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  Future<void> _initLoad() async {
    await _ProfileImage();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _pageNumber++;
      isLoading = true;
    });
    await _ProfileImage(page: _pageNumber);
    setState(() {
      isLoading = false;
    });
  }

  void _toggleLike(int index, String postId) {
    setState(() {
      bool isLiked = profileList['media'][index]['isLiked'] ?? false; // Provide default value of false
      profileList['media'][index]['isLiked'] = !isLiked;
      int likeCount = profileList['media'][index]['likeCount'] ?? 0; // Provide default value of 0
      profileList['media'][index]['likeCount'] = isLiked ? likeCount - 1 : likeCount + 1;
    });
    _addLike(postId, profileList['media'].firstWhere((post) => post['_id'] == postId)['isLiked']);
  }

  @override
  Widget build(BuildContext context) {
    return profileList != null && profileList['media'] != null
        ? GridView.builder(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
      ),
      itemCount: profileList['media'].length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GestureDetector(
            onTap: () {
              List<dynamic> imageUrls =
              profileList['media'].map((item) => item['filePath']).toList();
              int selectedIndex = index;
              _showFullScreenImage(context, imageUrls, selectedIndex, profileList);
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 112,
                    height: 300,
                    child: Image.network(
                      profileList['media'][index]['filePath'],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 78,
                  left: 30,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/heart.svg",
                        height: 18,
                      ),
                      Text(
                        profileList['media'][index]['likeCount'].toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 78,
                  right: 30,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/coment2.svg",
                        height: 18,
                      ),
                      Text(
                        profileList['media'][index]['commentCount'].toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )
        : Center(
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
        "No images available",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls, int initialIndex, dynamic profileList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ScrollController scrollController = ScrollController(initialScrollOffset: initialIndex * 650.0);

        return Scaffold(
          appBar: AppBar(
            title: Text("Posts", style: TextStyle(fontSize: 14)),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: imageUrls.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        _toggleLike(index, profileList['media'][index]['_id']);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onDoubleTap: () {
                                    _toggleLike(index, profileList['media'][index]['_id']);
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: 60),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profileList['media'][index]['firstName'],
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: SizedBox()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Icon(Icons.more_vert, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigate to profile inner page
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            child: Image.network(
                                              profileList['media'][index]['profilePic'],
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
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        profileList['media'][index]['isLiked'] ?? false
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: profileList['media'][index]['isLiked'] ?? false
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      SizedBox(width: 10),

                                      SizedBox(width: 2),
                                      SvgPicture.asset(
                                        "assets/svg/comment.svg",
                                        height: 20,
                                      ),
                                      SizedBox(width: 20),
                                      SvgPicture.asset(
                                        "assets/svg/save.svg",
                                        height: 20,
                                      ),
                                      Expanded(child: SizedBox()),
                                      SvgPicture.asset(
                                        "assets/svg/share.svg",
                                        height: 20,
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Text("Likes", style: TextStyle(color: Colors.blue, fontSize: 10)),

                                      Text(
                                        profileList['media'][index]['likeCount'].toString(),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      SizedBox(width: 2),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
