import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descController = TextEditingController();
  bool _isLosding = false;

  _selectImage(BuildContext context) async {
    //to show the dialog box
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take from photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Util.pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Chose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await Util.pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void postImage(
      {required String uid,
      required String username,
      required String profileImage}) async {
    try {
      setState(() {
        _isLosding = true;
      });
      String res = await FirestoreMethods().uploadPost(
          _descController.text, _file!, uid, username, profileImage);
      setState(() {
        _isLosding = false;
      });
      if (res == 'Success!') {
        Util.showSnackBar(res, context);
        clearImage();
      } else {
        Util.showSnackBar(res, context);
      }
    } catch (e) {
      Util.showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return (_file == null)
        ? Center(
            child: IconButton(
              icon: Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text('Post to'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                      uid: user.uid,
                      username: user.username,
                      profileImage: user.photourl),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                (_isLosding)
                    ? LinearProgressIndicator()
                    : Padding(padding: EdgeInsets.only(top: 0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photourl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Write a Caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                        controller: _descController,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    // Divider(
                    //   // height: 20,
                    //   color: Colors.grey,
                    // ),
                  ],
                )
              ],
            ),
          );
  }
}
