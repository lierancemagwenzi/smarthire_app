import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/OrderModel.dart';

import 'package:smarthire/constants/Transition.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';

import '../../constants/colors.dart';
import '../../model/OrderModel.dart';

class SetOutForDelivery extends StatefulWidget {
  OrderModel orderModel;

  SetOutForDelivery({@required this.orderModel});

  @override
  _SetOutForDeliveryState createState() => _SetOutForDeliveryState();
}

class _SetOutForDeliveryState extends State<SetOutForDelivery> {
  double height;
  double width;
  bool loading = false;

  String message;
  List<String> messages = [
    "OUT FOR DELIVERY",
    "arrived".toUpperCase(),
    "DELAYED".toUpperCase(),
  ];

  Widget serviceFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  prefixIcon: Icon(Icons.message, color: smarthireBlue)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    "message",
                    style: TextStyle(
                        fontFamily: "sans",
                        color: smarthireBlue,
                        fontWeight: FontWeight.w700),
                  ),
                  value: message,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      message = newValue;
                    });
                    print(message);
                  },
                  items: messages.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "sans",
                            color: smarthireBlue,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'See Order':
        Navigator.push(
            context,
            SlideRightRoute(
                page: SingleOrderScreen(
              orderModel: widget.orderModel,
            )));
        break;
        break;
      case 'Add Custom Product':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: 130.0,
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
              "Send Notification",
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
            onPressed: () {
              sendmessage();
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          "Send Notification",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: handleClick,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30.0,
              ),
              itemBuilder: (BuildContext context) {
                return {
                  'See Order',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(color: smarthireBlue),
                    ),
                  );
                }).toList();
              },
            ),
          )
        ],
      ),
      body: Center(child: serviceFieldWidget()),
    );
  }

  Future<void> sendmessage() async {
    setState(() {
      loading = true;
    });
    print("sending order");

    final newString = message.replaceAll(" ", "_");

    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/updateorder',
            body: jsonEncode({
              "order_status": newString.toLowerCase(),
              "target_id": widget.orderModel.customer_id,
              "order_number": widget.orderModel.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        Navigator.pop(context);
        setState(() {});

        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Sent!",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: smarthireBlue);
        print("failed");
      } else if (response.statusCode == 203) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          showSimpleNotification(
            AutoSizeText(
              "Your request failed::" + json.decode(response.body),
              maxLines: 1,
            ),
            trailing: Builder(builder: (context) {
              return FlatButton(
                  textColor: Colors.yellow,
                  onPressed: () {
                    if (OverlaySupportEntry.of(context) != null) {
                      OverlaySupportEntry.of(context).dismiss();
                    }
                  },
                  child: Text('Dismiss'));
            }),
            background: smarthireBlue,
            autoDismiss: false,
            slideDismiss: true,
          );
        });
      } else {
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "An error Occured.Try again",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: Colors.redAccent);
        print("failed");
        print("failed");
        if (response.statusCode == 401) {}
      }

      setState(() {
        loading = false;
      });
    } on TimeoutException catch (e) {
      showSimpleNotification(
          Container(
              height: height * 0.1,
              child: Center(
                  child: Text(
                "An error Occured.Try again",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ))),
          background: Colors.redAccent);
      print("failed");
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      showSimpleNotification(
          Container(
              height: height * 0.1,
              child: Center(
                  child: Text(
                "An error Occured.Try again",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ))),
          background: Colors.redAccent);
      print("failed");
      setState(() {
        loading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      showSimpleNotification(
          Container(
              height: height * 0.1,
              child: Center(
                  child: Text(
                "An error Occured.Try again",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ))),
          background: Colors.redAccent);
      print("failed");
      setState(() {
        loading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }
}
