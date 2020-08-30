import 'package:FlutterMessenger/screens/auth_screen.dart';
import 'package:FlutterMessenger/screens/chat_screen.dart';
import 'package:FlutterMessenger/screens/waiting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Messenger',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Color.fromRGBO(93, 74, 102, 1.0),
        accentColor: Color.fromRGBO(212, 175, 55, 1.0),
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        //must intialize firebase before start using it so, I used future builder
        // as this line returns a future

        builder: (_, intializationSnapShot) =>
            intializationSnapShot.connectionState != ConnectionState.done
                ? WaitingScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    //use stream builder to listen to any chabges in 
                    //user's sign-in state
                    
                    builder: (_, authSnapShot) {
                      if (authSnapShot.hasData) {
                        return ChatScreen();
                      }
                      if (authSnapShot.connectionState ==
                          ConnectionState.waiting) {
                        return WaitingScreen();
                      }
                      return AuthScreen();
                    }),
      ),
    );
  }
}
