import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //model
  final String username;
  final String email;
  final String uid;
  final String bio;
  final String photourl;
  final List followers;
  final List following;

  User.name(this.username, this.email, this.uid, this.bio, this.photourl,
      this.followers, this.following);

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'photourl': photourl,
        'followers': followers,
        'following': following
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User.name(snap['username'], snap['email'], snap['uid'], snap['bio'],
        snap['photourl'], snap['followers'], snap['following']);
  }
}
