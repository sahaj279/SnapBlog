import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/screens/profileScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int comLen = 0;

  @override
  void initState() {
    getComLen();
    super.initState();
  }

  getComLen() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    setState(() {
      comLen = snap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Container(
      decoration: MediaQuery.of(context).size.width > webdim
          ? BoxDecoration(
              border: Border.all(color: secondaryColor),
              color: webBackgroundColor,
            )
          : BoxDecoration(
              color: mobileBackgroundColor,
            ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: widget.snap['uid'])));
                          },
                          child: Text(
                            widget.snap['username'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                user.username == widget.snap['username']
                    ? IconButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map((e) => InkWell(
                                              onTap: () async {
                                                await FirestoreMethods()
                                                    .deletePost(
                                                        widget.snap['postId']);
                                                Navigator.of(context).pop();
                                                Util.showSnackBar(
                                                    'Deleted post successfully!',
                                                    context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      )
                    : Container()
              ],
            ),

            //post
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.fitHeight,
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                  isAnimating: isLikeAnimating,
                  smallLike: false,
                  duration: Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              ),
            ]),
          ),

          //like comment section

          Row(
            children: [
              LikeAnimation(
                duration: Duration(milliseconds: 400),
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                          // size: 24,
                        )
                      : Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.grey,
                        ),
                  padding: EdgeInsets.all(0),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              postId: widget.snap['postId'],
                            ))),
                icon: Icon(
                  Icons.mode_comment,
                  color: Colors.grey,

                  // size: 24,
                ),
                padding: EdgeInsets.all(0),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     color: Colors.grey,
              //     // size: 24,
              //   ),
              //   padding: EdgeInsets.all(0),
              // ),
              // Expanded(
              //     child: Align(
              //   alignment: Alignment.centerRight,
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: Icon(
              //       Icons.bookmark_border_outlined,
              //       color: primaryColor,
              //     ),
              //   ),
              // ))
            ],
          ),

          //description and comment box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    '${widget.snap['likes'].length} Likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: RichText(
                    //like a row widget for text
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(text: ' ${widget.snap['description']}')
                        ]),
                  ),
                ),

                //now a view more comments option
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                                postId: widget.snap['postId'],
                              ))), //to show the all comments screen
                  child: Container(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'View all ${comLen} comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
