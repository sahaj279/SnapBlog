import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/screens/add_post_screen.dart';
import 'package:snapblog/screens/feed_screen.dart';
import 'package:snapblog/screens/profileScreen.dart';
import 'package:snapblog/screens/search_screen.dart';
import 'package:snapblog/utils/colors.dart';

import '../screens/blog_screen.dart';

class MobView extends StatefulWidget {
  const MobView({Key? key}) : super(key: key);

  @override
  State<MobView> createState() => _MobViewState();
}

class _MobViewState extends State<MobView> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(user
    //     .username); //when refresh user is called in responsive layout,it takes time ,till then we get error and after that we get the name
    // var s = user.username;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const FeedScreen(),
          const BlogScreen(),
          const AddPostScreen(),
          const SearchScreen(),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(
            _page == 0 ? Icons.home: Icons.home_outlined ,
            color: _page == 0 ? selectedNavBarButtonColor : textColor,
          ),
          Icon(_page == 1 ? Icons.local_cafe : Icons.local_cafe_outlined,
              color: _page == 1 ? selectedNavBarButtonColor : textColor),
          Icon(_page == 2 ? Icons.add_circle : Icons.add_circle_outline,
              color: _page == 2 ? selectedNavBarButtonColor : textColor),
          Icon(_page == 3 ? Icons.search : Icons.search_outlined,
              color: _page == 3 ? selectedNavBarButtonColor : textColor),
          Icon(_page == 4 ? Icons.person : Icons.person_outline,
              color: _page == 4 ? selectedNavBarButtonColor : textColor),
        ],
        onTap: navigationTapped,
        backgroundColor: Colors.transparent,
        height: 75,
        color: bottomNavBarColor,
        buttonBackgroundColor: bottomNavButtonBackgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
      ),
      // bottomNavigationBar: BottomNavigationBar(

      //   backgroundColor: mobileBackgroundColor,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //           color: _page == 0 ? primaryColor : secondaryColor,
      //         ),
      //         label: '',
      //         backgroundColor: primaryColor),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.search,
      //             color: _page == 1 ? primaryColor : secondaryColor),
      //         label: '',
      //         backgroundColor: primaryColor),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.add_circle,
      //             color: _page == 2 ? primaryColor : secondaryColor),
      //         label: '',
      //         backgroundColor: primaryColor),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.favorite,
      //             color: _page == 3 ? primaryColor : secondaryColor),
      //         label: '',
      //         backgroundColor: primaryColor),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.person,
      //             color: _page == 4 ? primaryColor : secondaryColor),
      //         label: '',
      //         backgroundColor: primaryColor),
      //   ],
      //   onTap: navigationTapped,
      // ),
    );
  }
}
