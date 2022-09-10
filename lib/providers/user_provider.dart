import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  final Authentication _authentication = Authentication();
  model.User? _user;
  model.User get getUser => _user!; //call it when its not null
  Future<void> refreshUser() async {
    model.User user = await _authentication.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
