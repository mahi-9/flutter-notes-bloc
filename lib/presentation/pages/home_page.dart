import 'package:flutter/material.dart';

import '../components/video/video.dart';

class VideoPlayer extends StatelessWidget {


  VideoPlayer({Key key, this.videopath}) : super(key: key);
  final String videopath;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video',
        ),
      ),
      body: Column(
        children: [
          Video.blocProvider(
            // Normally you'll get both the url and the aspect ratio from your video meta data
            videopath,
            aspectRatio: 1.77,
            autoPlay: false,
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Here is your Video',
            ),
          ),
        ],
      ),
    );
  }
}
