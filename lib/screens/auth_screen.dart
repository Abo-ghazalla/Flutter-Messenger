import 'package:flutter/material.dart';
import 'dart:io';
import 'package:FlutterMessenger/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;

  final _auth = FirebaseAuth.instance;

  //this function will be passed to authForm widget in line 82
  Future<void> _submitToFirebase(
    String email,
    String userName,
    String password,
    File _userImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${authResult.user.uid}.jpg");
        //that was to create a folder to store the user's image on firebase 
        //and rename it with the user's ID

        await ref.putFile(_userImage).onComplete;
        //put that image in the folder

        final imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          "user name": userName,
          "email": email,
          "user_image": imageUrl,
        });
        // create a new document for this new user with his info
      }
    } catch (error) {
      var message =
          "An error occurred, Please check your connection and try again";
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitToFirebase, _isLoading),
    );
  }
}
