


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/color.dart';
import '../../services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class uploadscreen extends StatefulWidget {
  const uploadscreen({super.key});

  @override
  State<uploadscreen> createState() => _uploadscreenState();
}

class _uploadscreenState extends State<uploadscreen> {


  var userid;
  String? imageUrl;


  Future<void> uploadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = (prefs.getString('userid') ?? "");
    try {
      if (imageUrl == null) {
        print("Please pick an image first");
        return;
      }
      FormData formData = FormData.fromMap({
        'media': await MultipartFile.fromFile(imageUrl!),
      });
      var response = await ProfileService.verificationimage(formData);
      if (response.statusCode == 201) {
        print("Image uploaded successfully");
        print(response.data);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bottomnav()),
        );
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print("Exception during image upload: $e");
    }
  }


  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        
      children: [
        
        InkWell(
          onTap: (){
            pickImages();
          },
          child: Align(
            alignment: Alignment.center,
            child: Icon(Icons.camera_alt,
              size: 75,
              color: bluetext,

            ),
          ),
        ),


        Container(
          height: 300,
          width: 300,
          child: imageUrl != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Image.file(File(imageUrl!)),
          )
              : Container(), // This will render an empty container if imageUrl is null
        ),



        InkWell(
          onTap: (){
            uploadImage();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              width: 400,
              decoration: BoxDecoration(
               color: bluetext,
                borderRadius: BorderRadius.circular(10), // Optional: Add borderRadius to round the corners
              ),
              child: Center(
                  child: Text("Upload",style: TextStyle(fontSize: 12,color: white),)),
            ),
          ),
        ),

      ],

      ),
    );
  }
}


