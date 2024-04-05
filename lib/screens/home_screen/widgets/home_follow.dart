import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:favorite_button/favorite_button.dart';

class homefollow extends StatefulWidget {
  const homefollow({super.key});

  @override
  State<homefollow> createState() => _homefollowState();
}

class _homefollowState extends State<homefollow> {
  bool isFollowing = false;
  var suggestfollow;
  bool isLoading = false;
  var userid;
  bool _isLoading = true;
  late final String id;

  bool wishListCount = false;

  void toggleFollow() {
    setState(() {
      if (isFollowing) {
        isFollowing = false;
        follow();
        print("follow");
      } else {
        isFollowing = true;
        print("unfollow");
      }
    });
  }

  Future follow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var reqData = {
      'followerId': id,
    };
    var response = await HomeService.follow(reqData);
    log.i('add to follow. $response');
  }

  Future unfollowfollow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var reqData = {
      'followerId': id,
    };
    var response = await HomeService.unfollow(reqData);
    log.i('add to follow. $response');
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

  Future _initLoad() async {
    await Future.wait([
      _suggestfollowlist(),
    ]);
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: suggestfollow != null ? suggestfollow['result'].length : 0,
      itemBuilder: (BuildContext context, int index) {
        return membersLiting(
          id: suggestfollow != null ? suggestfollow['result'][index]['_id'] : '',
          name: suggestfollow != null ? suggestfollow['result'][index]['firstName'] : '',
          status: suggestfollow != null ? suggestfollow['result'][index]['isFollowing'] : false,
          img: suggestfollow != null && suggestfollow['result'][index]['profilePic'] != null
              ? '${baseURL}/${suggestfollow['result'][index]['profilePic']['filePath']}'
              : '',
        );
      },
    );

  }
}

class membersLiting extends StatelessWidget {
  const membersLiting({
    required this.name,
    required this.img,
    required this.status,
    required this.id,
    super.key,
  });

  final String name;
  final String img;
  final String id;
  final bool status;



  Future follow() async {
    var reqData = {
      'followerId': id,
    };
    var response = await HomeService.follow(reqData);
    log.i('add to follow. $response');
  }


  Future unfollowfollow() async {
    var reqData = {
      'followerId': id,
    };
    var response = await HomeService.unfollow(reqData);
    log.i('add to follow. $response');
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {


      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          height: 300,
          width: 100,
          decoration: BoxDecoration(
            color: white,
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
              SizedBox(height: 10,),
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
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11),
                ),
              ),
              SizedBox(height: 10,),

              FavoriteButton(
                iconSize: 32,
                isFavorite: status,
                iconDisabledColor: Colors.black26,
                valueChanged: (_isFavorite) {
                  print('Is Favorite : $_isFavorite');
                  if (_isFavorite == true) {
                    follow();
                  } else {
                    unfollowfollow();
                  }
                },
              ),



            ],
          ),
        ),
      ),
    );
  }
}



