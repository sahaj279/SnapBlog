import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutBuilder extends StatefulWidget {
  final Widget weblayout, moblayout;
  const ResponsiveLayoutBuilder(
      {Key? key, required this.weblayout, required this.moblayout})
      : super(key: key);

  @override
  State<ResponsiveLayoutBuilder> createState() =>
      _ResponsiveLayoutBuilderState();
}

class _ResponsiveLayoutBuilderState extends State<ResponsiveLayoutBuilder> {
  @override
  void initState() {
    super.initState();
    addData(); //to user
  }

  addData() async {
    // UserProvider _up = Provider.of(context, listen: true);
    // await _up.refreshUser();
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    // print(Provider.of<UserProvider>(context).getUser);/
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > webdim) {
        return widget.weblayout;
      } else {
        return widget.moblayout;
      }
    });
  }
}
