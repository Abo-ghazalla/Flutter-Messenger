import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  var _message = "";
  Future<void> _sendMessage() async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    final userData =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _message.trim(),
      "created at": Timestamp.now(),
      "userId": userId,
      "userName": userData.data()["user name"],
      "user_image": userData.data()["user_image"],
    });
    _messageController.clear();
    setState(() {
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(labelText: "wirte a message...."),
              controller: _messageController,
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
    );
  }
}
