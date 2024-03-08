import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class YoutubePlayerScreen extends StatefulWidget {
  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Replace 'YOUR_YOUTUBE_VIDEO_ID' with the actual YouTube video ID
    _controller = YoutubePlayerController(
      initialVideoId: 'https://www.youtube.com/watch?v=Cp9XtBuO2d4&list=RDCp9XtBuO2d4&start_radio=1',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {

            // Do something when the video is ready to play
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
