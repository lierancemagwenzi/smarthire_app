import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:smarthire/icons/map.dart' as pin;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/PlaceOrder.dart';
import 'package:smarthire/pages/orders/neworder.dart';
import 'package:smarthire/pages/providers/ShowLocation.dart';

class EditProductScreen extends StatefulWidget {
  int index;
  ProviderModel providerModel;

  EditProductScreen({@required this.providerModel, this.index});
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ScrollController scrollController;

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();
  double height;
  double width;
  bool available = false;

  bool loading = false;
  List<ReviewModel> reviews = [];
  PickResult selectedPlace;

  String _nameerror = '';
  String _priceerror = '';
  String _categoryerror = '';
  String _typeerror = '';
  String locationerror = '';
  String _imageerror = '';
  String _descriptionerror = '';
  final key = new GlobalKey<ScaffoldState>();
  bool showkeyboard = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  TextEditingController _controller = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Validate() {
    setState(() {
      _nameerror = '';
      _priceerror = '';
      _descriptionerror = '';
    });
    if (nameController.text.length > 0 &&
        priceController.text.length > 0 &&
        descriptionController.text.length > 0) {
      SaveChanges();
    } else {
      setState(() {
        String error = "";
        if (nameController.text.length < 1) {
          _nameerror += "Product name cannot be empty.";
        }

        if (descriptionController.text.length < 1) {
          _descriptionerror += "Product description cannot be empty.";
        }

        if (priceController.text.length < 1) {
          _priceerror += "Product price cannot be empty.";
        }
      });
    }
  }

  Future<void> SaveChanges() async {
    setState(() {
      loading = true;
    });
    print("sending order");

    try {
      final r = RetryOptions(maxAttempts: 2);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/updateproduct',
            body: jsonEncode({
              "price": priceController.text,
              "name": nameController.text,
              "availability": available,
              "coord": selectedPlace != null
                  ? selectedPlace.geometry.location.lat.toString() +
                      "#" +
                      selectedPlace.geometry.location.lng.toString()
                  : widget.providerModel.coord,
              "location": selectedPlace == null
                  ? widget.providerModel.location
                  : selectedPlace.formattedAddress,
              "id": widget.providerModel.service_id,
              "description": descriptionController.text
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 3)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            widget.providerModel.service_name = nameController.text;
            widget.providerModel.availability = available ? 1 : 0;
            widget.providerModel.description = descriptionController.text;
            widget.providerModel.price = priceController.text;
            widget.providerModel.location = selectedPlace == null
                ? widget.providerModel.location
                : selectedPlace.formattedAddress;

            widget.providerModel.coord = selectedPlace != null
                ? selectedPlace.geometry.location.lat.toString() +
                    "#" +
                    selectedPlace.geometry.location.lng.toString()
                : widget.providerModel.coord;
          });
          setState(() {
            loading = false;
          });
          showInSnackBar("Changes Saved");
//          Navigator.pop(context);
        });

        print("failed");
      } else {
        setState(() {
          loading = false;
        });
        showInSnackBar("An error occurred");
        print("failed");

        if (response.statusCode == 401) {}
      }
    } on TimeoutException catch (e) {
      showInSnackBar("An error occurred");
      setState(() {
        loading = false;
      });
      print("failed");
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      showInSnackBar("An error occurred");
      print("failed");
      setState(() {
        loading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      showInSnackBar("An error occurred");
      print("failed");
      setState(() {
        loading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }

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
          backgroundColor: smarthireWhite,
          key: _scaffoldKey,
          appBar: CustomAppBar(
            height: height * 0.15,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 2.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            return Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: smarthireDark,
                            size: 30.0,
                          ),
                        ),
                        Text(
                          "Product",
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: smarthireBlue,
                              fontFamily: "mainfont",
                              height: 1.3,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                        ),

                        Text("")
//                        Padding(
//                          padding: const EdgeInsets.only(right: 8.0),
//                          child: InkWell(
//                            onTap: () {
//                              return key.currentState.openEndDrawer();
//                            },
//                            child: Icon(Icons.filter_list,
//                                size: 30.0, color: smarthireDark),
//                          ),
//                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
//                child: Icon(Icons.cancel,color: smarthireDark,size: 30.0,))
//          ],
//        ),
//      ):

                1 == 2
                    ? Container(
                        width: 130.0,
                        height: 43.0,
                        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(30.0),
                            color: smarthireBlue),
                        child: FlatButton(
                          child: Text(
                            "Save Product",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'mainfont',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          textColor: Colors.white,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed:
                              widget.providerModel.provider_id != global.id ||
                                      loading
                                  ? null
                                  : () {
                                      Validate();
                                    },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: smarthireBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed:
                              widget.providerModel.provider_id != global.id
                                  ? null
                                  : () {
                                      Validate();
                                    },
                          child: Text(
                            "Save Product",
                            style: TextStyle(
                                fontFamily: "mainfont",
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
          ),
          body: loading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView(
                    //  crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      //    Container(
                      //      height: height*0.2,
                      //      child: AspectRatio(
                      //        aspectRatio: 6/6,
                      //        child: CircleAvatar(
                      //          backgroundColor: smarthireDark,
                      //        ),
                      //      ),
                      //    ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: smarthireDark,
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
                                        fontFamily: "mainfont",
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
                        widget.providerModel.product_type + " name",
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 18.0,
                            fontFamily: "mainfont"),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: height * .005, horizontal: width * .23),
                        child: Text(
                          _nameerror,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
                            hintStyle: new TextStyle(
                                color: smarthireDark,
                                fontFamily: 'mainfont',
                                fontSize: 14.0),
                            hintText: "Description",
                            fillColor: smarthireWhite),
                      ),

                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: height * .005, horizontal: width * .23),
                        child: Text(
                          _priceerror,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),

                      Text(
                        "Price(RWF)",
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 18.0,
                            fontFamily: "mainfont"),
                      ),

                      TextField(
                        controller: priceController,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
                            hintStyle: new TextStyle(
                                color: smarthireDark,
                                fontFamily: 'mainfont',
                                fontSize: 14.0),
                            hintText: "price",
                            fillColor: smarthireWhite),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SizeRoute(
                                            page: GoogleMapsDemo(
                                          lat: double.parse(widget
                                              .providerModel.coord
                                              .split("#")[0]),
                                          lang: double.parse(
                                            widget.providerModel.coord
                                                .split("#")[1],
                                          ),
                                        )));
                                  },
                                  child: Text(
                                    "Location",
                                    style: TextStyle(
                                        color: smarthireDark,
                                        fontSize: 18.0,
                                        fontFamily: "mainfont"),
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
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PlacePicker(
                                      apiKey:
                                          "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
                                      initialPosition:
                                          LocationPicker.kInitialPosition,
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      //usePlaceDetailSearch: true,
                                      onPlacePicked: (result) {
                                        selectedPlace = result;
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
                          )
                        ],
                      ),

                      Text(
                        selectedPlace != null
                            ? selectedPlace.formattedAddress
                            : widget.providerModel.location,
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 13.0,
                            fontFamily: "mainfont"),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        "About",
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 18.0,
                            fontFamily: "mainfont"),
                      ),

                      SizedBox(
                        height: height * 0.01,
                      ),
                      TextField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 5, //Normal textInputField will be displayed
                        maxLines: 10,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
                            hintStyle: new TextStyle(
                                color: smarthireDark,
                                fontFamily: 'mainfont',
                                fontSize: 14.0),
                            hintText: "Service / Product Description",
                            fillColor: smarthireWhite),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Available?".toUpperCase(),
                            style: TextStyle(
                              fontFamily: "mainfont",
                              color: smarthireDark,
                              fontSize: 18.0,
                            ),
                          ),
                          CupertinoSwitch(
                            value: available,
                            onChanged: (value) {
                              bool original = available;
                              setState(() {
                                available = value;
                              });
                            },
                          ),
                        ],
                      ),

                      Text(
                        "Gallery".toUpperCase(),
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 18.0,
                            fontFamily: "mainfont"),
                      ),

                      Gallery(widget.providerModel),
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
                        backgroundColor: smarthireDark,
                      )),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    nameController.text = widget.providerModel.service_name;
    descriptionController.text = widget.providerModel.description;
    priceController.text = widget.providerModel.price;
    available = widget.providerModel.availability == 1 ? true : false;
    super.initState();
  }
}
