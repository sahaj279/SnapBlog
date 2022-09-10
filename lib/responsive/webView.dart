import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class WebView extends StatelessWidget {
  const WebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: webBackgroundColor,
      body: Center(
        child: Text('This is Web view'),
      ),
    );
  }
}
