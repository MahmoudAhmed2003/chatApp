import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../view/userImage.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  var _isLogin = false;
  var _username="";
  var _userEmail = "";
  var _userPassword = "";
  File? selectedImage;
  var imgUrl = "";
  var isLoading = false;

  void _trySubmit() async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(!isValid || ( !_isLogin && selectedImage == null) ){
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      if (_isLogin) {
        UserCredential userCerdential = await _auth
            .signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);

        //login
      }
      else {

        UserCredential userCerdential = await _auth
            .createUserWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
       Reference reff= FirebaseStorage.instance.ref().child("user_image").child(userCerdential.user!.uid + ".jpg");
        await reff.putFile(selectedImage!);
         imgUrl = await reff.getDownloadURL();
        print(imgUrl);
        //signup
      }
      FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).set({
        "username": _username,
        "useremail": _userEmail,
        "userImage": imgUrl,
      });
    }
    on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),backgroundColor: Colors.red,));

      setState(() {
        isLoading = false;
      });


    }


      _formKey.currentState!.save();



  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30,bottom: 20)),
                 const Text("Welcome to My Chat App",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Container(

                 margin: const EdgeInsets.only(
                   top:30,
                   bottom: 20,
                   right: 20,
                    left: 20,
                 ),
                width: 200,
                child: Image.asset("assets/imgs/chat.png"),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16 ),
                    child:Form(
                      key: _formKey,
                      child: Column(
                       children:[
                          if(!_isLogin)  UserImagePiker(
                        onPickedImage: (File pickedImage){
                          selectedImage = pickedImage;
                        },
                  ),

                    _isLogin? const SizedBox(height: 0,) :
                         TextFormField(
                           onSaved: (value)=> _username = value!,
                           decoration: const InputDecoration(
                             labelText: "Username",
                           ),
                           autocorrect: false,
                           validator: (value){
                             if(value!.isEmpty  || value.trim().length<4){
                               return "Please enter a at least 4 character ";
                             }
                             return null;
                           },
                         ),
                         TextFormField(
                            onSaved: (value)=> _userEmail = value!,
                           keyboardType: TextInputType.emailAddress,
                           decoration: const InputDecoration(
                             labelText: "Email Address",
                           ),
                           autocorrect: false,
                           textCapitalization: TextCapitalization.none,
                           validator: (value){
                             if(value!.isEmpty || !value.contains("@") || value.trim().isEmpty ){
                               return "Please enter a valid email address";
                             }
                             return null;
                           },
                         ),
                         TextFormField(
                            onSaved: (value)=>_userPassword = value!,

                           decoration: const InputDecoration(
                             labelText: "Password",
                           ),
                           autocorrect: false,
                           textCapitalization: TextCapitalization.none,
                           obscureText: true,
                           validator: (value){
                             if(value!.isEmpty || value.trim().isEmpty){
                               return "Password is required";
                             }
                             else if(!_isLogin && value.length < 7){
                                return "Password is too short";
                             }
                             return null;
                           },
                         ),

                         const SizedBox(height: 20,),
                         isLoading ?  CircularProgressIndicator() :
                         ElevatedButton(onPressed:  _trySubmit,

                             style: ElevatedButton.styleFrom(
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(30),
                               ),
                               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                               backgroundColor: Theme.of(context).primaryColor,

                              ),
                             child:Text(_isLogin ? "Login" : "Signup")),
                         const SizedBox(height: 20,),
                         isLoading ?  CircularProgressIndicator() :
                         TextButton(onPressed:(){
                           setState(() {
                             _isLogin = !_isLogin;
                           });
                         },
                             style: ElevatedButton.styleFrom(
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(30),
                               ),
                               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),

                             ),
                             child:Text(_isLogin  ? "Create account"
                                 : "already have an account "
                                 )
                         ),


                       ],
                      ),

                    )
                  )
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
