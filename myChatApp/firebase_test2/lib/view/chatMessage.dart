import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
   const ChatMessages({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userAuth=FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.only(top : 8 , left: 15 , right: 15 , bottom: 30),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("chat").orderBy("time", descending: true).snapshots(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return Center(child: Text("No data found"));
            }
            if(snapshot.hasError){
              return Center(child: Text("Error occured"));
            }
            final chatDocs = snapshot.data!.docs;
            return ListView.builder(
              reverse: true ,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                final chatMsg = chatDocs[index].data();
                final nextMsg = index + 1 < chatDocs.length ? chatDocs[index + 1].data() : null;
                final currentMsgUserId = chatMsg["userId"];
                final nextMsgUserId = nextMsg!=null?  nextMsg!["userId"]:null ;
                final isMe = currentMsgUserId == nextMsgUserId? true : false;
                if (isMe) {
                return MessageBubble.next(
                      message:chatMsg['text'],
                      isMe: userAuth!.uid==currentMsgUserId,
                );
                }
                else{
                    return MessageBubble.first(
                                userImage: chatMsg['userImage'],
                                username: chatMsg['userName'] ,
                                message: chatMsg['text'],
                                isMe: userAuth!.uid==currentMsgUserId
                );
                }



              }
                    );
  },
      ),
    );
  }
}
