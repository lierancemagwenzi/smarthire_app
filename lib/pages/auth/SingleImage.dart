import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';



class SingleImageScreen extends StatefulWidget {
  String url ;
  double ratio;
  int index;


  SingleImageScreen({@required this.url, this.index,this.ratio});

  @override
  _SingleImageScreenState createState() => _SingleImageScreenState();
}




class _SingleImageScreenState extends State<SingleImageScreen> {

  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.transparent,title: Text(""),elevation: 0.0,actions: [InkWell(

          onTap: (){

            Navigator.pop(context);
          },
          child: Icon(Icons.cancel,size:40.0,color: smarthireBlue,))] ,),
      body: Container(
        height: height,
        width: width,
        child: AspectRatio(
            aspectRatio: widget.ratio,
            child: Hero(
            tag: "image-"+widget.index.toString(),
        transitionOnUserGestures: true,
        flightShuttleBuilder:
        (flightContext,
        animation,
        direction,
        fromContext,
        toContext) {
      return Image.network(
        global.fileserver+widget.url,
        width: 20.0,
        height: 20.0,
        fit: BoxFit.contain,
      );},

                child: Image(image: NetworkImage(global.fileserver+widget.url),))),
      ),
    );
  }

}
