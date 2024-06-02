import 'package:flutter/material.dart';

class ProfileValuesWidget extends StatelessWidget {
  final int val;
  final String title;
  const ProfileValuesWidget({Key? key, required this.val, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          val.toString(),
          style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Container(
          margin:const EdgeInsets.only(top: 2),
          child: Text(
            title,
            style:const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}