import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ListCard extends StatelessWidget {
  final snap;
  const ListCard({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2,color: borderColor), 

          ),
          margin:const EdgeInsets.only(bottom: 5), 
      padding:const  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: borderColor,
            radius:32,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(snap['photourl']),
              // NetworkImage(snap['photourl']),
              radius: 30,
            ),
          ),
          Padding(
            padding:const  EdgeInsets.only(left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snap['username'],
                  style:const  TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   'following',
                //   // style: TextStyle(fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
