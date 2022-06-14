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
import 'package:overlay_support/overlay_support.dart';
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

class CallOutFeeeScreen extends StatefulWidget {
  OrderModel orderModel;
  CallOutFeeeScreen({@required this.orderModel});

  @override
  _CallOutFeeeScreenState createState() => _CallOutFeeeScreenState();
}

class _CallOutFeeeScreenState extends State<CallOutFeeeScreen> {
  double height;
  double width;
  String _nameerror = "";
  String dateerror = "";
  String thedate;
  TextEditingController datecontroller = TextEditingController();
  bool loading = false;
  TextEditingController controller = TextEditingController();

  Vlidate() {
    setState(() {
      _nameerror = "";
      dateerror = "";
    });
    var v = controller.text;
    final n = num.tryParse(controller.text);

    if (controller.text.length > 0 && thedate != null) {
      if (n == null) {
        setState(() {
          _nameerror = "Enter a valid amount";
        });
      } else {
        setState(() {
          Charge();
        });
      }
    } else {
      if (thedate == null) {
        setState(() {
          dateerror = "Pick a date";
        });
      }

      if (controller.text == null || controller.text.length < 1) {
        setState(() {
          _nameerror = "enter amount";
        });
      }
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
              "Proceed",
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
              Vlidate();
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text("Call out Fee"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: height * .02, horizontal: width * .23),
                child: Text(
                  _nameerror,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
//                      prefixIcon: AutoSizeText(
//                        "RWF",
//                        maxLines: 1,
//                      ),
                      hintStyle: new TextStyle(
                          color: smarthireBlue,
                          fontFamily: 'sans',
                          fontSize: 14.0),
                      hintText: "Amount(RWF)",
                      fillColor: smarthireWhite),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: height * .02, horizontal: width * .23),
                child: Text(
                  dateerror,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onTap: () {
                    DatePicker.showDatePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onCancel: () {
                      setState(() {
                        thedate = thedate;
                      });
                    }, onConfirm: (date) {
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      final String formatted = formatter.format(date);
                      setState(() {
                        thedate = formatted;
                        datecontroller.text = formatted;
                      });
                      print('confirm $date');
                    }, currentTime: DateTime.now());
                  },
                  controller: datecontroller,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: smarthireBlue,
                      ),
                      hintStyle: new TextStyle(
                          color: smarthireBlue,
                          fontFamily: 'sans',
                          fontSize: 14.0),
                      hintText: "Delivery Date",
                      fillColor: smarthireWhite),
                ),
              )
            ],
          ),
          loading ? Center(child: CircularProgressIndicator()) : Text("")
        ],
      ),
    );
  }

  Future<void> Charge() async {
    setState(() {
      loading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/chargecallout',
            body: jsonEncode({
              "order_status": "charge_callout_fee",
              "amount": controller.text,
              "delivery_date": thedate,
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
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Sent!",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: smarthireBlue);
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
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
//                  Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
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
      setState(() {
        loading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }
}
