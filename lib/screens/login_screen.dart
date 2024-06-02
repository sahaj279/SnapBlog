import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snapblog/resources/auth_methods.dart';
import 'package:snapblog/responsive/mobView.dart';
import 'package:snapblog/responsive/responsive_layout.dart';
import 'package:snapblog/responsive/webView.dart';
import 'package:snapblog/screens/sign_up_screen.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/utils/utils.dart';
import 'package:snapblog/widgets/text_field_input.dart';

import '../utils/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webdim
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4)
              : const EdgeInsets.symmetric(
                  horizontal: 27), //to have sone space on sides
          width: double.infinity, //as we want it to stretch

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child:
                    Container(), //to have a flexible space on top which will reduce if content below it increases
              ),
              (kIsWeb)
                  ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('SnapBlog',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 80,
                              fontStyle: FontStyle.italic)),
                    )
                  : SvgPicture.asset(
                      "assets/mas.svg",
                      color: borderColor,
                      height: 200,
                    ),
              TextFieldInpuut(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInpuut(
                textEditingController: _passController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  //login user
                  String res = await Authentication().loginUser(
                      email: _emailController.text, pass: _passController.text);
                  // print(res);
                  if (res != "Success!") {
                    Util.showSnackBar(res, context);
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ResponsiveLayoutBuilder(
                          mobLayout: MobView(),
                          webLayout: WebView(),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: postBackgroundColor),
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 16),
                  ),
                  // color: blueColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Flexible(
                flex: 2,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Don't have an account?",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )), //to have a flexible space on top which will reduce if content below it increases
              ),
            ],
          ),
        ),
      ),
    );
  }
}
