import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:snapblog/responsive/mobView.dart';
import 'package:snapblog/responsive/responsive_layout.dart';
import 'package:snapblog/responsive/webView.dart';
import 'package:snapblog/screens/login_screen.dart';
import 'package:snapblog/utils/dimensions.dart';
import 'package:snapblog/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapblog/resources/auth_methods.dart';
import 'package:snapblog/utils/colors.dart';
import 'package:snapblog/widgets/text_field_input.dart';

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
      backgroundColor: Colors.white,
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
                flex: 2,
                child: Container(
                  child: (kIsWeb)
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
                          color: textColor,
                          height: 200,
                        ),
                ), //to have a flexible space on top which will reduce if content below it increases
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
                      : const CircleAvatar(
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
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInpuut(
                textEditingController: _usernameController,
                hintText: 'Create a username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ), //username
              TextFieldInpuut(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ), //email
              const SizedBox(
                height: 16,
              ),
              TextFieldInpuut(
                textEditingController: _passController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFieldInpuut(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ), //bio
              InkWell(
                onTap: () async {
                  if (profileImage == null) {
                    Util.showSnackBar('Select an image first', context);
                    return;
                  }
                  if (_usernameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passController.text.isEmpty ||
                      _bioController.text.isEmpty) {
                    Util.showSnackBar('Fill all the details first', context);
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });

                  String res = await Authentication().signUpUser(
                      username: _usernameController.text,
                      bio: _bioController.text,
                      email: _emailController.text,
                      pass: _passController.text,
                      file: profileImage!);
                  // print(res);
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
                            mobLayout: MobView(), webLayout: WebView())));
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Color(0xff5790DF)),
                  // color: blueColor,
                  child: (isLoading == true)
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Sign Up',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xffE6EEFA)),
                        ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                flex: 1,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Already have an account?",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Log In",
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
