import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:snapblog/utils/colors.dart";

class ExplorePostCard extends StatelessWidget {
  final snap;
  const ExplorePostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return snap['postUrl'] != "1"
        ? Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2,color: borderColor), 

          ), 
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CachedNetworkImage(
              imageUrl: snap['postUrl'],
              fit: BoxFit.cover,
            ),
        )
        : Container(
          padding: const EdgeInsets.only(left:5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2,color: borderColor), 
            color: Colors.white,
          ), 
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Text(snap['description']));
  }
}
