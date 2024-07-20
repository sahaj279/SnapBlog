import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/models/user_model.dart';
import 'package:snapblog/providers/user_provider.dart';
import 'package:snapblog/resources/firestore_methods.dart';
import 'package:snapblog/screens/comments_screen.dart';
import 'package:snapblog/screens/profileScreen.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:snapblog/utils/utils.dart';
import 'package:snapblog/widgets/like_animations.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 17),
      decoration: BoxDecoration(
        // border: Border.all(color: borderColor, width: 3),
        borderRadius: BorderRadius.circular(36),
        color:
            widget.snap['postUrl'] == "1" ? blogBgColor : postBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4).copyWith(left: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 16,
                    foregroundImage:
                        CachedNetworkImageProvider(widget.snap['profileImage']),
                    // NetworkImage(widget.snap['profileImage']),
                  ),
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
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfileScreen(
                                      uid: widget.snap['uid'],
                                    ),
                                  ));
                            });
                          },
                          child: Text(
                            widget.snap['username'],
                            style: const TextStyle(
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: ['Delete']
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )),
                        icon: const Icon(
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
              widget.snap['postUrl'] != "1"
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xffE9E9EB),
                          // border: Border.all(width: 3, color: borderColor),
                          borderRadius: BorderRadius.circular(36)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      // height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      child: Image(
                        image:
                            CachedNetworkImageProvider(widget.snap['postUrl']),
                        fit: BoxFit.contain,
                      ))
                  //for blog posts
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: double.infinity,
                      // width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(width: 3, color: borderColor),
                          borderRadius: BorderRadius.circular(36)),
                      child: Text(
                        widget.snap['description'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  smallLike: false,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    size: 120,
                    color: themeWhiteColor,
                    Icons.local_fire_department,
                  ),
                ),
              ),
            ]),
          ),
          //like comment section
          Row(
            children: [
              LikeAnimation(
                duration: const Duration(milliseconds: 400),
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(
                          Icons.local_fire_department_sharp,
                          color: bottomNavButtonBackgroundColor,
                          size: 28,
                        )
                      : const Icon(
                          Icons.local_fire_department_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                  padding: const EdgeInsets.all(0),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            postId: widget.snap['postId'],
                          )),
                ),
                icon: const Icon(
                  Icons.mode_comment_outlined,
                  color: Colors.white,

                  // size: 24,
                ),
                padding: const EdgeInsets.all(0),
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
          //x likes, name and description
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} Like${widget.snap['likes'].length == 1 ? "" : "s"}',
                  // style: Theme.of(context).textTheme.bodyMedium,
                ),
                widget.snap['postUrl'] == "1"
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(top: 8),
                        width: double.infinity,
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          //like a row widget for text
                          text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.snap['username'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${widget.snap['description']}',
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ]),
                        ),
                      ),

                //now a view more comments option
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => CommentsScreen(
                                postId: widget.snap['postId'],
                              ))), //to show the all comments screen
                  child: Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      comLen == 0
                          ? 'No Comments'
                          : (comLen == 1)
                              ? 'View comments'
                              : 'View all $comLen comments',
                      style: const TextStyle(fontSize: 16, color: greyColor),
                    ),
                  ),
                ),
                //date
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 16, color: greyColor),
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
