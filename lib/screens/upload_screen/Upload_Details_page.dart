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
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
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
  bool uploading = false;
  bool isLoading = false;

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
    if (uploading) return;

    setState(() {
      uploading = true;
      isLoading = true;
    });

    try {
      RenderRepaintBoundary boundary =
      imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uint8List = byteData!.buffer.asUint8List();

      FormData formData = FormData.fromMap({
        'media': MultipartFile.fromBytes(
          uint8List,
          filename: 'image.png',
        ),
        'description': description,
      });

      var response = await UploadService.uploadimage(formData);
      if (response['sts'] == "01") {
        print("Image uploaded successfully");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Bottomnav(initialPageIndex: 4)),
              (route) => false,
        );

        print(response['msg']);
      } else {
        print(response['sts']);
        print(response['msg']);
      }
    } on DioException catch (e) {
      print("Exception during image upload: $e");
      String errorMessage = "Connection error. Please try again.";
      if (e.type == DioErrorType.connectionError) {
        errorMessage = "No Internet connection. Please check your network.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Exception during image upload: $e");
    } finally {
      setState(() {
        uploading = false;
        isLoading = false;
      });
    }
  }

  void _handleTap() {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    EasyDebounce.debounce(
      'deductbalance',
      Duration(milliseconds: 3000),
          () {
        uploadImage().then((_) {
          setState(() {
            isLoading = false;
          });
        });
      },
    );

    Future.delayed(Duration(seconds: 15), () {
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
        title: Text(
          "Post",
          style: TextStyle(fontSize: 14),
        ),
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
                  maxLength: 500,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description...',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 12),
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
            Divider(
              color: Colors.black,
              thickness: .1,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RepaintBoundary(
                key: imageKey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: widget.imageUrl,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add location",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  )),
            ),
            Divider(
              color: Colors.black,
              thickness: .1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Tag people",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  )),
            ),
            Divider(
              color: Colors.black,
              thickness: .1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        "Audience",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        "Everyone",
                        style: TextStyle(fontSize: 14, color: gradnew),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                        color: gradnew,
                      )
                    ],
                  )),
            ),
            Divider(
              color: Colors.black,
              thickness: .1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add music",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  )),
            ),
            Divider(
              color: Colors.black,
              thickness: .1,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: isLoading ? null : _handleTap,
                child: Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    color: bluetext,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Share Post",
                          style: TextStyle(
                              color: white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
