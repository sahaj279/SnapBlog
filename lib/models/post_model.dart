import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  //model
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String postUrl;
  final String profileImage;
  final likes;
  final datePublished;

  Post(this.description, this.uid, this.username, this.postId, this.postUrl,
      this.profileImage, this.likes, this.datePublished);

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'postUrl': postUrl,
        'profileImage': profileImage,
        'likes': likes,
        'datePublished': datePublished,
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
        snap['description'],
        snap['uid'],
        snap['username'],
        snap['postId'],
        snap['postUrl'],
        snap['profileImage'],
        snap['likes'],
        snap['datePublished']);
  }
}
