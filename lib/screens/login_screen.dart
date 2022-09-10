import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobView.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/responsive/webView.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
          padding: EdgeInsets.symmetric(
              horizontal: 27), //to have sone space on sides
          width: double.infinity, //as we want it to stretch

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child:
                    Container(), //to have a flexible space on top which will reduce if content below it increases
                flex: 2,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 64),
                child: SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: Colors.white,
                  height: 64,
                ),
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
                  print(res);
                  if (res != "Success!") {
                    Util.showSnackBar(res, context);
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ResponsiveLayoutBuilder(
                            moblayout: MobView(), weblayout: WebView())));
                  }
                },
                child: Container(
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 16),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                  // color: blueColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Flexible(
                child:
                    Container(), //to have a flexible space on top which will reduce if content below it increases
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Don't have an account?",
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                    child: Container(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
