import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/fdd.dart';
import 'package:smarthire/pages/registration/LoginScreen.dart';

import 'ProductCheckoutWidget.dart';
import 'ServiceOrderScreen.dart';

class ProductScreen extends StatefulWidget {
  int index;
  ProviderModel providerModel;

  ProductScreen({@required this.providerModel, this.index});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double height;
  double width;
  int quantity = 1;
  @override
  void initState() {
    widget.providerModel.description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: globals.darkmode?Colors.black:Colors.white,

      body: Stack(
        children: <Widget>[
          Container(
            child: ImageWidget(),
          ),
          SlidingUpPanel(
            minHeight: height * 0.7,
            maxHeight: height,
            backdropTapClosesPanel: true,
            backdropColor: Colors.blue,
            color: globals.darkmode?Colors.black:Colors.white,
            backdropEnabled: true,
            panel: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: 1 == 1
                    ? globals.darkmode?Colors.black:Color(0xfffafafa)
                    : Color(0xffdcdce3).withOpacity(0.7),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.providerModel.service_name,
                        style: TextStyle(
                            color: smarthireDark,
                            fontWeight: FontWeight.bold,
                            fontFamily: "mainfont",
                            fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.providerModel.provider_name,
                            style: TextStyle(
                                color: smarthireDark,
                                fontWeight: FontWeight.normal,
                                fontFamily: "mainfont",
                                fontSize: 18.0),
                          ),
                          widget.providerModel.product_type == "product"
                              ? Text(
                                  "RWF" + widget.providerModel.price,
                                  style: TextStyle(
                                      color: smarthireBlue,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "mainfont",
                                      fontSize: 24.0),
                                )
                              : Text("")
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(27))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              child: Text(
                                widget.providerModel.product_type.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "mainfont"),
                              ),
                            ),
                          ),
                          widget.providerModel.product_type == "product"
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff8c98a8),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(27))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    child: Text(
                                      widget.providerModel.quantity +
                                          widget.providerModel.unit
                                              .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "mainfont"),
                                    ),
                                  ),
                                )
                              : Text("")
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        widget.providerModel.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: smarthireDark,
                            fontFamily: "mainfont",
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Text(
                          "Features",
                          style: TextStyle(
                              color: smarthireDark,
                              fontWeight: FontWeight.bold,
                              fontFamily: "mainfont",
                              fontSize: 20.0),
                        ),
                        subtitle: Text(
                          "Seall All product features",
                          style: TextStyle(
                              color: smarthireDark.withOpacity(0.5),
                              fontFamily: "mainfont",
                              fontSize: 14.0),
                        ),
                        leading: Icon(
                          Icons.add_circle,
                          color: smarthireDark,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Text(
                          "Availability",
                          style: TextStyle(
                              color: smarthireDark,
                              fontWeight: FontWeight.bold,
                              fontFamily: "mainfont",
                              fontSize: 20.0),
                        ),
                        subtitle: Text(
                          widget.providerModel.availability == 1
                              ? "Available"
                              : "Not available",
                          style: TextStyle(
                              color: smarthireDark.withOpacity(0.5),
                              fontFamily: "mainfont",
                              fontSize: 14.0),
                        ),
                        leading: Icon(
                          Icons.store,
                          color: smarthireDark,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Text(
                          "Location",
                          style: TextStyle(
                              color: smarthireDark,
                              fontWeight: FontWeight.bold,
                              fontFamily: "mainfont",
                              fontSize: 20.0),
                        ),
                        subtitle: Text(
                          widget.providerModel.location,
                          style: TextStyle(
                              color: smarthireDark.withOpacity(0.5),
                              fontFamily: "mainfont",
                              fontSize: 14.0),
                        ),
                        leading: Icon(
                          Icons.location_on,
                          color: smarthireDark,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Material(
              elevation: 20,
              child: Container(

                decoration: BoxDecoration(

                  boxShadow: globals.darkmode?null:[
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    )
                  ],
                  borderRadius:globals.darkmode?null: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),
                  color: globals.darkmode?Colors.black:Colors.white,
                ),
                height: widget.providerModel.product_type != "product"
                    ? height * 0.14
                    : height * 0.2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    mainAxisAlignment:
                        widget.providerModel.product_type == "product"
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.end,
                    children: <Widget>[
                      widget.providerModel.product_type != "product"
                          ? Text("")
                          : Container(
                        color: globals.darkmode?Colors.black:Colors.white,

                        child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Quantity",
                                    style: TextStyle(
                                        fontFamily: "mainfont",
                                        fontSize: 22.0,
                                        color: smarthireDark),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          SubQuantity();
                                        },
                                        child: Container(
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.blueAccent),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                "-",
                                                style: TextStyle(
                                                    color: smarthireDark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 26.0,
                                                    fontFamily: "mainfont"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: TextStyle(
                                            fontFamily: "mainfont",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            quantity = quantity + 1;
                                          });
                                        },
                                        child: Container(
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueAccent),
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                "+",
                                                style: TextStyle(
                                                    color: smarthireDark,
                                                    fontSize: 26.0,
                                                    fontFamily: "mainfont"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                          ),
                      Container(
                        color: globals.darkmode?Colors.black:Colors.white,

                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: smarthirePurple,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: 40.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: Container(
//                        width: double.infinity,
                                height: 43.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: smarthirePurple
//                            gradient: LinearGradient(
//                              // Where the linear gradient begins and ends
//                              begin: Alignment.topRight,
//                              end: Alignment.bottomLeft,
//                              // Add one stop for each color. Stops should increase from 0 to 1
//                              stops: [0.1, 0.9],
//                              colors: [
//                                // Colors are easy thanks to Flutter's Colors class.
//                                Color(0xff1d83ab),
//                                Color(0xff0cbab8),
//                              ],
//                            ),
                                    ),
                                child: FlatButton(
                                  child: Text(
                                    globals.id == 0
                                        ? "Sign In to Order"
                                        : widget.providerModel.product_type ==
                                                "service"
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
                                  onPressed: globals.id == 0
                                      ? () {
                                          Navigator.push(
                                              context,
                                              SlideRightRoute(
                                                  page: LoginScreen()));
                                        }
                                      : globals.id ==
                                              widget.providerModel.provider_id
                                          ? null
                                          : () {
                                              if (widget.providerModel
                                                      .product_type ==
                                                  "product") {
                                                CheckOut();
                                              } else {
                                                ServiceCheckOut();

//                                              Navigator.push(
//                                                  context,
//                                                  SlideRightRoute(
//                                                      page: NewOrderScreen(
//                                                    providerModel:
//                                                        widget.providerModel,
//                                                    index: 0,
//                                                  )));
                                              }
                                            },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 20.0,
              left: 8.0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 40.0,
                ),
              ))
        ],
      ),
    );
  }

  ImageWidget() {
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

    return CarouselSlider.builder(
        options: CarouselOptions(
//            aspectRatio: 16/9,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          autoPlay: false,
          aspectRatio: 3 / 2,
          height: height * 0.3,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          // onPageChanged: callbackFunction,
          scrollDirection: Axis.horizontal,
        ),
        itemCount: images.length,
        itemBuilder: (BuildContext context, itemIndex) {
          return SafeArea(

            child: Container(
              height: height * 0.3,
              child: Container(
//                width: width,
//                height: height,
                decoration: BoxDecoration(
//                        borderRadius: new BorderRadius.all(
//                          Radius.circular(20.0),
//                        ),
                  image: DecorationImage(
                      image: NetworkImage(globals.fileserver + images[itemIndex]),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          );
        });
  }

  //add

  void SubQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity = quantity - 1;
      });
    }
  }

  CheckOut() {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 20.0,
      expand: false,
      enableDrag: true,
      isDismissible: true,
      bounce: true,
      backgroundColor: globals.darkmode?Colors.black:Colors.white,

      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
//          color: Colors.grey,
          height: height * 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ProductCheckOutWidget(
              providerModel: widget.providerModel,
              quantity: quantity,
            ),
          ),
        ),
      ),
    );
  }

  ServiceCheckOut() {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 20.0,
      expand: false,
      enableDrag: true,
      isDismissible: true,
      bounce: true,
      backgroundColor: globals.darkmode?Colors.black:Colors.white,

      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
//          color: Colors.grey,
          height: height * 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ServiceOrderScreen(
              providerModel: widget.providerModel,
            ),
          ),
        ),
      ),
    );
  }
}
