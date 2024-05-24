import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/home_screen/widgets/comment_home.dart';

import 'package:rubidya/screens/home_screen/widgets/home_story.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/home_service.dart';

import '../../support/logger.dart';
import '../profile_screen/inner_page/profile_inner_page.dart';
import '../search_screen/searchpage.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  late SharedPreferences prefs;

  late List<Map<String, dynamic>> suggestFollow = [];

  Future<void> _suggestFollowList() async {
    var response = await HomeService.usersuggetionlistfollow();
    log.i('refferal details show.. $response');
    setState(() {
      suggestFollow = List<Map<String, dynamic>>.from(response['result']);
    });
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      suggestFollow[index]['isFollowing'] =
          !suggestFollow[index]['isFollowing'];
    });

    var followerId = suggestFollow[index]['_id'];
    if (suggestFollow[index]['isFollowing']) {
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
    prefs = await SharedPreferences.getInstance();
    await _suggestFollowList();
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
      bool isLiked = !homeList['posts']
          .firstWhere((post) => post['_id'] == postId)['isLiked'];
      homeList['posts'].firstWhere((post) => post['_id'] == postId)['isLiked'] =
          isLiked;
      int likeCount = homeList['posts']
          .firstWhere((post) => post['_id'] == postId)['likeCount'];
      homeList['posts']
              .firstWhere((post) => post['_id'] == postId)['likeCount'] =
          isLiked ? likeCount + 1 : likeCount - 1;
    });
    _addLike(
        postId,
        homeList['posts']
            .firstWhere((post) => post['_id'] == postId)['isLiked']);
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  Future<void> _refresh() async {
    setState(() {
      _pageNumber = 1;
      homeList = null; // Clear existing data
    });
    await _homeFeed(page: 1);
    await _suggestFollowList();
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => searchpage()),
                          );
                        },
                        child: Icon(
                          CupertinoIcons.search,
                          color: buttoncolor,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => TrendingPage()),
                        // );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/massage.svg",
                      ),
                    ),
                    SizedBox(width: 20),
                    // SvgPicture.asset(
                    //   "assets/svg/notification.svg",
                    // ),

                    IconButton(
                        onPressed: () {},
                        icon: Badge(
                            textColor: Colors.white,
                            label: Text("5"),
                            child: Icon(
                              Icons.notifications,
                              color: buttoncolor,
                            ))),
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
              SizedBox(height: 15),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (homeList != null &&
                    homeList['posts'] != null &&
                    homeList['posts'].isNotEmpty)
                    ? homeList['posts'].length
                    : 1, // Ensure there's at least one item if posts are empty or homeList is null
                itemBuilder: (BuildContext context, int index) {
                  if ((homeList == null ||
                      homeList['posts'] == null ||
                      homeList['posts'].isEmpty) &&
                      index == 0) {
                    // Show suggestFollow list if there are no posts
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "New People",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: buttoncolor, // Assuming buttoncolor is defined
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: suggestFollow.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MembersListing(
                                  name: suggestFollow[index]['firstName'],
                                  id: suggestFollow[index]['_id'],
                                  status: suggestFollow[index]['isFollowing'],
                                  img: suggestFollow[index]['profilePic'] != null
                                      ? suggestFollow[index]['profilePic']['filePath']
                                      : '',
                                  onFollowToggled: () => toggleFollow(index),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  } else {
                    // Show posts
                    if (homeList != null &&
                        homeList['posts'] != null &&
                        index < homeList['posts'].length) {
                      return Column(
                        children: [
                          ProductCard(
                            createdTime: _calculateTimeDifference(
                                homeList['posts'][index]['createdAt']),
                            name: homeList['posts'][index]['username'] ?? '',
                            description: homeList['posts'][index]['description'] ?? '',
                            likes: homeList['posts'][index]['likeCount']?.toString() ?? '',
                            img: homeList['posts'][index]['filePath'] ?? '',
                            profilepic: homeList['posts'][index]['profilePic'] ?? '',
                            likedby: homeList['posts'][index]['lastLikedUserName'] ?? '',
                            commentby: homeList['posts'][index]['lastCommentedUser'] ?? '',
                            commentcount: homeList['posts'][index]['commentCount'].toString() ?? '',
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
                    }
                    return SizedBox.shrink(); // Return an empty widget for out of bounds indices
                  }
                },
              )

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
    required this.commentcount,
    required this.commentby,
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
  final String commentby;
  final String likes;
  final String commentcount;
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

  late String currentImg;

  @override
  void initState() {
    super.initState();
    currentImg = widget.img;
  }

  void reloadImage() {
    setState(() {
      currentImg = ''; // Clear the image URL to force reload
      Future.delayed(Duration.zero, () {
        setState(() {
          currentImg = widget.img;
        });
      });
    });
  }

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.createdTime,
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
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
                          color: Colors
                              .transparent, // Set background color to transparent
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: widget.profilepic != null &&
                                  widget.profilepic.isNotEmpty
                              ? Image.network(
                                  widget.profilepic,
                                  height: 51,
                                  width: 51,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Failed to load image');
                                  },
                                )
                              : Image.network(
                                  'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8'),
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
          GestureDetector(
            onTap: reloadImage,
            child: Container(
              key: ValueKey(currentImg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Image.network(
                currentImg,
                fit: BoxFit.fill,
                headers: {'Cache-Control': 'no-cache'},
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ),

          // SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // IconButton(
                    //   onPressed: widget.onLikePressed,
                    //   icon: Icon(
                    //     widget.likeCount ? Icons.favorite : Icons.favorite_border,
                    //     color: widget.likeCount ? Colors.red : Colors.black26,
                    //     size: 30.0,
                    //   ),
                    // ),

                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: widget.onLikePressed,
                        icon: ImageIcon(
                          AssetImage(
                            widget.likeCount
                                ?  'assets/image/rubred.png'
                                : 'assets/image/rubblack.png'
                          ),
                          size: 30.0,
                          color: widget.likeCount ? Colors.red : Colors.black26,
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: white,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            late Map<String, dynamic>? homeList;
                            return Padding(
                              padding: const EdgeInsets.all(20.0).copyWith(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: CommentBottomSheet(id: widget.id),
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/comment.svg",
                        height: 20,
                      ),
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
                SizedBox(
                  height: 10,
                ),
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
                            style: TextStyle(),
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
                    Text("${widget.likes} Others ",
                        style: TextStyle(
                            color: bluetext,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 2),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      backgroundColor: white,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        late Map<String, dynamic>? homeList;
                        return Padding(
                          padding: const EdgeInsets.all(20.0).copyWith(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: CommentBottomSheet(id: widget.id),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: bluetext,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: "View All",
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2),
                      Text("${widget.commentcount} Comments ",
                          style: TextStyle(
                            color: bluetext,
                            fontSize: 13,
                          )),
                    ],
                  ),
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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

          // SizedBox(
          //   height: 15,
          // )
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => profileinnerpage(
                    id: id,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          height: 300,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.1,
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: img.isNotEmpty
                    ? Image.network(
                        img,
                        height: 65,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                        ),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
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
            ],
          ),
        ),
      ),
    );
  }
}
