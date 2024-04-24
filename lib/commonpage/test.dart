import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class MyHomePages extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePages> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    [0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722],
    [0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534, 0.131],
    [0.3, 0.59, 0.11, 0, 0, 0.2, 0.41, 0.09, 0, 0, 0.1, 0.2, 0.04],
  ];

  void convertWidgetToImage() async {
    RenderRepaintBoundary? repaintBoundary =
    _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? boxImage = await repaintBoundary?.toImage(pixelRatio: 1.0);
    ByteData? byteData = await boxImage?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? uint8list = byteData?.buffer.asUint8List();
    if (uint8list != null) {
      Navigator.of(_globalKey.currentContext!).push(MaterialPageRoute(
        builder: (context) => SecondScreen(imageData: uint8list),
      ));
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
        title: Text("Image Filters"),
        backgroundColor: Colors.deepOrange,
        actions: [IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage)],
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
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final Uint8List imageData;

  const SecondScreen({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Image.memory(imageData),
      ),
    );
  }
}

