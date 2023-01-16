import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';

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
      padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
                  CachedNetworkImageProvider(widget.snap['profileImage']),
              // NetworkImage(widget.snap['profileImage']),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.75,
                child: RichText(
                  text: TextSpan(
                      style:const  TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                            style:const  TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            text: widget.snap['username']),
                        TextSpan(
                          text: ' ${widget.snap['comment']}',
                        ),
                      ]),
                ),
              ),
              Padding(
                padding:const  EdgeInsets.only(top: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['dateOfComment'].toDate()),
                  style:const  TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
          // Expanded(
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: IconButton(
          //       onPressed: () {},
          //       icon: Icon(Icons.favorite),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
