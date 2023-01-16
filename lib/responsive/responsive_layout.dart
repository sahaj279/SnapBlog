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
  bool load = true;
  @override
  void initState() {
    super.initState();
    addData(); //to user
    
    
  }

  addData() async {
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    load = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return load
        ?const Center(child:  CircularProgressIndicator())
        : LayoutBuilder(builder: (context, constraint) {
            if (constraint.maxWidth > webdim) {
              return widget.weblayout;
            } else {
              return widget.moblayout;
            }
          });
  }
}
