import 'dart:math';

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userImageUrl;
  final String userName;
  final bool isMe;
  final Key key;

  MessageBubble(
    this.message,
    this.userImageUrl,
    this.userName,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Text(
                      userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  Container(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 200,
                      minWidth: max(80.0, userName.length * 15.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ],
              ),
              Positioned(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userImageUrl),
                ),
                top: -8,
                left: -12,
              )
            ],
            overflow: Overflow.visible,
          ),
        ],
      ),
    );
  }
}
