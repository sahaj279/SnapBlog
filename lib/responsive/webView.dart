import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/screens/blog_screen.dart';
import 'package:snapblog/screens/add_post_screen.dart';
import 'package:snapblog/screens/feed_screen.dart';
import 'package:snapblog/screens/profileScreen.dart';
import 'package:snapblog/screens/search_screen.dart';
import 'package:snapblog/utils/colors.dart';

class WebView extends StatefulWidget {
  const WebView({Key? key}) : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        titleSpacing: width / 6.5,
        backgroundColor: const Color(0xffA4A5D5),
        title: const Text(
          'SnapBlog',
          style: TextStyle(
              color: textColor, fontSize: 40, fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(
              _page == 0 ? Icons.home : Icons.home_outlined,
              color: _page == 0 ? selectedNavBarButtonColor : textColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(
                _page == 1 ? Icons.local_cafe : Icons.local_cafe_outlined,
                color: _page == 1 ? selectedNavBarButtonColor : textColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: Icon(_page == 2 ? Icons.add_circle : Icons.add_circle_outline,
                color: _page == 2 ? selectedNavBarButtonColor : textColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(3),
            icon: Icon(_page == 3 ? Icons.search : Icons.search_outlined,
                color: _page == 3 ? selectedNavBarButtonColor : textColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(4),
            icon: Icon(_page == 4 ? Icons.person : Icons.person_outline,
                color: _page == 4 ? selectedNavBarButtonColor : textColor),
          ),
          SizedBox(
            width: width / 6.5,
          )
        ],
      ),
      backgroundColor: Colors.white,
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
    );
  }
}
