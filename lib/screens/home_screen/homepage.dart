import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/home_screen/widgets/home_feed.dart';
import 'package:rubidya/screens/home_screen/widgets/home_follow.dart';
import 'package:rubidya/screens/home_screen/widgets/home_story.dart';
import 'package:rubidya/screens/home_screen/widgets/referral_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:favorite_button/favorite_button.dart';
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
  late List<Map<String, dynamic>> Homefeed = [];
  var userId;
  var profileDetails;
  var homeList;
  bool isExpanded = false;
  bool isFollowing = false;
  int _pageNumber = 1;
  late SharedPreferences prefs;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  late List<Map<String, dynamic>> suggestFollow = [];




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

  // Future _homefeed() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userid = prefs.getString('userid');
  //   var response = await HomeService.getFeed();
  //   log.i('homefeed data Show.. $response');
  //   setState(() {
  //     profilelist = response; // This line is causing the error
  //   });
  // }

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

  // Future<void> _homeFeedList() async {
  //   var response = await HomeService.getFeed(page: _pageNumber);
  //   log.i('Following list details show.. $response');
  //   setState(() {
  //     Homefeed.addAll(List<Map<String, dynamic>>.from(response['posts']));
  //     _isLoading = false; // Set loading state to false once data is loaded
  //   });
  // }


  // Future<void> _homeFeed() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userId = prefs.getString('userId');
  //   var response = await HomeService.getFeed();
  //   log.i('Home feed data: $response');
  //   setState(() {
  //     homeList = response;
  //   });
  // }
  Future<void> _initLoad() async {
    prefs = await SharedPreferences.getInstance();
    await _homeFeed();
    await _profiledetailsapi();
    await _profileapi();
    await _suggestfollowlist();
    await _homeFeed();
  }


  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await HomeService.getFeed(page: _pageNumber + 1);
      final List<Map<String, dynamic>> newFollowingList = List<Map<String, dynamic>>.from(response['posts']);
      setState(() {
        _pageNumber++;
        _isLoadingMore = false;
        Homefeed.addAll(newFollowingList);

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

  // Future _initLoad() async {
  //   await Future.wait([
  //     _profiledetailsapi(),
  //     _profileapi(),
  //     _suggestfollowlist(),
  //     _homefeed()
  //
  //   ]);
  //   _isLoading = false;
  // }

  @override
  void initState() {
    _initLoad();
    _homeFeed();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _refresh() async {
    await _profiledetailsapi();
    await _profileapi();
    await _homeFeed();
    await _suggestFollowList();
    setState(() {
      _isLoading = false;
    });
  }


  ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   _initLoad();
  //   _scrollController.addListener(_scrollListener);
  //   super.initState();
  // }

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

  Future<void> _suggestFollowList() async {
    var response = await HomeService.usersuggetionlistfollow();
    log.i('refferal details show.. $response');
    setState(() {
      suggestFollow = List<Map<String, dynamic>>.from(response['result']);
    });
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


  // Future<void> _initLoad() async {
  //   await _homeFeed();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.1,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Spacer(),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Homepages()),
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
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: homestory(), // Assuming homestory is a custom widget
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "New People",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue, // Assuming bluetext is defined
                  ),
                ),
              ),
              SizedBox(height: 15),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(height: 160, child: HomeFollow()),
              ),
              SizedBox(height: 15),


              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: homeList != null && homeList['posts'] != null ? homeList['posts'].length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ProductCard(
                        createdTime: _calculateTimeDifference(homeList['posts'][index]['createdAt']),
                        name: homeList['posts'][index]['username'] ?? '',
                        description: homeList['posts'][index]['description'] ?? '',
                        likes: homeList['posts'][index]['likeCount']?.toString() ?? '',
                        img: homeList['posts'][index]['filePath'] ?? '',
                        profilepic: homeList['posts'][index]['filePath'] ?? '',
                        likedby: homeList['posts'][index]['lastLikedUserName'] ?? '',
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
                      if (isLoading && index == homeList['posts'].length - 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
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
    required this.likedby,
    required this.description,
    required this.onLikePressed,
    required this.onDoubleTapLike,
  }) : super(key: key);

  final String img;
  final String name;
  final String createdTime;
  final String id;
  final String userId;
  final String likedby;
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
                            widget.profilepic,
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
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Image.network(
              widget.img,
              fit: BoxFit.fill,
              // height: 400,
            ),
          ),

          SizedBox(height: 10,),


          Padding(
            padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FavoriteButton(
                      iconSize: 40,
                      isFavorite: widget.likeCount,
                      iconDisabledColor: Colors.black26,
                      valueChanged: (_) {
                        widget.onLikePressed(); // Call the callback function when like button is pressed
                      },
                    ),
                    SizedBox(width: 20),

                    SvgPicture.asset(
                      "assets/svg/comment.svg",
                      height: 20,
                    ),
                    SizedBox(width: 20),
                    SvgPicture.asset(
                      "assets/svg/save.svg",
                      height: 20,
                    ),
                    SizedBox(width: 20),

                    Expanded(child: SizedBox()),

                    SvgPicture.asset(
                      "assets/svg/share.svg",
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: bluetext,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: "Liked by ",
                            style: TextStyle(

                            ),
                          ),
                          TextSpan(
                            text: "${widget.likedby}",
                            style: TextStyle(
                              color: bluetext,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          TextSpan(
                            text: " and",
                            style: TextStyle(
                              color: bluetext,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 2),
                    Text( "${widget.likes} Others ",
                        style: TextStyle(
                            color: bluetext,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 2),
                  ],
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: isExpanded ? null : 40, // Adjust height when expanded
                child: Text(
                  widget.description,
                  maxLines: isExpanded ? null : 2,
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700),
                ),
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