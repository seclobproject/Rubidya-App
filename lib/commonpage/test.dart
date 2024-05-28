import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String description;

  const ExpandableTextWidget({Key? key, required this.description}) : super(key: key);

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
      Center(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 150,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: isExpanded ? null : 40, // Adjust height when expanded
              child: Linkify(
                onOpen: _onOpen,
                text: widget.description,
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                linkStyle: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          if (widget.description.split('\n').length > 2) // Check for multiline
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded; // Toggle the isExpanded state
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    isExpanded ? 'See Less' : 'See More ',
                    style: TextStyle(color: Colors.blue, fontSize: 8),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
        ],
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch ${link.url}';
    }
  }
}
