import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/postCard.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: width > webdim
            ? null
            : AppBar(
                backgroundColor:
                    width > webdim ? webBackgroundColor : mobileBackgroundColor,
                title: SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: Colors.white,
                  height: 32,
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.messenger_outline,
                        color: Colors.white,
                      ))
                ],
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(
                    horizontal: width > webdim ? width * 0.3 : 0,
                    vertical: width > webdim ? 15 : 0),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
