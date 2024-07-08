import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ProfileScreenButton extends StatelessWidget {
  final Color? backgroundColor;
  final void Function()? onTap;
  final String text;

  const ProfileScreenButton({
    this.backgroundColor,
    this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            // border: Border.all(width: 2, color: greyColor),
            color: backgroundColor,
            borderRadius: BorderRadius.circular(36)),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
