import 'dart:io';

import 'package:FlutterMessenger/widgets/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String userName,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitToFirebase;

  AuthForm(this.submitToFirebase, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var isLogin = false;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  File _userPickedImage;

  //this function will be passed to userImage widget in line 73
  void _pickedImage(File image) {
    _userPickedImage = image;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isLogin && _userPickedImage == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please selcet an image"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();
      widget.submitToFirebase(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userPickedImage,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin) UserImage(_pickedImage),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email address"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!value.contains("@") || !value.contains(".")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    key: ValueKey("email"),
                  ),
                  if (!isLogin)
                    TextFormField(
                      decoration: InputDecoration(labelText: "Username"),
                      validator: (value) {
                        if (value.length < 4) {
                          return "Username must be at lest 4 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                      key: ValueKey("username"),
                    ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value.length < 7) {
                        return "Password must be at least 7 characters.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    key: ValueKey("pass"),
                  ),
                  SizedBox(height: 15),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(isLogin ? "Login" : "Sign Up"),
                      onPressed: _submit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(
                        isLogin
                            ? "Create new account"
                            : "I alraedy have an account",
                      ),
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      textColor: Color.fromRGBO(212, 175, 55, 1.0),
                    ),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
          ),
        ),
        margin: const EdgeInsets.all(18),
      ),
    );
  }
}
