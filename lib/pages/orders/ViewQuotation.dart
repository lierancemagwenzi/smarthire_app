import 'package:flutter/material.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/model/OrderModel.dart';
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
import 'package:smarthire/model/Quotation.dart' as q;
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/PriceComparisonScreen.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';

class Quotation extends StatefulWidget {
  OrderModel orderModel;
  Quotation({@required this.orderModel});
  @override
  _QuotationState createState() => _QuotationState();
}

class _QuotationState extends State<Quotation> {
  double height;
  double width;
  var total = 0.0;
  bool loading = false;
  List<q.Quotation> items = [];

  static num tryParse(String input) {
    String source = input.trim();
    return int.tryParse(source) ?? double.tryParse(source);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    total = items.length < 1
        ? 0.0
        : items.map((expense) {
            var b = tryParse(expense.quantity) != null
                ? tryParse(expense.quantity)
                : 0;
            var a =
                tryParse(expense.price) != null ? tryParse(expense.price) : 0;
            double usd = a.toDouble() * b.toDouble();
            return usd;
          }).fold(0, (prev, amount) => prev + amount);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: height * 0.1,
          child: Center(child: Text("Total Price:  RWF" + total.toString())),
        ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text("Services Quotation(RWF)"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Flexible(
                  child: new ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            child: ListTile(
                              subtitle: Column(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Price",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(items[index].price),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Unit",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(items[index].unit),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Quantity",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(items[index].quantity),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(items[index].description),
                                    ],
                                  )
                                ],
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    items[index].item.toUpperCase(),
                                    style: TextStyle(
                                        color: smarthireBlue, fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  PaymentPanel() {
    bool ploading = false;
    bool success = false;
    bool result = false;
    String apiresult = "";

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            Future<void> pay() async {
              setModalState(() {
                ploading = true;
              });
              print("sending order");
              try {
                final r = RetryOptions(maxAttempts: 1);
                final response = await r.retry(
                  // Make a GET request
                  () => http.post(global.url + '/api/payproduct',
                      body: jsonEncode({
                        "order_status": "payment_made",
                        "target_id": widget.orderModel.provider_id,
                        "order_number": widget.orderModel.id,
                        "amount": total.toStringAsFixed(2),
                      }),
                      headers: {
                        'Content-type': 'application/json'
                      }).timeout(Duration(seconds: 100)),
                  retryIf: (e) => e is SocketException || e is TimeoutException,
                );
                setModalState(() {});
                if (response.statusCode == 201) {
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    setModalState(() {
                      result = true;
                      success = true;
                      apiresult = "successfully paid";
                      showSimpleNotification(
                          Container(
                              height: height * 0.1,
                              child: Center(
                                  child: Text(
                                "Paid Successfully",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ))),
                          background: smarthireBlue);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });
                } else if (response.statusCode == 203) {
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    setModalState(() {
                      result = true;
                      success = false;
                      apiresult = "Faild to pay.Try again";
                    });
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
                  });
                } else {
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    setModalState(() {
                      result = true;
                      success = false;
                      apiresult = "Faild to pay.Try again";
                      showSimpleNotification(
                          Container(
                              height: height * 0.1,
                              child: Center(
                                  child: Text(
                                "An error Occured.Try again",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ))),
                          background: Colors.redAccent);
                    });
                  });
                  print("failed");
                  if (response.statusCode == 401) {
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setModalState(() {
                        result = true;

                        success = false;
                        apiresult = "Faild to pay.Try again";
                        showSimpleNotification(
                            Container(
                                height: height * 0.1,
                                child: Center(
                                    child: Text(
                                  "An error Occured.Try again",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ))),
                            background: Colors.redAccent);
                      });
                    });
                  }
                }
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
                Future.delayed(const Duration(milliseconds: 3000), () {
                  setModalState(() {
                    result = true;
                    success = false;
                    apiresult = "Network error";
                    showSimpleNotification(
                        Container(
                            height: height * 0.1,
                            child: Center(
                                child: Text(
                              "An error Occured.Try again",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ))),
                        background: Colors.redAccent);
                  });
                });
                print('kkkkk Socket Error: $e');
              } on Error catch (e) {
                Future.delayed(const Duration(milliseconds: 3000), () {
                  setModalState(() {
                    result = true;
                    success = false;
                    apiresult = "Developer error";
                  });
                  showSimpleNotification(
                      Container(
                          height: height * 0.1,
                          child: Center(
                              child: Text(
                            "An error Occured.Try again",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ))),
                      background: Colors.redAccent);
                });
                print('kkkkkk General Error: $e');
              }
            }

            return result
                ? Container(
                    color: Colors.white54,
                    height: height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          apiresult,
                          style: TextStyle(
                              color: smarthireBlue,
                              fontSize: 14.0,
                              fontFamily: "sans"),
                        ),
                        success
                            ? Icon(
                                Icons.done,
                                color: Colors.green,
                                size: 30.0,
                              )
                            : Icon(
                                Icons.close,
                                color: Colors.redAccent,
                                size: 30.0,
                              ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          color: smarthireBlue,
                          textColor: Colors.white,
                          child: Text("close".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.white54,
                    height: height * 0.2,
                    child: ploading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Center(
                                child: Text(
                                  "Simulating Payment",
                                  style: TextStyle(
                                      color: smarthireBlue,
                                      fontFamily: "sans",
                                      fontSize: 14.0),
                                ),
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ListTile(
//                                  leading: Icon(Icons.attach_money,
//                                      color: smarthireBlue),
                                  title: Center(
                                    child: Text("Paying RWF" +
                                        total.toStringAsFixed(2)),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    child: Text("NO".toUpperCase(),
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    onPressed: () async {
                                      setModalState(() {
                                        pay();
                                      });
                                    },
                                    color: smarthireBlue,
                                    textColor: Colors.white,
                                    child: Text("YES".toUpperCase(),
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                ],
                              )
                            ],
                          ));
          });
        });
  }

  @override
  void initState() {
    getQuotation();
    super.initState();
  }

  getQuotation() async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/getquotation/" + widget.orderModel.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print("orders" + list.length.toString());
      for (int i = 0; i < list.length; i++) {
        q.Quotation quotation = q.Quotation.fromJson(list[i]);
        setState(() {
          items.add(quotation);
        });
      }
      setState(() {});
    } else {}

    setState(() {
      loading = false;
    });
  }
}
