//
//
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../resources/color.dart';
// import '../../services/profile_service.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'package:dio/dio.dart';
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../navigation/bottom_navigation.dart';
// import '../../../resources/color.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
//
// class uploadscreen extends StatefulWidget {
//   const uploadscreen({super.key});
//
//   @override
//   State<uploadscreen> createState() => _uploadscreenState();
// }
//
// class _uploadscreenState extends State<uploadscreen> {
//
//
//   var userid;
//   String? imageUrl;
//
//
//   Future<void> uploadImage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     userid = (prefs.getString('userid') ?? "");
//     try {
//       if (imageUrl == null) {
//         print("Please pick an image first");
//         return;
//       }
//       FormData formData = FormData.fromMap({
//         'media': await MultipartFile.fromFile(imageUrl!),
//       });
//       var response = await ProfileService.verificationimage(formData);
//       if (response.statusCode == 201) {
//         print("Image uploaded successfully");
//         print(response.data);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Bottomnav()),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Bottomnav()),
//         );
//         print(response.statusCode);
//         print(response.data);
//       }
//     } catch (e) {
//       print("Exception during image upload: $e");
//     }
//   }
//
//
//   Future<void> pickImages() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         imageUrl = pickedFile.path;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//
//
//       children: [
//
//         SizedBox(height: 100,),
//
//         InkWell(
//           onTap: (){
//             pickImages();
//           },
//           child: Align(
//             alignment: Alignment.center,
//             child: Icon(Icons.camera_alt,
//               size: 60,
//               color: bluetext,
//
//             ),
//           ),
//         ),
//
//
//         Container(
//           height: 150,
//           width: 300,
//           child: imageUrl != null
//               ? Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Image.file(File(imageUrl!)),
//           )
//               : Container(), // This will render an empty container if imageUrl is null
//         ),
//
//       ],
//
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: SizedBox(
//           height: 40,
//           width: 400,
//           child: FloatingActionButton.extended(
//             backgroundColor: bluetext,
//             onPressed: (){
//
//               uploadImage();
//             },
//             label: Text('Upload',style: TextStyle(fontSize: 10,color: white),),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//

import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../services/upload_image.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';

class uploadscreen extends StatefulWidget {
  const uploadscreen({Key? key}) : super(key: key);

  @override
  State<uploadscreen> createState() => _uploadscreenState();
}

class _uploadscreenState extends State<uploadscreen> {
  var userid;
  String? imageUrl;
  String? description;
  bool showIndicator = false;
  bool uploading = false; // Flag to track if upload is in progress

  Future<void> uploadImage() async {
    setState(() {
      uploading = true; // Set uploading flag to true when upload starts
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = (prefs.getString('userid') ?? "");
    try {
      // Your existing upload logic...
      if (imageUrl == null) {
        print("Please pick an image first");
        return;
      }
      FormData formData = FormData.fromMap({
        'media': await MultipartFile.fromFile(imageUrl!),
        'description': description,

      });
      var response = await UploadService.uploadimage(formData);

      // Assuming response is a map
      if (response['sts'] == "01") {
        print("Image uploaded successfully");
        print(response['msg']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bottomnav()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Bottomnav()),
        );
        print(response['sts']);
        print(response['msg']);
      }
    } catch (e) {
      print("Exception during image upload: $e");
    } finally {
      setState(() {
        uploading = false; // Set uploading flag to false when upload completes or encounters an error
      });
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

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    final imageCropper = ImageCropper();
    File? croppedFile = await imageCropper.cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 100,
      maxHeight: 800,
      maxWidth: 800,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: true,
      ),
    );
    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          SizedBox(
            height: 50,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         pickImages();
          //       },
          //       child: Align(
          //         alignment: Alignment.center,
          //         child: Icon(
          //           Icons.image,
          //           size: 60,
          //           color: bluetext,
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 30,
          //     ),
          //     InkWell(
          //       onTap: () {
          //         pickImageFromCamera();
          //       },
          //       child: Align(
          //         alignment: Alignment.center,
          //         child: Icon(
          //           Icons.camera_alt_rounded,
          //           size: 60,
          //           color: bluetext,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Center(
            child: Container(
              color: white,
              height: 450,
              width: 600,
              child: Stack(
                children: [
                  imageUrl != null
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Image.file(File(imageUrl!)),
                  )
                      : Container(), // This will render an empty container if imageUrl is null
                  if (imageUrl != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20, // Adjust this value as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showIndicator = !showIndicator;
                              uploadImage();
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 40,
                                width: 400,
                                decoration: BoxDecoration(
                                  color: bluetext, // Assuming bluetext is defined as a color
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Upload",
                                    style: TextStyle(fontSize: 12, color: Colors.white), // Assuming white is defined as a color
                                  ),
                                ),
                              ),
                              if (showIndicator)
                                Positioned.fill(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ),

                  SizedBox(height: 10,),
                  if (imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(30, 3, 20, 0),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 70,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black),
                          color: conainer220,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        // controller: description,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description...',
                          hintStyle: TextStyle(color: Colors.black,fontSize: 10),
                        ),
                        style: TextStyle(color: Colors.black),

                        onChanged: (text) {
                          setState(() {
                            description=text;
                          });
                        },
                      ),),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 20.0),
          backgroundColor: bluetext,
          visible: true,
          curve: Curves.bounceIn,
          children: [

            SpeedDialChild(
              child: Icon(Icons.photo_camera_back_rounded,color: Colors.black),
              backgroundColor: Colors.white,
              onTap: () {
                pickImages();
              },
              label: 'Gallery',

              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.white,
            ),


            SpeedDialChild(
              child: Icon(Icons.camera,color: Colors.black,),
              backgroundColor: Colors.white,
              onTap: () {
                pickImageFromCamera();
              },
              label: 'Camera',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.white,
            ),
            // Add more SpeedDialChild widgets for additional menu items
          ],
        ),
      ),


      // floatingActionButton: SizedBox(
      //   height: 45,
      //   width: 400,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: FloatingActionButton.extended(
      //       backgroundColor: bluetext,
      //       onPressed: !uploading
      //           ? () {
      //         uploadImage();
      //       }
      //           : null,
      //       label: Stack(
      //         alignment: Alignment.center,
      //         children: [
      //           uploading
      //               ? SizedBox(
      //             width: 20,
      //             height: 20,
      //             child: CircularProgressIndicator(
      //               color: Colors.white,
      //               strokeWidth: 2,
      //             ),
      //           )
      //               : SizedBox(),
      //           Text(
      //             'Upload',
      //             style: TextStyle(fontSize: 10,color: white),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}





