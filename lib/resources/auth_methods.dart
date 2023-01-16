import 'dart:typed_data';
import 'package:instagram_clone/models/user_model.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance; //auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //returns the user data for the current authenticated user
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    // print(snapshot.data());
    //
    return model.User.fromSnap(
        snapshot); //returns converted snapshot data as map
  }

  //sign up method
  Future<String> signUpUser({
    required String username,
    required String bio,
    required String email,
    required String pass,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          pass.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        //register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        // print(credential.user!.uid); //user id//using user! as it may be null

        //storing image in storage
        String downloadUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePics', file, false);
        // print(downloadUrl);
        //add user to database

        //creating a user model
        model.User user = model.User.name(
            username, email, credential.user!.uid, bio, downloadUrl, [], []);

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson()); //create a collection users if its not there
        //then create a document of uid if its not already there
        //and in this document put this data
        res = "Success!";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String pass}) async {
    String res = "Some error occured";
    try {
      //validation
      if (email.isNotEmpty && pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        res = "Success!";
      } else {
        res = "Enter all Fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
