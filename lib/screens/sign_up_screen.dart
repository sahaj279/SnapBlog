import 'dart:typed_data';
import 'package:instagram_clone/responsive/mobView.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/responsive/webView.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? profileImage;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List _im = await Util.pickImage(ImageSource.gallery);
    setState(() {
      profileImage = _im;
    });
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
                padding: EdgeInsets.only(bottom: 44),
                child: SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: Colors.white,
                  height: 64,
                ),
              ),
              //circular widget to take a photo from device and stare as dp
              //for that we'll use a stack
              Stack(
                children: [
                  profileImage != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(profileImage!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldInpuut(
                textEditingController: _usernameController,
                hintText: 'Create a username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ), //username
              TextFieldInpuut(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ), //email
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
              TextFieldInpuut(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ), //bio
              InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String res = await Authentication().signUpUser(
                      username: _usernameController.text,
                      bio: _bioController.text,
                      email: _emailController.text,
                      pass: _passController.text,
                      file: profileImage!);
                  print(res);
                  setState(() {
                    isLoading = false;
                  });
                  if (res != 'Success!') {
                    //show the error in snackbar
                    //snackbar code in util
                    Util.showSnackBar(res, context);
                  } else {
                    //
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ResponsiveLayoutBuilder(
                            moblayout: MobView(), weblayout: WebView())));
                  }
                },
                child: Container(
                  child: (isLoading == true)
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : const Text(
                          'Sign Up',
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
                      "Already have an account?",
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    child: Container(
                      child: Text(
                        "Log In",
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
