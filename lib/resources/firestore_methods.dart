import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/comment_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String desc, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = Uuid().v1();
      Post post = Post(desc, uid, username, postId, photoUrl, profileImage, [],
          DateTime.now());
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success!";
    } catch (e) {
      print(e);
      res = e.toString();
    }
    return res;
  }

  //updating likes
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> addComment(String comment, String postId, String username,
      String profileImage) async {
    var res = 'Some error occured';
    try {
      String cid = Uuid().v1();
      CommentModel commentModel = CommentModel(
          comment, username, postId, profileImage, [], DateTime.now());
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(cid)
          .set(commentModel.toJson());
      res = 'Success!';
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> followUser(String uid, String otherUid) async {
    try {
      var snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.data()!['following'].contains(otherUid)) {
        //remove the user from following
        //remove ourself from their's followers
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([otherUid])
        });
        await _firestore.collection('users').doc(otherUid).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([otherUid])
        });
        await _firestore.collection('users').doc(otherUid).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
