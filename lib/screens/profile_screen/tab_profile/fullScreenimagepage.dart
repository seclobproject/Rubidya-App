import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;
  final int likeCount;

  const FullScreenVideoPage({required this.videoUrl, required this.likeCount});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _videoController;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play(); // Start playing the video once it's initialized
      });
    _listener = () {
      if (mounted) setState(() {});
    };
    _videoController.addListener(_listener);
  }

  @override
  void dispose() {
    _videoController.pause(); // Pause the video before disposing
    _videoController.removeListener(_listener);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
                : CircularProgressIndicator(),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _ControlsOverlay(
              controller: _videoController,
              likeCount: widget.likeCount, // Pass the likeCount parameter here
            ),
          ),

        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  final int likeCount;

  const _ControlsOverlay({required this.controller, required this.likeCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow), // Toggle play/pause icon
                onPressed: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                color: Colors.white,
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.comment), // Add comment icon
                onPressed: () {
                  // Add your comment functionality here
                },
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite), // Add like icon
                    onPressed: () {
                      // Add your like functionality here
                    },
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$likeCount',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.send), // Add share icon
                onPressed: () {
                  // Add your share functionality here
                },
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}