import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:favorite_button/favorite_button.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import '../../profile_screen/inner_page/profile_inner_page.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  var userId;
  var profileDetails;
  var homeList;
  bool isLoading = false;
  bool _isLoading = true;

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  Future<void> _homeFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response = await HomeService.getFeed();
    log.i('Home feed data: $response');
    setState(() {
      homeList = response;
    });
  }

  Future<void> _initLoad() async {
    await Future.wait([_homeFeed()]);
    setState(() {
      _isLoading = false;
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
    return  ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: homeList != null && homeList['posts'] != null ? homeList['posts'].length : 0,
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(
          createdTime: homeList['posts'][index]['createdAt'] != null
              ? _calculateTimeDifference(homeList['posts'][index]['createdAt'])
              : '',
          name: homeList['posts'][index]['username'] != null ? homeList['posts'][index]['username'] : '',
          description: homeList['posts'][index]['description'] != null ? homeList['posts'][index]['description'] : '',
          likes: homeList['posts'][index]['likeCount'] != null ? homeList['posts'][index]['likeCount'].toString() : '',
          img: homeList['posts'][index]['filePath'] != null ? homeList['posts'][index]['filePath'] : '',
          id: homeList['posts'][index]['_id'] != null ? homeList['posts'][index]['_id'] : '',
          userId: homeList['posts'][index]['userId'] != null ? homeList['posts'][index]['userId'] : '',
          likeCount: homeList['posts'][index]['isLiked'] != null ? homeList['posts'][index]['isLiked'] : false,
          onLikePressed: () {
            _toggleLikePost(homeList['posts'][index]['_id']);
          },
          onDoubleTapLike: () {
            _toggleLikePost(homeList['posts'][index]['_id']);
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.img,
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
  final String description;
  final bool likeCount;

  final VoidCallback onLikePressed;
  final VoidCallback onDoubleTapLike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onDoubleTap: onDoubleTapLike, // Handle double tap here
        child: Container(
          width: 345,
          // height: 550,
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
                  InkWell(
                    onDoubleTap: (){


                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                createdTime,
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Icon(Icons.more_vert, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  profileinnerpage(
                          id: userId,
                        )),
                      );
                    },
                    child: Positioned(
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
                                'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png',
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                      height: 400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
                child: Row(
                  children: [
                    FavoriteButton(
                      iconSize: 32,
                      isFavorite: likeCount,
                      iconDisabledColor: Colors.black26,
                      valueChanged: (_) {
                        onLikePressed(); // Call the callback function when like button is pressed
                      },
                    ),
                    SizedBox(width: 10),
                    Text("Likes", style: TextStyle(color: Colors.blue, fontSize: 10)),
                    SizedBox(width: 2),
                    Text(likes, style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  child: Text(description,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
