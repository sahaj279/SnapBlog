import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapblog/models/comment_model.dart';
import 'package:snapblog/models/post_model.dart';
import 'package:snapblog/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String desc, Uint8List? file, String uid,
      String username, String profileImage) async {
    String res = "Some error occured";
    try {
      String photoUrl ="1";
      if(file!=null){
        photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      }
      String postId =const Uuid().v1();
      Post post = Post(desc, uid, username, postId, photoUrl, profileImage, [],
          DateTime.now());
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success!";
    } catch (e) {
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
      debugPrint(e.toString());
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
      debugPrint(e.toString());
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      debugPrint(e.toString());
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
      debugPrint(e.toString());
    }
  }

  //i want to get lisst of users which current user follows and then all the posts that these user have posted
//get list of followers
  Future<List?> getFollowings(String uid) async {
    try {
      var snapshot = await _firestore.collection('users').doc(uid).get();
      return snapshot.data()!['following'];
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
