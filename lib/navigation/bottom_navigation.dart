import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/color.dart';
import '../screens/chat_screen/chatpage.dart';
import '../screens/home_screen/homepage.dart';
import '../screens/profile_screen/profilepage.dart';
import '../screens/search_screen/searchpage.dart';
import '../screens/trending_screen/trendingpage.dart';
import '../screens/upload_screen/uploadscreen.dart';


class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {


  int _selectedPageIndex = 0;

  final LinearGradient gradient = LinearGradient(
    colors: [buttoncolor, bluetext], // Change these colors to your desired gradient
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  void callback() {
    print("callback");
  }

  final List<Map<String, Object>> _pages = [
    {'page': homepage(), 'title': 'Home'},
    {'page': TrendingPage(), 'title': 'Search'},
    {'page': UploadScreen(), 'title': 'Upload'},
    {'page': chatpage(), 'title': 'Chat pgae'},
    {'page': ProfileView(), 'title': 'Profile'},
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Map<String, Object> get currentPage {
    return _pages[_selectedPageIndex];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:white,
      body: currentPage['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: gradient1,
        selectedItemColor: white,
        unselectedItemColor: white,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 11 ),
              child: SvgPicture.asset(
                "assets/svg/home.svg",
                color: (_selectedPageIndex == 0) ? bordercolor : null,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 11 ),
              child: SvgPicture.asset(
                "assets/svg/trending.svg",
                color: (_selectedPageIndex == 1) ? bordercolor : null,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 11 ),
              child: SvgPicture.asset(
                "assets/svg/upload.svg",
                color: (_selectedPageIndex == 2) ? bordercolor : null,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 11  ),
              child: SvgPicture.asset(
                "assets/svg/reelicon.svg",
                color: (_selectedPageIndex == 3) ? bordercolor : null,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 9 ),
              child: SvgPicture.asset(
                "assets/svg/profile.svg",
                color: (_selectedPageIndex == 4) ? bordercolor : null,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}






