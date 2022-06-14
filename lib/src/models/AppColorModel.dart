

import 'package:flutter/material.dart';

class AppColorModel {
  Color maincolor;
  Color darkcolor;
  TextStyle headerStyle;
  TextStyle bodyStyle;
  Color bgColor;
Color whiteColor;
Color favColor;
  Color navbg;
  
  AppColorModel({this.maincolor, this.darkcolor,this.headerStyle,this.bodyStyle,this.bgColor,this.navbg,this.whiteColor,this.favColor});

  factory AppColorModel.fromJson(Map<String, dynamic> json) {
    return AppColorModel(
      maincolor: json["maincolor"],
      darkcolor: json['darkcolor'],
    );
  }
}
