import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:rubidya/commonpage/second_screen.dart';

import 'filters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../services/upload_image.dart';
import '../../../navigation/bottom_navigation.dart';

class MyHomePages extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePages> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    SEPIA_MATRIX, GREYSCALE_MATRIX , VINTAGE_MATRIX, SWEET_MATRIX];

  void convertWidgetToImage() async {
    RenderRepaintBoundary? repaintBoundary =
    _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (repaintBoundary != null) {
      ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
      ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? uint8list = byteData?.buffer.asUint8List();
      if (uint8list != null) {
        Navigator.of(_globalKey.currentContext!).push(MaterialPageRoute(
          builder: (context) => SecondScreen(
            key: UniqueKey(), // Providing a unique key
            imageData: uint8list,
          ),
        ));
      }
    }
  }


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





  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Image image = Image.asset(
      "assets/images/sample.png",
      width: size.width,
      fit: BoxFit.cover,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image Filters",
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage)],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width,
              maxHeight: size.width,
            ),
            child: PageView.builder(
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.matrix(filters[index]),
                    child: image,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
