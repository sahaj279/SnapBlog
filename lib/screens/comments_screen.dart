import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapblog/models/user_model.dart';
import 'package:snapblog/providers/user_provider.dart';
import 'package:snapblog/resources/firestore_methods.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:snapblog/widgets/commentCard.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Padding(
       padding: MediaQuery.of(context).size.width > webdim
                  ? EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: MediaQuery.of(context).size.width / 3,
                    )
                  : const EdgeInsets.all(0.0),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text('Comments'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('dateOfComment', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.white,
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: CachedNetworkImageProvider(user.photourl),
                  // NetworkImage(user.photourl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintStyle:
                            const TextStyle(overflow: TextOverflow.ellipsis),
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String res = await FirestoreMethods().addComment(
                        _commentController.text,
                        widget.postId,
                        user.username,
                        user.photourl);
                    debugPrint(res);
                    _commentController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: blueAccentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
