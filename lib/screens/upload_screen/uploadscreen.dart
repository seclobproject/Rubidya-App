import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../commonpage/filters.dart';
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

  // Define selectedFilterIndex variable
  int selectedFilterIndex = 0; // Initialize with 0 or any default value

  final List<List<double>> filters = [
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX,
    COOL_MATRIX,
    LEGEND_MATRIX,
    ANJU_MATRIX,
    // XABI_MATRIX
  ];

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
      File? croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          imageUrl = croppedFile.path;
        });
      }
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File? croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          imageUrl = croppedFile.path;
        });
      }
    }
  }

  // Future<File?> _instagramStyleCrop(String imagePath) async {
  //   final imageCropper = ImageCropper();
  //   File? croppedFile = await imageCropper.cropImage(
  //     sourcePath: imagePath,
  //     aspectRatioPresets: [
  //       // CropAspectRatioPreset.square,
  //       // CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.original,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio16x9
  //     ],
  //     androidUiSettings: AndroidUiSettings(
  //       toolbarTitle: 'Crop Image',
  //       toolbarColor: Colors.blue,
  //       toolbarWidgetColor: Colors.white,
  //       hideBottomControls: true,
  //     ),
  //   );
  //   return croppedFile;
  // }
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

  // Add a new Image widget to display the current image with the selected filter applied
  Widget filteredImage() {
    if (imageUrl != null) {
      if (selectedFilterIndex == 0) {
        // Display original image without any filter
        return Image.file(
          File(imageUrl!),
          fit: BoxFit.fill,
        );
      } else {
        // Apply the selected filter to the image
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(filters[selectedFilterIndex]),
          child: Image.file(
            File(imageUrl!),
            fit: BoxFit.fill,
          ),
        );
      }
    } else {
      return Container(); // Return an empty container when no image URL is available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Upload",style: TextStyle(fontSize: 14),),
        // actions: [
        //   if (imageUrl != null)
        //   IconButton(onPressed: uploadImage, icon:Icon(Icons.check)) ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),

          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(30, 3, 20, 0),
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: conainer220,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description...',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (text) {
                    setState(() {
                      description = text;
                    });
                  },
                ),
              ),
            ),
          Center(
            child: Container(
              color: white,
              height: 350,
              width: 600,
              child: Stack(
                children: [
                  // Render the filtered image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: filteredImage(),
                  ),
                  SizedBox(height: 40,),

                ],
              ),
            ),
          ),


          if (imageUrl != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 100, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Apply the selected filter
                        setState(() {
                          selectedFilterIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(filters[index]),
                          child: Image.network('https://cdn.britannica.com/45/5645-050-B9EC0205/head-treasure-flower-disk-flowers-inflorescence-ray.jpg'), // Placeholder image path
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          SizedBox(height: 20,),

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
              child: Icon(Icons.photo_camera_back_rounded, color: Colors.black),
              backgroundColor: Colors.white,
              onTap: () {
                pickImages();
              },
              label: 'Gallery',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.white,
            ),
            SpeedDialChild(
              child: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              onTap: () {
                pickImageFromCamera();
              },
              label: 'Camera',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}



