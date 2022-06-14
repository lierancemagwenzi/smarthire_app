import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/pages/orders/showProduct.dart';
import 'package:smarthire/pages/orders/showuser.dart';
import 'package:smarthire/pages/providers/ShowLocation.dart';
import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart' as globals;

import '../../constants/colors.dart';
import '../../model/OrderModel.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';

class PayCallOutFee extends StatefulWidget {
  int id;
  PayCallOutFee({@required this.id});

  @override
  _PayCallOutFeeState createState() => _PayCallOutFeeState();
}

class _PayCallOutFeeState extends State<PayCallOutFee> {
  double height;
  double width;
  OrderModel orderModel;
  bool loading = false;

  void handleClick(String value) {
    switch (value) {
      case 'See Order':
        Navigator.push(
            context,
            SlideRightRoute(
                page: SingleOrderScreen(
              orderModel: orderModel,
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
              "Proceed",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            textColor: Colors.white,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              SpacePanel();
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text("Pay CallOut Fee"),
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
      body: orderModel == null || loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Date",
                        style: TextStyle(
                            color: smarthireBlue, fontFamily: "open-sans"),
                      ),
                      subtitle: Text(orderModel.date,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
//                      onTap: () {
//                        Navigator.push(
//                            context,
//                            SizeRoute(
//                              page: ShowUserScreen(),
//                            ));
//                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireBlue,
                        size: 30.0,
                      ),
                      title: Text("Customer",
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(orderModel.customer_name,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            SizeRoute(
                              page: ShowProductScreen(
                                id: orderModel.product_id,
                              ),
                            ));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireBlue,
                        size: 30.0,
                      ),
                      title: Text("Product",
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(orderModel.product_name,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
                      title: Text("Status",
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(orderModel.order_status,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    CheckboxListTile(
                      title: Text("Delivery?",
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      value: orderModel.delivery == 1 ? true : false,
                      onChanged: (newValue) {
                        setState(() {
//                      checkedValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .trailing, //  <-- leading Checkbox
                    ),
                    ListTile(
                      onTap: () {
                        if (orderModel.coord != null &&
                            orderModel.coord.length > 2) {
                          Navigator.push(
                              context,
                              SizeRoute(
                                  page: GoogleMapsDemo(
                                lat: double.parse(
                                    orderModel.coord.split("#")[0]),
                                lang: double.parse(
                                  orderModel.coord.split("#")[1],
                                ),
                              )));
                        }
                      },
                      trailing: orderModel.customer_location == null ||
                              orderModel.customer_location.length < 2
                          ? null
                          : Icon(
                              Icons.arrow_forward_ios,
                              color: smarthireBlue,
                              size: 30.0,
                            ),
                      title: Text("Your Location",
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(
                          orderModel.customer_location == null ||
                                  orderModel.customer_location.length < 2
                              ? "No location"
                              : orderModel.customer_location,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
                      title: Text("Call Out Charge Charge",
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text("RWF" + orderModel.calloutfee,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  SpacePanel() {
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
                  () => http.post(globals.url + '/api/paycallout',
                      body: jsonEncode({
                        "order_status": "callout_fee_paid",
                        "target_id": orderModel.provider_id,
                        "order_number": orderModel.id,
                        "amount": orderModel.calloutfee,
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
                              "Paid Successfully",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ))),
                        background: smarthireBlue);
                  });
                } else if (response.statusCode == 203) {
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
                  Navigator.pop(context);
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
                print('kkkkk Socket Error: $e');
              } on Error catch (e) {
                Future.delayed(const Duration(milliseconds: 3000), () {
                  setModalState(() {
                    result = true;
                    success = false;
                    apiresult = "Developer error";
                  });
                });
                showSimpleNotification(
                    Container(
                        height: height * 0.1,
                        child: Center(
                            child: Text(
                          "An error Occured.Try again",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ))),
                    background: Colors.redAccent);

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
                                  "Making Payment",
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
                                          orderModel.calloutfee)),
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
    getOrder();
    super.initState();
  }

  getOrder() async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/single/" + widget.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      OrderModel orderModel =
          OrderModel.fromCustomer(json.decode(response.body));
      print(orderModel.customer_location);
      setState(() {
        this.orderModel = orderModel;
      });
    } else {}

    setState(() {
      loading = false;
    });
  }
}
