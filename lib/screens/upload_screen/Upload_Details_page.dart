
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../commonpage/filters.dart';
import '../../navigation/bottom_navigation.dart';
import '../../services/upload_image.dart';
import 'dart:typed_data';
import 'dart:ui' as ui; // Add this import for the Image class
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../services/upload_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
class uploadedetails extends StatefulWidget {
  final Widget imageUrl;

  const uploadedetails({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<uploadedetails> createState() => _uploadedetailsState();
}

class _uploadedetailsState extends State<uploadedetails> {

  var userid;
  String? imageUrl;
  String? description;
  bool showIndicator = false;
  bool uploading = false; // Flag to track if upload is in progress
  bool isLoading = false;

  // Define selectedFilterIndex variable
  int selectedFilterIndex = 0;
  WidgetsToImageController controller = WidgetsToImageController();
  late String userId;
  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initUserId();
  }

  Future<void> _initUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userid') ?? "";
    });
  }

  Future<void> uploadImage() async {
    setState(() {
      uploading = true; // Set uploading flag to true when upload starts
    });

    try {
      // Get the rendered image
      RenderRepaintBoundary boundary = imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uint8List = byteData!.buffer.asUint8List();

      // Create FormData
      FormData formData = FormData.fromMap({
        'media': MultipartFile.fromBytes(
          uint8List,
          filename: 'image.png',
        ),
        'description': description,
      });

      // Upload image
      var response = await UploadService.uploadimage(formData);
      if (response['sts'] == "01") {
        print("Image uploaded successfully");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Bottomnav()),
                (route) => false);
        print(response['msg']);
        // Handle success
      } else {
        print(response['sts']);
        print(response['msg']);
        // Handle failure
      }
    } catch (e) {
      print("Exception during image upload: $e");
      // Handle exception
    } finally {
      setState(() {
        uploading = false; // Set uploading flag to false when upload completes or encounters an error
      });
    }
  }


  void _handleTap() {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Debounce the deductbalance function with a delay of 2000 milliseconds (2 seconds)
    EasyDebounce.debounce(
      'deductbalance', // unique ID for debounce
      Duration(milliseconds: 2000),
        uploadImage
    );

    // After 3 seconds, hide the loading indicator
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        title: Text("Post",style: TextStyle(fontSize: 14),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(30, 3, 20, 0),
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 120,
                width: 400,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.search,
                  maxLength: 150, // Set max length to 150 characters
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

            Divider(color: Colors.black,thickness: .1,),

            SizedBox(height: 10,),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
            //     child: widget.imageUrl,
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:RepaintBoundary(
                key: imageKey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the value as per your requirement
                  child: widget.imageUrl,
                ),
              )
            ),


            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Add location",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                  ),)),
            ),

            Divider(color: Colors.black,thickness: .1,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Tag people",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                  ),)),
            ),

            Divider(color: Colors.black,thickness: .1,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(

                    children: [
                      Text("Audience",style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ),),

                      Expanded(child: SizedBox()),

                      Text("Everyone",style: TextStyle(
                          fontSize: 14,
                          color: gradnew
                      ),),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios_outlined,size: 14,color:gradnew ,)
                    ],
                  )),
            ),

            Divider(color: Colors.black,thickness: .1,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Add music",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                  ),)),
            ),

            Divider(color: Colors.black,thickness: .1,),

            SizedBox(height: 20,),


            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         showIndicator = !showIndicator;
            //         uploadImage(); // Call uploadImage function
            //
            //       });
            //     },
            //     child: Stack(
            //       children: [
            //         Container(
            //           height: 40,
            //           width: 400,
            //           decoration: BoxDecoration(
            //             color: bluetext,
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //           ),
            //           child: Center(
            //             child: Text(
            //               "Share Post",
            //               style: TextStyle(fontSize: 12, color: Colors.white),
            //             ),
            //           ),
            //         ),
            //         if (showIndicator)
            //           Positioned.fill(
            //             child: Center(
            //               child: CircularProgressIndicator(),
            //             ),
            //           ),
            //       ],
            //     ),
            //   ),
            // ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: isLoading ? null : _handleTap, // Prevent tapping when loading
                child: Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    color: bluetext,// Change to your desired color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Share Post",
                          style: TextStyle(color:white, fontSize: 12,fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 50,),


          ],
        ),
      ),
    );
  }
}