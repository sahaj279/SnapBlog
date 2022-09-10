import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  //model
  final String comment;
  final String username;
  final String postId;
  final String profileImage;
  final likes;
  final dateOfComment;

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'username': username,
        'postId': postId,
        'profileImage': profileImage,
        'likes': likes,
        'dateOfComment': dateOfComment,
      };

  static CommentModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return CommentModel(
      snap['comment'],
      snap['username'],
      snap['postId'],
      snap['profileImage'],
      snap['likes'],
      snap['dateOfComment'],
    );
  }

  CommentModel(this.comment, this.username, this.postId, this.profileImage,
      this.likes, this.dateOfComment);
}
