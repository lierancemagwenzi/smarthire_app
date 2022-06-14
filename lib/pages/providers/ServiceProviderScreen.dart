import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:smarthire/icons/map.dart' as pin;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/orders/PlaceOrder.dart';
import 'package:smarthire/pages/orders/neworder.dart';
import 'package:smarthire/pages/providers/ShowLocation.dart';

class ServiceProviderScreen extends StatefulWidget {
  int index;
  ProviderModel providerModel;

  ServiceProviderScreen({@required this.providerModel, this.index});

  @override
  _ServiceProviderScreenState createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  ScrollController scrollController;

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();
  double height;
  double width;
  List<ReviewModel> reviews = [];

  bool showkeyboard = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
//            actions: [
//              Padding(
//                padding: const EdgeInsets.only(right: 8.0),
//                child: LikeButton(
//                  size: 30,
//                  circleColor: CircleColor(
//                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
//                  bubblesColor: BubblesColor(
//                    dotPrimaryColor: Color(0xff33b5e5),
//                    dotSecondaryColor: Color(0xff0099cc),
//                  ),
//                  likeBuilder: (bool isLiked) {
//                    return Icon(
//                      isLiked ? Icons.favorite : Icons.favorite_border,
//                      color: isLiked ? smarthireBlue : smarthireBlue,
//                      size: 30,
//                    );
//                  },
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
//                ),
//              )
//            ],
            backgroundColor: smarthireBlue,
            title: Text(
              widget.providerModel.product_type,
              style: TextStyle(color: Colors.white),
            ),
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
          bottomNavigationBar: BottomAppBar(
            child:

//      showkeyboard?Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Row(
//          children: [
//            Container(
//              width: width*0.86,
//              child: TextField(
//                controller: _controller ,
//
//                minLines: 3,
//                maxLines: 10,
//                textAlign: TextAlign.center,
//onEditingComplete: (){
//
//
//    if(_controller.text!=null&&_controller.text.length>0){ SendReview();
//}},
////        controller: searchCtrl,
//                keyboardType: TextInputType.text,
//                decoration: InputDecoration(
//                  hintText: 'Write a review',
//                  hintStyle: TextStyle(fontSize: 16),
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(8),
//                    borderSide: BorderSide(
//                      width: 0,
//                      style: BorderStyle.none,
//                    ),
//                  ),
//                  filled: true,
//                  contentPadding: EdgeInsets.all(16),
//                  fillColor: Color(0xffdddddd),
//                ),
//              ),
//            ),InkWell(
//                onTap: (){
//
//                  setState(() {
//                    showkeyboard=false;
//                  });
//                },
//
//                child: Icon(Icons.cancel,color: smarthireBlue,size: 30.0,))
//          ],
//        ),
//      ):

                Container(
              width: width,
              height: 43.0,
              decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.1, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Color(0xff1d83ab),
                    Color(0xff0cbab8),
                  ],
                ),
              ),
              child: FlatButton(
                child: Text(
                  global.id == 0
                      ? "Sign In to Order"
                      : widget.providerModel.product_type == "service"
                          ? 'Hire Service'
                          : "Get Product",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Righteous',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: global.id == 0
                    ? () {
                        Navigator.push(
                            context, SlideRightRoute(page: LoginPage()));
                      }
                    : global.id == widget.providerModel.provider_id
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: NewOrderScreen(
                                  providerModel: widget.providerModel,
                                  index: 0,
                                )));
                          },
              ),
            ),
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
                              widget.providerModel.provider_name,
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
                  widget.providerModel.product_type.toUpperCase(),
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 18.0, fontFamily: "sans"),
                ),
                Text(
                  widget.providerModel.service_name,
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 13.0, fontFamily: "sans"),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                widget.providerModel.product_type == "product"
                    ? Text(
                        "Quantity",
                        style: TextStyle(
                            color: smarthireBlue,
                            fontSize: 18.0,
                            fontFamily: "sans"),
                      )
                    : Container(),
                SizedBox(
                  height: height * 0.01,
                ),
                widget.providerModel.product_type == "product"
                    ? Text(
                        widget.providerModel.quantity +
                            widget.providerModel.unit,
                        style: TextStyle(
                            color: smarthireBlue,
                            fontSize: 13.0,
                            fontFamily: "sans"),
                      )
                    : Container(),

                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  widget.providerModel.product_type == "service"
                      ? "Callout Fee".toUpperCase()
                      : "Price".toUpperCase(),
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 18.0, fontFamily: "sans"),
                ),
                Text(
                  widget.providerModel.currency + widget.providerModel.price,
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 13.0, fontFamily: "sans"),
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
                                    widget.providerModel.coord.split("#")[0]),
                                lang: double.parse(
                                  widget.providerModel.coord.split("#")[1],
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
                        pin.MyFlutterApp.pin,
                        color: smarthirePurple,
                        size: 20.0,
                      ),
                    )
                  ],
                ),

                Text(
                  widget.providerModel.location,
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 13.0, fontFamily: "sans"),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  "About".toUpperCase(),
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 18.0, fontFamily: "sans"),
                ),

                SizedBox(
                  height: height * 0.01,
                ),

                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  widget.providerModel.description,
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 13.0, fontFamily: "sans"),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  "Gallery".toUpperCase(),
                  style: TextStyle(
                      color: smarthireBlue, fontSize: 18.0, fontFamily: "sans"),
                ),

                Gallery(widget.providerModel),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews".toUpperCase(),
                        style: TextStyle(
                            color: smarthireBlue,
                            fontSize: 16.0,
                            fontFamily: "sans"),
                      ),
//                      InkWell(
//                          onTap: () {
//                            setState(() {
//                              showkeyboard = true;
//                            });
//                          },
//                          child: Icon(
//                            Icons.add_circle,
//                            size: 35.0,
//                            color: smarthireBlue,
//                          ))
                    ],
                  ),
                ),

                Reviews(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Gallery(ProviderModel providerModel) {
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
    return Container(
      height: height * 0.1,
      child: ListView.builder(
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctxt, int index) {
            return AspectRatio(
              aspectRatio: 6 / 6,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: width * 0.3,
                child: Card(
                  child: AspectRatio(
                    aspectRatio: 6 / 6,
                    child: Hero(
                      tag: "image-" + index.toString(),
                      transitionOnUserGestures: true,
                      flightShuttleBuilder: (flightContext, animation,
                          direction, fromContext, toContext) {
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
                        child: Image.network(
                          global.fileserver + images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Panel() {
    return SlidingUpPanelWidget(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shadows: [
            BoxShadow(
                blurRadius: 5.0,
                spreadRadius: 2.0,
                color: const Color(0x11000000))
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
//            Container(
//              color: Colors.white,
//              alignment: Alignment.center,
//              height: 50.0,
//              child: Row(
//                children: <Widget>[
//                  Icon(Icons.menu,size: 30,),
//                  Padding(
//                    padding: EdgeInsets.only(left: 8.0,),
//                  ),
//                  Text(
//                    'click or drag',
//                  )
//                ],
//                mainAxisAlignment: MainAxisAlignment.center,
//              ),
//            ),
            Divider(
              height: 0.5,
              color: Colors.grey[300],
            ),
            Flexible(
              child: Container(
                child: ListView.separated(
                  controller: scrollController,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('list item $index'),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 0.5,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: 20,
                ),
                color: Colors.white,
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      controlHeight: 50.0,
      anchor: 0.4,
      panelController: panelController,
      onTap: () {
        ///Customize the processing logic
        if (SlidingUpPanelStatus.expanded == panelController.status) {
          panelController.collapse();
        } else {
          panelController.expand();
        }
      }, //Pass a onTap callback to customize the processing logic when user click control bar.
      enableOnTap: true, //Enable the onTap callback for control bar.
    );
  }

  Reviews() {
    return new ListView.builder(
        itemCount: reviews.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
              .parse(reviews[index].review_date, true);
          var dateLocal = dateTime.toLocal();
          String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              elevation: 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(reviews[index].reviewer_name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reviews[index].comment),
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                  leading: AspectRatio(
                      aspectRatio: 6 / 6,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(reviews[index].user_profile),
                        backgroundColor: smarthireBlue,
                      )),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  getReviews() async {
    var path = "/api/review/" + widget.providerModel.service_id.toString();
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
//              "product_id": widget.providerModel.,
              "provider_id": widget.providerModel.service_id
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        _controller.text = "";
        setState(() {
          showkeyboard = false;
        });
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
}
