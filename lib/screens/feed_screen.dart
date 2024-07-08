import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/providers/user_provider.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:snapblog/widgets/postCard.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  // Future<void> getFollow(String uid) async {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).getUser;
    // List? userlist = getFollow(user.uid);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: width > webdim
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              // backgroundColor:Colors.orange[100]!,
              title: const Text(
                'SnapBlog',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                    ))
              ],
            ),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('no one has posted anything '));
          }
          List l = snapshot.data!['following'];
          // print(l.length);
          // print(l);
          if (l.isNotEmpty) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', whereIn: l)
                  .where('postUrl', isNotEqualTo: "1")
                  // .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  //users you follow haven't posted anything
                  //again show al posts
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('postUrl', isNotEqualTo: "1")
                        // .orderBy('postUrl')
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

                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No one has posted anything yet!'),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
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
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
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
          }
          //you dont follow anyone
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('postUrl', isNotEqualTo: "1")
                // .orderBy('postUrl')
                // .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No one has posted anything yet!'),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
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
    );
  }
}
