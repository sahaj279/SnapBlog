import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final snap;
  const ListCard({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(snap['photourl']),
            radius: 32,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snap['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'following',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
