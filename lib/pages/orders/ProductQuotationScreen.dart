import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
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

class ProductQuotationScreen extends StatefulWidget {
  OrderModel orderModel;

  ProductQuotationScreen({@required this.orderModel});
  @override
  _ProductQuotationScreenState createState() => _ProductQuotationScreenState();
}

class _ProductQuotationScreenState extends State<ProductQuotationScreen> {
  ProviderModel providerModel;
  double height;
  double width;
  bool loading = false;

  static num tryParse(String input) {
    String source = input.trim();
    return int.tryParse(source) ?? double.tryParse(source);
  }

  double getQuanity() {
    var a = tryParse(widget.orderModel.quantity) != null
        ? tryParse(widget.orderModel.quantity)
        : 0;
    return a.toDouble();
  }

  double getPrice() {
    var a = tryParse(widget.orderModel.calloutfee) != null
        ? tryParse(widget.orderModel.calloutfee)
        : 0;
    var b = tryParse(providerModel.price) != null
        ? tryParse(providerModel.price)
        : 0;

    return a.toDouble() + (b.toDouble() * getQuanity());
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
      bottomNavigationBar: providerModel == null
          ? null
          : BottomAppBar(
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
                    "Pay",
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
                    PaymentPanel();
                  },
                ),
              ),
            ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          "Quotation",
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
      body: loading || providerModel == null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                ListTile(
                    subtitle: Text(
                      widget.orderModel.delivery_date,
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    ),
                    title: Text(
                      "Delivery Date".toUpperCase(),
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    )),
                ListTile(
                    trailing: Text(
                      widget.orderModel.calloutfee,
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    ),
                    title: Text(
                      "Delivery Fee".toUpperCase(),
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    )),
                widget.orderModel.product_type == "product"
                    ? ListTile(
                        title: Text(
                          "Ordered Quantity".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans"),
                        ),
                        subtitle: Text(
                            widget.orderModel.quantity +
                                " X " +
                                widget.orderModel.product_unit,
                            style: TextStyle(
                                color: smarthireBlue, fontFamily: "open-sans")),
                      )
                    : Container(),
                ListTile(
                    trailing: Text(
                      providerModel.price,
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    ),
                    title: Text(
                      "Product Price".toUpperCase(),
                      style:
                          TextStyle(color: smarthireBlue, fontFamily: "sans"),
                    )),
                ListTile(
                    trailing: Text(
                      getPrice().toStringAsFixed(2),
                      style: TextStyle(
                          color: smarthireBlue,
                          fontFamily: "sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    title: Text(
                      "Total Price".toUpperCase(),
                      style: TextStyle(
                          color: smarthireBlue,
                          fontFamily: "sans",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
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
                  () => http.post(globals.url + '/api/payproduct',
                      body: jsonEncode({
                        "order_status": "payment_made",
                        "target_id": widget.orderModel.provider_id,
                        "order_number": widget.orderModel.id,
                        "amount": getPrice().toStringAsFixed(2),
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
                    });

                    showSimpleNotification(
                        Container(
                            height: height * 0.1,
                            child: Center(
                                child: Text(
                              "Payment Successful",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ))),
                        background: smarthireBlue);
                  });
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
                    setModalState(() {
                      result = true;
                      success = true;
                      apiresult =
                          "Your request failed::" + json.decode(response.body);
                    });
                  });
                } else {
                  Future.delayed(const Duration(milliseconds: 3000), () {
                    setModalState(() {
                      result = true;
                      success = false;
                      apiresult = "Faild to pay.Try again";
                    });
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
                  print("failed");
                  if (response.statusCode == 401) {
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setModalState(() {
                        result = true;

                        success = false;
                        apiresult = "Faild to pay.Try again";
                      });
                    });
                  }
                }
              } on TimeoutException catch (e) {
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
                                    child: Text("Paying  RWF" +
                                        getPrice().toStringAsFixed(2)),
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
    if (widget.orderModel.calloutfee == null) {
      widget.orderModel.calloutfee = "0";
    }
    getProduct();
    super.initState();
  }

  getProduct() async {
    setState(() {
      loading = true;
    });
    var path = "/api/product/" + widget.orderModel.product_id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      ProviderModel providerModel =
          ProviderModel.fromJson(json.decode(response.body));
      providerModel.profile_pic =
          globals.fileserver + providerModel.profile_pic;
      setState(() {
        this.providerModel = providerModel;
      });
    } else {}

    setState(() {
      loading = false;
    });
  }
}
