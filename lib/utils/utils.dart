import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Util {
  static pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null)
      return await file.readAsBytes();
    else
      print('No image selected');
  }

  static showSnackBar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
