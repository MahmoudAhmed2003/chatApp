import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(

          centerTitle: true,
          title:  Text("My Chatt "),
        ),

        body: Center(child: Text("Loading"),)
    );
  }
}
