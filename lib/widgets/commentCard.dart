import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.snap['profileImage']),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text:
                    TextSpan(style: TextStyle(color: primaryColor), children: [
                  TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      text: widget.snap['username']),
                  TextSpan(text: ' ${widget.snap['comment']}'),
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['dateOfComment'].toDate()),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite),
              ),
            ),
          )
        ],
      ),
    );
  }
}
