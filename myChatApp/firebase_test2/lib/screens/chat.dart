import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/view/newMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/chatMessage.dart';

class ChattScreen extends StatelessWidget {
  const ChattScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black45,
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.logout)),
        ],
        centerTitle: true,
        title:  Text("My Chatt "),
      ),

        body: Container(
          color: Colors.black,
          child: Column(

            children:[
              Expanded(
                  child: ChatMessages(),
              ),
              NewMessage(),

            ]
          ),
        )
    );
  }
}
