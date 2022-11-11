import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/single_post_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
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
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      if (snapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid)) {
        isFollowing = true;
      }
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
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, left: 8),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundImage: CachedNetworkImageProvider(
                                  userData['photourl']),
                              // NetworkImage(userData['photourl']),
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Text(
                        userData['bio'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: isOriginalUser
                          ? ProfileScreenButton(
                              backgroundColor: mobileSearchColor,
                              text: 'SignOut',
                              onTap: () async {
                                await Authentication().signOutUser();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                            )
                          : isFollowing
                              ? ProfileScreenButton(
                                  backgroundColor: mobileSearchColor,
                                  text: 'Unfollow',
                                  onTap: //unFollow user
                                      () async {
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.uid); // ,
                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  })
                              : ProfileScreenButton(
                                  backgroundColor: blueColor,
                                  text: 'Follow',
                                  onTap: () async {
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.uid); // ,
                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  }),
                    ),
                  ],
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: postLen,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SinglePostCard(
                                  snap: (snapshot.data! as dynamic)
                                      .docs[index]
                                      .data());
                            }));
                          },
                          child: Image(
                            image: CachedNetworkImageProvider(snap['postUrl']),
                            // NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}

class ProfileScreenButton extends StatelessWidget {
  final Color backgroundColor;
  final void Function()? onTap;
  final String text;

  const ProfileScreenButton({
    required this.backgroundColor,
    this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(5)),
        child: Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class ProfileValuesWidget extends StatelessWidget {
  final int val;
  final String title;
  const ProfileValuesWidget({Key? key, required this.val, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          val.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
