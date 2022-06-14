import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
AdvertShimmer(
  double width,
  double height,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.0),
    child: Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          color: Colors.grey,
//        width: 200.0,
//        height: 100.0,
          child: Text(
            'Shimmer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
