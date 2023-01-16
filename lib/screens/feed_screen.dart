import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/postCard.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  // Future<void> getFollow(String uid) async {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).getUser;
    // List? userlist = getFollow(user.uid);

    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: width > webdim
            ? null
            : AppBar(
                backgroundColor:
                    width > webdim ? webBackgroundColor : mobileBackgroundColor,
                title: Center(
                  child: kIsWeb?const Text('I-Masala',style:TextStyle(color: Colors.white,fontSize: 40,fontStyle: FontStyle.italic)) :
                  SvgPicture.asset(
                    'assets/mast.svg',
                    color: Colors.white,
                    height: 100,
                  ),
                ),
                // actions: [
                //   IconButton(
                //       onPressed: () {},
                //       icon: Icon(
                //         Icons.messenger_outline,
                //         color: Colors.white,
                //       ))
                // ],
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List l = snapshot.data!['following'];
            // print(l.length);
            // print(l);
            if (l.isNotEmpty) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', whereIn: l)
                    // .orderBy('datePublished', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width > webdim ? width * 0.4 : 0,
                          vertical: width > webdim ? 15 : 0),
                      child: PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    ),
                  );
                },
              );
            }
            return //all posts
                StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')

                  // .where('uid', whereIn: list!)
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
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
            );
          },
        ),
        // StreamBuilder(
        //   stream: FirebaseFirestore.instance
        //       .collection('posts')
        //       .where('uid', whereIn: list!)
        //       .orderBy('datePublished', descending: true)
        //       .snapshots(),
        //   builder: (context,
        //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     return ListView.builder(
        //       itemCount: snapshot.data!.docs.length,
        //       itemBuilder: (context, index) => Container(
        //         margin: EdgeInsets.symmetric(
        //             horizontal: width > webdim ? width * 0.3 : 0,
        //             vertical: width > webdim ? 15 : 0),
        //         child: PostCard(
        //           snap: snapshot.data!.docs[index].data(),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
