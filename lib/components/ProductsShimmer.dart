import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//ServiceShimmer(double width, double height) {
//  return Shimmer.fromColors(
//    baseColor: Colors.grey[300],
//    highlightColor: Colors.grey[100],
//    child: Container(
//      height: height,
//      width: width,
//      child: Column(
//        children: <Widget>[
//          Container(
//            height: height * 0.6,
//            color: Colors.grey,
//          ),
//          SizedBox(
//            height: 10.0,
//          ),
//          Container(
//            height: height * 0.05,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Container(
//                  width: width * 0.6,
//                  height: height * 0.2,
//                  color: Colors.grey,
//                ),
//                Container(
//                  width: width * 0.2,
//                  color: Colors.grey,
//                )
//              ],
//            ),
//          ),
//          Expanded(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Container(
//                  width: width * 0.6,
//                  height: height * 0.2,
//                  color: Colors.grey,
//                ),
//                Container(
//                  width: width * 0.2,
//                  color: Colors.grey,
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    ),
//  );
//}
//

ProductShimmer(double widthh, double height) {
  double width = widthh * 0.7;
  return Container(
    height: height,
    child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                height: height,
                width: width,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: height * 0.6,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: width * 0.6,
                            height: height * 0.2,
                            color: Colors.grey,
                          ),
                          Container(
                            width: width * 0.2,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: width * 0.6,
                            height: height * 0.2,
                            color: Colors.grey,
                          ),
                          Container(
                            width: width * 0.2,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
  );
}
