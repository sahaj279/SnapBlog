import 'package:flutter/material.dart';
import 'package:snapblog/providers/user_provider.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutBuilder extends StatefulWidget {
  final Widget webLayout, mobLayout;
  const ResponsiveLayoutBuilder(
      {super.key, required this.webLayout, required this.mobLayout});

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
        ?const Scaffold(body: Center(child:  CircularProgressIndicator()))
        : LayoutBuilder(builder: (context, constraint) {
            if (constraint.maxWidth > webdim) {
              return widget.webLayout;
            } else {
              return widget.mobLayout;
            }
          });
  }
}
