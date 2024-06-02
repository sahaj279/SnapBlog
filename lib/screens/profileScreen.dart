import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/resources/auth_methods.dart';
import 'package:snapblog/resources/firestore_methods.dart';
import 'package:snapblog/screens/login_screen.dart';
import 'package:snapblog/screens/single_post_screen.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/utils.dart';
import 'package:snapblog/widgets/explorePostCard.dart';

import '../utils/dimensions.dart';
import '../widgets/profileValuesWidget.dart';
import '../widgets/profile_screen_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool showPosts = true;
  int postLen = 0;
  bool isOriginalUser = false;
  bool isFollowing = false;
  int followers = 0;
  int following = 0;
  bool isLoading = true;
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser!.uid == widget.uid) {
      setState(() {
        isOriginalUser = true;
      });
    }
    getData();
    super.initState();
  }

  getData() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      if (snapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid)) {
        isFollowing = true;
      }
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = snapshot.data()!;
      following = userData['following'].length;
      followers = userData['followers'].length;
      isLoading = false;
      setState(() {});
    } catch (e) {
      Util.showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              // backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: ['Logout']
                                  .map((e) => InkWell(
                                        onTap: () async {
                                          await Authentication().signOutUser();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )),
                  icon:const Icon(
                    Icons.more_vert,
                    color: borderColor,
                  ),
                )
              ],
            ),
            body: Padding(
              padding:MediaQuery.of(context).size.width>webdim?
           EdgeInsets.symmetric(
            vertical: 5,
            horizontal: MediaQuery.of(context).size.width/3,
          ): const EdgeInsets.all(0.0),
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //photo post followers followeing
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Row(
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, left: 6),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 50,
                                child: CircleAvatar(
                                  radius: 47,
                                  backgroundImage: CachedNetworkImageProvider(
                                      userData['photourl']),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ProfileValuesWidget(
                                        val: postLen,
                                        title: 'Posts',
                                      ),
                                      ProfileValuesWidget(
                                        val: followers,
                                        title: 'Followers',
                                      ),
                                      ProfileValuesWidget(
                                        val: following,
                                        title: 'Following',
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: isOriginalUser
                                        ? ProfileScreenButton(
                                            // backgroundColor: mobileSearchColor,
                                            text: 'Edit Profile',
                                            onTap: () {})
                                        : isFollowing
                                            ? ProfileScreenButton(
                                                // backgroundColor:
                                                //     mobileSearchColor,
                                                text: 'Unfollow',
                                                onTap: //unFollow user
                                                    () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid); // ,
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                })
                                            : ProfileScreenButton(
                                                backgroundColor: postBackgroundColor,
                                                text: 'Follow',
                                                onTap: () async {
                                                  await FirestoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid); // ,
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                }),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ).copyWith(top: 8),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  // const Divider(color:Colors.black),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: borderColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  showPosts = true;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: showPosts ? postBackgroundColor : null,
                                    borderRadius:const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    // border: Border(
                                    //   right: BorderSide(color: borderColor, width: 2),
                                    // ),
                                  ),
                                  padding:const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child:const Text('Posts',
                                      style: TextStyle(
                                          color: textColor, fontSize: 20)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showPosts = false;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: showPosts ? null : blogBgColor,
                                    borderRadius:const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                  ),
                                  padding:const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child:const Text('Blogs',
                                      style: TextStyle(
                                          color: textColor, fontSize: 20)),
                                ),
                              ),
                            ])),
                  ),
                  Container(
                      padding: const EdgeInsets.all(10).copyWith(top: 0),
                      child: showPosts
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .where('postUrl', isNotEqualTo: "1")
                                  .where('uid', isEqualTo: widget.uid).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    (snapshot.data! as dynamic).docs.length ==
                                        0) {
                                  return const Center(
                                    child:
                                        Text('You haven\'t posted anything yet.'),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return SinglePostCard(
                                                snap: (snapshot.data! as dynamic)
                                                    .docs[index]
                                                    .data());
                                          }));
                                        },
                                        child: ExplorePostCard(
                                            snap: (snapshot.data! as dynamic)
                                                .docs[index]));
                                  },
                                );
                              },
                            )
                          : FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('posts')
                                  .where('uid', isEqualTo: widget.uid)
                                  .where('postUrl', isEqualTo: "1")
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    (snapshot.data! as dynamic).docs.length ==
                                        0) {
                                  return const Center(
                                    child:
                                        Text('You haven\'t posted anything yet.'),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                   
                                    return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return SinglePostCard(
                                                snap: (snapshot.data! as dynamic)
                                                    .docs[index]
                                                    .data());
                                          }));
                                        },
                                        child: ExplorePostCard(
                                            snap: (snapshot.data! as dynamic)
                                                .docs[index]));
                                  },
                                );
                              },
                            )),
                ],
              ),
            ),
          );
  }
}
