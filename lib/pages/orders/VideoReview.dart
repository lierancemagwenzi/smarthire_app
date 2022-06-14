import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:smarthire/constants/globals.dart' as globals;

class ReviewVideoPlayerScreen extends StatefulWidget {
  String url;
  bool showback;

  ReviewVideoPlayerScreen({@required this.url, this.showback});

  @override
  _ReviewVideoPlayerScreenState createState() =>
      _ReviewVideoPlayerScreenState();
}

class _ReviewVideoPlayerScreenState extends State<ReviewVideoPlayerScreen> {
  double height;
  double width;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url,
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((value) {
      _controller.play();
      return null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          "Review Video",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    if (_controller != null && _controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                  child: VideoPlayer(_controller)),
              VideoProgressIndicator(_controller, allowScrubbing: true),
            ],
          ),
        ),
      ),
    );
  }
}
