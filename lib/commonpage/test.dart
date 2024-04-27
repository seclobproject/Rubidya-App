// // import 'dart:typed_data';
// // import 'dart:ui' as ui;
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// //
// //
// //
// // class MyHomePages extends StatefulWidget {
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePages> {
// //   final GlobalKey _globalKey = GlobalKey();
// //   final List<List<double>> filters = [
// //     [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
// //     [0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722],
// //     [0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534, 0.131],
// //     [0.3, 0.59, 0.11, 0, 0, 0.2, 0.41, 0.09, 0, 0, 0.1, 0.2, 0.04],
// //   ];
// //
// //   void convertWidgetToImage() async {
// //     RenderRepaintBoundary? repaintBoundary =
// //     _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
// //     ui.Image? boxImage = await repaintBoundary?.toImage(pixelRatio: 1.0);
// //     ByteData? byteData = await boxImage?.toByteData(format: ui.ImageByteFormat.png);
// //     Uint8List? uint8list = byteData?.buffer.asUint8List();
// //     if (uint8list != null) {
// //       Navigator.of(_globalKey.currentContext!).push(MaterialPageRoute(
// //         builder: (context) => SecondScreen(imageData: uint8list),
// //       ));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final Size size = MediaQuery.of(context).size;
// //     final Image image = Image.asset(
// //       "assets/images/sample.png",
// //       width: size.width,
// //       fit: BoxFit.cover,
// //     );
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Image Filters"),
// //         backgroundColor: Colors.deepOrange,
// //         actions: [IconButton(icon: Icon(Icons.check), onPressed: convertWidgetToImage)],
// //       ),
// //       backgroundColor: Colors.black,
// //       body: Center(
// //         child: RepaintBoundary(
// //           key: _globalKey,
// //           child: Container(
// //             constraints: BoxConstraints(
// //               maxWidth: size.width,
// //               maxHeight: size.width,
// //             ),
// //             child: PageView.builder(
// //               itemCount: filters.length,
// //               itemBuilder: (context, index) {
// //                 return ColorFiltered(
// //                   colorFilter: ColorFilter.matrix(filters[index]),
// //                   child: image,
// //                 );
// //               },
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isExpanded ? null : 40, // Adjust height when expanded
            child: Text(
              'First true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
              maxLines: isExpanded ? null : 1,
              style: TextStyle(fontSize: 11),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'See Less' : 'See More',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Expandable Text')),
      body: ExpandableText(),
    ),
  ));
}
