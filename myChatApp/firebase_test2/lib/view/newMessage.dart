import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController  msgController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  msgController.dispose();
  }
  Future<void> sendMsg() async {
    var enteredMsg = msgController.text;

    if(enteredMsg.trim().isEmpty)    return;

    // FocusScope.of(context).unfocus();

    final User user= await FirebaseAuth.instance.currentUser!;

     final userData = await  FirebaseFirestore.instance.collection("users").
     doc(user.uid).get();

     await FirebaseFirestore.instance.collection("chat").add({
      "text": enteredMsg,
      "time": DateTime.timestamp(),
      "userId": user.uid,
      "userName": userData.data()!["username"],
      "userImage": userData.data()!["userImage"],
    });

    msgController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(padding:  EdgeInsets.only(top:8,left: 15,right: 5,bottom: 8),
      child: Container(

        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: msgController,
                autocorrect: false,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                decoration: InputDecoration(
                    fillColor: Colors.grey[900] , filled: true ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20) , borderSide: BorderSide.none),
                    hintText: "Send a message..."),
              ),
            ),
            SizedBox(width: 10,),
            CircleAvatar(
              backgroundColor: Colors.grey[900],radius: 30,
              child:IconButton(onPressed: sendMsg
                , icon: Icon(Icons.send , size: 30,),

              ),
            )
          ]
    ),
      ),
    );
  }
}
