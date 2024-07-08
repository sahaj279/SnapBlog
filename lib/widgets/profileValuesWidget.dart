import 'package:flutter/material.dart';
import 'package:snapblog/utils/colors.dart';

class ProfileValuesWidget extends StatelessWidget {
  final int val;
  final String title;
  const ProfileValuesWidget(
      {super.key, required this.val, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          val.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black87),
        ),
      ],
    );
  }
}
