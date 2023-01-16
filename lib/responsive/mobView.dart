import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

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

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: mobileBackgroundColor,
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics:const  NeverScrollableScrollPhysics(),
          children: [
            const FeedScreen(),
            const SearchScreen(),
            const AddPostScreen(),
            // ActivityScreen(),
            ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          ],
        ),

        bottomNavigationBar: CurvedNavigationBar(
          items: [
            Icon(
              Icons.home,
              color: _page == 0 ? Colors.black : primaryColor,
            ),
            Icon(Icons.search,
                color: _page == 1 ? Color(0xff3406b3) : primaryColor),
            Icon(Icons.add_circle,
                color: _page == 2 ? Color(0xffB20600) : primaryColor),
            // Icon(Icons.favorite,
            //     color: _page == 3 ? Colors.black : primaryColor),
            Icon(Icons.person,
                color: _page == 3 ? mobileSearchColor : primaryColor),
          ],
          onTap: navigationTapped,
          backgroundColor: Colors.transparent,
          height: 60,
          color: mobileBackgroundColor,
          buttonBackgroundColor:const Color(0xffF1F1E6),
          animationCurve: Curves.easeInOut,
          animationDuration:const Duration(milliseconds: 300),
        ),
        // bottomNavigationBar: CupertinoTabBar(
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
      ),
    );
  }
}
