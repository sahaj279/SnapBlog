import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/providers/user_provider.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:snapblog/widgets/postCard.dart';
import 'package:provider/provider.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({Key? key}) : super(key: key);

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
              scrolledUnderElevation: 0,
              elevation: 0,
              backgroundColor:
                  width > webdim ? webBackgroundColor : Colors.white,
              title: const Text(
                'Blogs',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border_outlined,
                        color: Colors.black))
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
                  .where('postUrl', isEqualTo: "1")
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
                        .where('postUrl', isEqualTo: "1")
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
                          child: Text('No one has posted any blog yet!'),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: width > webdim ? width * 0.18 : 0,
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
                        horizontal: width > webdim ? width * 0.18 : 0,
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
                .where('postUrl', isEqualTo: "1")
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
                  child: Text('No one has posted any blog yet!'),
                );
              }
              // print(snapshot.data!.docs[0].data());
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width > webdim ? width * 0.18 : 0,
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
