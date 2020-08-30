import 'package:flutter/material.dart';
import 'package:FlutterMessenger/widgets/messages/messages.dart';
import 'package:FlutterMessenger/widgets/messages/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (message) {
        print(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
    );
    super.initState();
  }
  // that was for notifications but it is not complete

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DropdownButton(
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 5),
                        const Text("Log Out")
                      ],
                    ),
                  ),
                  value: "log out",
                )
              ],
              onChanged: (value) {
                if (value == "log out") {
                  FirebaseAuth.instance.signOut();
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              child: Messages(),
              onDoubleTap: () {
                FocusScope.of(context).unfocus();
                // hide device keyboard when double tapping in the screen
              },
            ),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
