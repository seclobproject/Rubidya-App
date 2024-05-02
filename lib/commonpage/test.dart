import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rubidya/services/home_service.dart';
import 'package:rubidya/screens/profile_screen/inner_page/profile_inner_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/color.dart';
import '../support/logger.dart';
import 'package:favorite_button/favorite_button.dart';

class Homepages extends StatefulWidget {
  const Homepages({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepages> {
  var userId;
  var profileDetails;
  var homeList;
  bool isLoading = false;
  bool _isLoading = true;
  bool isExpanded = false;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _initLoad();
    _scrollController.addListener(_scrollListener);
    super.initState();
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

  Future<void> _homeFeed({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response = await HomeService.getFeed(page: page);
    log.i('Home feed data: $response');
    setState(() {
      if (homeList == null) {
        homeList = response;
      } else {
        homeList['posts'].addAll(response['posts']);
      }
    });
  }

  Future<void> _initLoad() async {
    await _homeFeed();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _pageNumber++;
      isLoading = true;
    });
    await _homeFeed(page: _pageNumber);
    setState(() {
      isLoading = false;
    });
  }

  String _calculateTimeDifference(String createdAt) {
    DateTime createdDateTime = DateTime.parse(createdAt);
    Duration difference = DateTime.now().difference(createdDateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  void _toggleLikePost(String postId) {
    setState(() {
      bool isLiked = !homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked'];
      homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked'] = isLiked;
      int likeCount = homeList['posts'].firstWhere((post) => post['_id'] == postId)['likeCount'];
      homeList['posts'].firstWhere((post) => post['_id'] == postId)['likeCount'] = isLiked ? likeCount + 1 : likeCount - 1;
    });
    _addLike(postId, homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked']);
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Feed'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        controller: _scrollController,
        itemCount: homeList != null && homeList['posts'] != null ? homeList['posts'].length : 0,
        itemBuilder: (BuildContext context, int index) {
          if (index == homeList['posts'].length - 1) {
            return Column(
              children: [
                ProductCard(
                  createdTime: _calculateTimeDifference(homeList['posts'][index]['createdAt']),
                  name: homeList['posts'][index]['username'] ?? '',
                  description: homeList['posts'][index]['description'] ?? '',
                  likes: homeList['posts'][index]['likeCount']?.toString() ?? '',
                  img: homeList['posts'][index]['filePath'] ?? '',
                  profilepic: homeList['posts'][index]['profilePic']?['filePath'] ?? '',
                  id: homeList['posts'][index]['_id'] ?? '',
                  userId: homeList['posts'][index]['userId'] ?? '',
                  likeCount: homeList['posts'][index]['isLiked'] ?? false,
                  onLikePressed: () {
                    _toggleLikePost(homeList['posts'][index]['_id']);
                  },
                  onDoubleTapLike: () {
                    _toggleLikePost(homeList['posts'][index]['_id']);
                  },
                ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          } else {
            return ProductCard(
              createdTime: _calculateTimeDifference(homeList['posts'][index]['createdAt']),
              name: homeList['posts'][index]['username'] ?? '',
              description: homeList['posts'][index]['description'] ?? '',
              likes: homeList['posts'][index]['likeCount']?.toString() ?? '',
              img: homeList['posts'][index]['filePath'] ?? '',
              profilepic: homeList['posts'][index]['profilePic']?['filePath'] ?? '',
              id: homeList['posts'][index]['_id'] ?? '',
              userId: homeList['posts'][index]['userId'] ?? '',
              likeCount: homeList['posts'][index]['isLiked'] ?? false,
              onLikePressed: () {
                _toggleLikePost(homeList['posts'][index]['_id']);
              },
              onDoubleTapLike: () {
                _toggleLikePost(homeList['posts'][index]['_id']);
              },
            );
          }
        },
      ),
    );
  }
}


class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.img,
    required this.profilepic,
    required this.name,
    required this.likes,
    required this.createdTime,
    required this.id,
    required this.userId,
    required this.likeCount,
    required this.description,
    required this.onLikePressed,
    required this.onDoubleTapLike,
  }) : super(key: key);

  final String img;
  final String name;
  final String createdTime;
  final String id;
  final String userId;
  final String likes;
  final String profilepic;
  final String description;
  final bool likeCount;

  final VoidCallback onLikePressed;
  final VoidCallback onDoubleTapLike;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTapLike, // Handle double tap here
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onDoubleTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.createdTime,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => profileinnerpage(
                        id: widget.userId,
                      ),
                    ),
                  );
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
                          color: Colors.transparent, // Set background color to transparent
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Image.network(
                            'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
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
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Image.network(
              widget.img,
              fit: BoxFit.fill,
              // height: 400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
            child: Row(
              children: [
                FavoriteButton(
                  iconSize: 40,
                  isFavorite: widget.likeCount,
                  iconDisabledColor: Colors.black26,
                  valueChanged: (_) {
                    widget.onLikePressed(); // Call the callback function when like button is pressed
                  },
                ),
                SizedBox(width: 10),
                Text("Likes", style: TextStyle(color: Colors.blue, fontSize: 10)),
                SizedBox(width: 2),
                Text(widget.likes, style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(width: 2),
                Expanded(child: SizedBox()),
                SvgPicture.asset(
                  "assets/svg/comment.svg",
                  height: 20,
                ),
                SizedBox(width: 20),
                SvgPicture.asset(
                  "assets/svg/share.svg",
                  height: 20,
                ),
                SizedBox(width: 20),
                SvgPicture.asset(
                  "assets/svg/save.svg",
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: isExpanded ? null : 40, // Adjust height when expanded
              child: Text(
                widget.description,
                maxLines: isExpanded ? null : 2,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),

          if (widget.description.split('\n').length > 2) // Check for multiline
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded; // Toggle the isExpanded state
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    isExpanded ? 'See Less' : 'See More',
                    style: TextStyle(color: bluetext, fontSize: 8),
                  ),
                ),
              ),
            ),




          SizedBox(height: 15,)
        ],
      ),
    );
  }
}





