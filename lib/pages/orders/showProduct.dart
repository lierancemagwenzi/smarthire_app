import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/PlaceOrder.dart';

import '../../constants/colors.dart';
import '../../constants/globals.dart';
import '../../constants/sizeroute.dart';
import '../../model/provider.dart';
import '../../model/provider.dart';
import '../../model/provider.dart';
import '../../model/provider.dart';
import '../providers/ShowLocation.dart';

class ShowProductScreen extends StatefulWidget {
  int id;

  ShowProductScreen({@required this.id});

  @override
  _ShowProductScreenState createState() => _ShowProductScreenState();
}

class _ShowProductScreenState extends State<ShowProductScreen> {
  ProviderModel providerModel;
  double height;
  double width;
  List<ReviewModel> reviews = [];
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (providerModel == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: smarthireBlue,
          title: Text(
            "Product",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      List<String> images = [];
      List<double> aspect_ratios = [];

      if (providerModel != null) {
        List<String> gallery = providerModel.product_gallery.split("#");
        List<String> ratios = providerModel.aspect_ratio.split("#");

        gallery.removeLast();
        ratios.removeLast();
        for (int i = 0; i < gallery.length; i++) {
          images.add(gallery[i]);
        }
        for (int i = 0; i < ratios.length; i++) {
          aspect_ratios.add(double.parse(ratios[i]));
        }
      }
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
//              actions: [
//                Padding(
//                  padding: const EdgeInsets.only(right: 8.0),
//                  child: LikeButton(
//                    size: 30,
//                    circleColor: CircleColor(
//                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
//                    bubblesColor: BubblesColor(
//                      dotPrimaryColor: Color(0xff33b5e5),
//                      dotSecondaryColor: Color(0xff0099cc),
//                    ),
//                    likeBuilder: (bool isLiked) {
//                      return Icon(
//                        isLiked ? Icons.favorite : Icons.favorite_border,
//                        color: isLiked ? smarthireBlue : smarthireBlue,
//                        size: 30,
//                      );
//                    },
////            likeCount: 665,
////            countBuilder: (int count, bool isLiked, String text) {
////              var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
////              Widget result;
////              if (count == 0) {
////                result = Text(
////                  "love",
////                  style: TextStyle(color: color),
////                );
////              } else
////                result = Text(
////                  text,
////                  style: TextStyle(color: color),
////                );
////              return result;
////            },
//                  ),
//                )
//              ],
              backgroundColor: Colors.white,
              title: Text(
                providerModel.product_type,
                style: TextStyle(color: smarthireBlue),
              ),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: smarthireBlue,
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                //  crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  //    Container(
                  //      height: height*0.2,
                  //      child: AspectRatio(
                  //        aspectRatio: 6/6,
                  //        child: CircleAvatar(
                  //          backgroundColor: smarthireBlue,
                  //        ),
                  //      ),
                  //    ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: smarthireBlue,
                          image: DecorationImage(
                              image: NetworkImage(
                                global.fileserver + images[0],
                              ),
                              fit: BoxFit.fitWidth)),
                      height: height * 0.2,
                      child: Stack(
                        children: [
//              AspectRatio(
//                aspectRatio:3/2,
//                child: Image(
//                  image: NetworkImage(global.fileserver+images[0],),fit: BoxFit.cover,
//                ),
//              ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                providerModel.provider_name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "sans",
                                    fontSize: 18.0),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "Product/Service".toUpperCase(),
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 18.0,
                        fontFamily: "sans"),
                  ),
                  Text(
                    providerModel.service_name,
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 13.0,
                        fontFamily: "sans"),
                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  Text(
                    providerModel.product_type == "service"
                        ? "Callout Fee".toUpperCase()
                        : "Price".toUpperCase(),
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 18.0,
                        fontFamily: "sans"),
                  ),
                  Text(
                    providerModel.currency + providerModel.price,
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 13.0,
                        fontFamily: "sans"),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                SizeRoute(
                                    page: GoogleMapsDemo(
                                  lat: double.parse(
                                      providerModel.coord.split("#")[0]),
                                  lang: double.parse(
                                    providerModel.coord.split("#")[1],
                                  ),
                                )));
                          },
                          child: Text(
                            "Location".toUpperCase(),
                            style: TextStyle(
                                color: smarthireBlue,
                                fontSize: 18.0,
                                fontFamily: "sans"),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.location_on,
                          color: smarthirePurple,
                          size: 20.0,
                        ),
                      )
                    ],
                  ),

                  Text(
                    providerModel.location,
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 13.0,
                        fontFamily: "sans"),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "About".toUpperCase(),
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 18.0,
                        fontFamily: "sans"),
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    providerModel.description,
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 13.0,
                        fontFamily: "sans"),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    "Gallery".toUpperCase(),
                    style: TextStyle(
                        color: smarthireBlue,
                        fontSize: 18.0,
                        fontFamily: "sans"),
                  ),

                  Gallery(),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  reviewBubble(ReviewModel reviewModel) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: height * .01, horizontal: width * .03),
      child: Card(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * .01, horizontal: width * .03),
            child: Column(
              children: [
                Row(
                  children: [
                    //profile,
                    Container(
                      width: width * 0.15,
                      child: AspectRatio(
                        aspectRatio: 6 / 6,
                        child: Image.network(reviewModel.user_profile),
                      ),
                    ),
                    //username
                    Padding(
                      padding: EdgeInsets.only(left: width * .04),
                      child: Text(
                        reviewModel.reviewer_name,
                        style: TextStyle(
                            color: smarthireBlue,
                            fontFamily: "sans",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    //comment
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * .02,
                          top: height * .01,
                          bottom: height * .01),
                      child: AutoSizeText(
                        reviewModel.comment,
                        style:
                            TextStyle(color: smarthireBlue, fontFamily: "sans"),
                        maxLines: 15,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //date posted
                    Text(
                      reviewModel.review_date,
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Gallery() {
    List<String> images = [];
    List<double> aspect_ratios = [];
    List<String> gallery = providerModel.product_gallery.split("#");
    List<String> ratios = providerModel.aspect_ratio.split("#");

    gallery.removeLast();
    ratios.removeLast();
    for (int i = 0; i < gallery.length; i++) {
      images.add(gallery[i]);
    }
    for (int i = 0; i < ratios.length; i++) {
      aspect_ratios.add(double.parse(ratios[i]));
    }

    print("gallery");
    print(images);
    print(aspect_ratios);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Container(
        height: height * 0.2,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
//                physics: ClampingScrollPhysics(),

            itemCount: images.length,
//                shrinkWrap: true,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: AspectRatio(
                  aspectRatio: aspect_ratios[index],
                  child: Hero(
                    tag: "image-" + index.toString(),
                    transitionOnUserGestures: true,
                    flightShuttleBuilder: (flightContext, animation, direction,
                        fromContext, toContext) {
                      return Image.network(
                        global.fileserver + images[index],
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.contain,
                      );
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleImageScreen(
                                      url: images[index],
                                      ratio: aspect_ratios[index],
                                      index: index,
                                    )));
                      },
                      child: Image.network(global.fileserver + images[index]),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  getProduct() async {
    setState(() {
      loading = true;
    });
    var path = "/api/product/" + widget.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      ProviderModel providerModel =
          ProviderModel.fromJson(json.decode(response.body));
      providerModel.profile_pic = global.fileserver + providerModel.profile_pic;
      setState(() {
        this.providerModel = providerModel;
      });
    } else {}

    setState(() {
      loading = false;
    });
  }
}
