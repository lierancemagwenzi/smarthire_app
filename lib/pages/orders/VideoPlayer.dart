import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:smarthire/constants/globals.dart' as globals;

class VideoPlayerScreen extends StatefulWidget {
  File file;
  bool showback;

  VideoPlayerScreen({@required this.file, this.showback});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  double height;
  double width;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      widget.file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
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
        automaticallyImplyLeading: widget.showback,
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
              VideoPlayer(_controller),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        globals.deleted = true;

                        deleteFile();
                        Navigator.pop(context, null);
                      },
                      child: CircleAvatar(
                          backgroundColor: smarthireBlue,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, widget.file);
                      },
                      child: CircleAvatar(
                          backgroundColor: smarthireBlue,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteFile() async {
    try {
      var file = widget.file;

      if (await file.exists()) {
        // file exits, it is safe to call delete on it
        await file.delete();
      }
    } catch (e) {
      // error in getting access to the file
    }
  }
}
