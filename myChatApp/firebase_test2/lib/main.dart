
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/screens/Splash.dart';
import 'package:firebase_test/screens/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_test/screens/auth.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'My Chat App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home:StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (ctx, userSnapshot) {
       if(userSnapshot.connectionState == ConnectionState.waiting)
         return SplashScreen();

        if(userSnapshot.hasData){
          return ChattScreen();
        }
        return AuthScreen();
      },),
    );
  }
}

