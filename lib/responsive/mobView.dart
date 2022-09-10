import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/Activity-screen.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:provider/provider.dart';

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
    // model.User user = Provider.of<UserProvider>(context).getUser;
    // print(user
    //     .username); //when refresh user is called in responsive layout,it takes time ,till then we get error and after that we get the name
    // var s = user.username;

    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: PageView(
          children: [
            FeedScreen(),
            SearchScreen(),
            AddPostScreen(),
            ActivityScreen(),
            ProfileScreen(
              uid: FirebaseAuth.instance.currentUser!.uid,
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor,
                ),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: _page == 1 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: _page == 2 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,
                    color: _page == 3 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _page == 4 ? primaryColor : secondaryColor),
                label: '',
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ),
      ),
    );
  }
}
