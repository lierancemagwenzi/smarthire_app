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
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/PlaceOrder.dart';

class SingleProviderScreen extends StatefulWidget {
  int index;
  ProviderModel providerModel;

  SingleProviderScreen({@required this.providerModel, this.index});
  @override
  _SingleProviderScreenState createState() => _SingleProviderScreenState();
}

class _SingleProviderScreenState extends State<SingleProviderScreen> {
  double height;
  double width;
  List<ReviewModel> reviews = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  getReviews() async {
    var path = "/api/review/" + widget.providerModel.provider_id.toString();
    var response = await get(global.url + path);

    print("reviews" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        ReviewModel reviewModel = ReviewModel.fromJson(list[i]);
        reviewModel.user_profile = global.fileserver + reviewModel.user_profile;

        setState(() {
          reviews.add(reviewModel);
        });
      }
    } else {}
  }

  Future<void> SendReview() async {
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/review',
            body: jsonEncode({
              "comment": _controller.text,
              "user_id": global.id,
              "provider_id": widget.providerModel.provider_id
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        ReviewModel reviewModel =
            ReviewModel.fromJson(jsonDecode(response.body));
        reviewModel.user_profile = global.fileserver + reviewModel.user_profile;
        setState(() {
          reviews.add(reviewModel);
        });
      } else {
        if (response.statusCode == 401) {}
      }
    } on TimeoutException catch (e) {
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      setState(() {});
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      print('kkkkkk General Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var index = widget.index;

    List<String> images = [];
    List<double> aspect_ratios = [];
    List<String> gallery = widget.providerModel.product_gallery.split("#");
    List<String> ratios = widget.providerModel.aspect_ratio.split("#");

    gallery.removeLast();
    ratios.removeLast();
    for (int i = 0; i < gallery.length; i++) {
      images.add(gallery[i]);
    }
    for (int i = 0; i < ratios.length; i++) {
      aspect_ratios.add(double.parse(ratios[i]));
    }
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: global.id == 0
          ? null
          : BottomAppBar(
              child: Container(
                height: height * 0.07,
                color: smarthireBlue,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            if (_controller.text != null &&
                                _controller.text.length > 0) {
                              SendReview();
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: smarthireBlue,
                          ),
                        ),
                        hintStyle: new TextStyle(
                            color: smarthireBlue,
                            fontFamily: 'sans',
                            fontSize: 14.0),
                        hintText: "Type in review comment....",
                        fillColor: smarthireWhite),
                  ),
                ),
              ),
            ),
//      floatingActionButton: global.id==0?null: FloatingActionButton.extended(
//        onPressed:global.id==0?null: () {},
//        icon: Icon(Icons.chat_bubble),
//        label: Text(
//          "Chat with Provider",
//          style: TextStyle(fontFamily: 'sans'),
//        ),
//        backgroundColor: smarthireBlue,
//      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          widget.providerModel.service_name,
          style: TextStyle(fontFamily: "sans"),
        ),
      ),
      body: ListView(
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: widget.providerModel.provider_name + "provider-$index",
            transitionOnUserGestures: true,
            flightShuttleBuilder:
                (flightContext, animation, direction, fromContext, toContext) {
              return Image.network(
                global.fileserver + images[0],
                width: 20.0,
                height: 20.0,
                fit: BoxFit.contain,
              );
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: height * .04),
                child: Container(
                  height: height * 0.3,
                  child: AspectRatio(
                      aspectRatio: 6 / 6,
                      child: Center(
                          child: Image(
                        image: NetworkImage(global.fileserver + images[0]),
                      ))),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: smarthirePurple,
                ),
                onRatingUpdate: (rating) {
                  if (global.id == 0) {
                    showInSnackBar("Please login to rate");
                  } else {
                    print(rating);
                  }
                },
              )
            ],
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .08),
                child: Text(
                  widget.providerModel.description,
                  style: TextStyle(fontFamily: "sans"),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          Center(
            child: AutoSizeText(
              widget.providerModel.currency + widget.providerModel.price,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "sans"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width * .08, bottom: height * .02, top: height * .02),
            child: Text(
              "Gallery / Portfolio".toUpperCase(),
              style: TextStyle(
                  color: smarthireBlue,
                  fontWeight: FontWeight.w700,
                  fontFamily: "sans",
                  fontSize: 14.0),
            ),
          ),
          Gallery(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton.icon(
                padding: EdgeInsets.symmetric(
                    vertical: height * .015, horizontal: width * .08),
                color: smarthireBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: global.id == 0
                    ? null
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaceOrderScreen(
                                    providerModel: widget.providerModel)));
                      },
                icon: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
                label: Text(
                  "Place An Order",
                  style: TextStyle(color: smarthireWhite, fontFamily: "sans"),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * .02),
            child: Container(
              color: smarthireBlue,
              height: height * .05,
              width: width,
              child: Center(
                  child: Text(
                "Reviews",
                style: TextStyle(
                    color: smarthireWhite, fontFamily: "sans", fontSize: 18),
              )),
            ),
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              itemCount: reviews.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                    width: width * .4, child: reviewBubble(reviews[index]));
              })
        ],
      ),
    );
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
    List<String> gallery = widget.providerModel.product_gallery.split("#");
    List<String> ratios = widget.providerModel.aspect_ratio.split("#");

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
}
