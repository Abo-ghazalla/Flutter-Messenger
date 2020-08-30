import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Shop App"),),
          body: Center(child:Text("Loading.....")
        
      ),
    );
  }
}