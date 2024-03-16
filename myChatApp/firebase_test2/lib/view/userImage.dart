

import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePiker extends StatefulWidget {
  const UserImagePiker({Key? key, required this.onPickedImage}) : super(key: key);
  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePiker> createState() => _UserImagePikerState();
}

class _UserImagePikerState extends State<UserImagePiker> {

     File? pickedImageFile;
  Future _pickImage() async {
     var pickedImage  = await ImagePicker().pickImage (
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150) ;

    if(pickedImage == null) {
      return;
    }
     final temp= pickedImage;

    setState(() {
      // pickedImageFile = pickedImage as File? ;
      pickedImageFile = File(temp.path) ; // this is not working

    });
    widget.onPickedImage(pickedImageFile!);
  }






  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
          pickedImageFile == null ? null :  FileImage(pickedImageFile!),
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text("Add Image",
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),

            ))
      ],
    );
  }
}
