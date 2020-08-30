import 'package:flutter/material.dart';
import 'package:FlutterMessenger/widgets/messages/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("created at", descending: true)
          .snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> chatSnapShot) =>
          chatSnapShot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MessageBubble(
                      chatSnapShot.data.docs[i].data()["text"],
                      chatSnapShot.data.docs[i].data()["user_image"],
                      chatSnapShot.data.docs[i].data()["userName"],
                      FirebaseAuth.instance.currentUser.uid ==
                          chatSnapShot.data.docs[i].data()["userId"],
                      key: ValueKey(chatSnapShot.data.docs[i].id),
                    ),
                  ),
                  itemCount: chatSnapShot.data.docs.length,
                  reverse: true,
                ),
    );
  }
}
