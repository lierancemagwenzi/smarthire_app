import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/Quotation.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
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

class AddPrices extends StatefulWidget {
  OrderModel orderModel;
  List<String> elements;
  AddPrices({@required this.orderModel, this.elements});

  @override
  _AddPricesState createState() => _AddPricesState();
}

class _AddPricesState extends State<AddPrices> {
  double height;
  double width;

  bool loading = false;

  TextEditingController textEditingController = TextEditingController();
  List<Quotation> quotations = [];

  @override
  void initState() {
    for (int i = 0; i < widget.elements.length; i++) {
      quotations.add(new Quotation(
          item: widget.elements[i],
          price: "0",
          quantity: "1",
          description: "No description",
          unit: "KG"));
    }
    super.initState();
  }

  _showDialog(int index) async {
    String error = "";
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.redAccent, fontSize: 13.0),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: textEditingController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: quotations[index].item,
                        hintText: 'Type a price'),
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  error = "";
                });
                if (textEditingController.text != null &&
                    textEditingController.text.length > 0 &&
                    num.tryParse(textEditingController.text) != null) {
                  setState(() {
                    quotations[index].price = textEditingController.text;
                  });
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }

  _showQuanityDialog(int index) async {
    String error = "";
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.redAccent, fontSize: 13.0),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: textEditingController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: quotations[index].item,
                        hintText: 'Type a quanity'),
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  error = "";
                });
                if (textEditingController.text != null &&
                    textEditingController.text.length > 0 &&
                    num.tryParse(textEditingController.text) != null) {
                  setState(() {
                    quotations[index].quantity = textEditingController.text;
                  });
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }

  _showDescriptionDialog(int index) async {
    String error = "";
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.redAccent, fontSize: 13.0),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: textEditingController,
                    minLines: 3,
                    maxLines: 10,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: quotations[index].item,
                        hintText: 'Type a quanity'),
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  error = "";
                });
                if (textEditingController.text != null &&
                    textEditingController.text.length > 0) {
                  setState(() {
                    quotations[index].description = textEditingController.text;
                  });
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }

  _showunitDialog(int index) async {
    String error = "";
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.redAccent, fontSize: 13.0),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: textEditingController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: quotations[index].item,
                        hintText: 'Type a unit eg KG'),
                  ),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  error = "";
                });
                if (textEditingController.text != null &&
                    textEditingController.text.length > 0) {
                  setState(() {
                    quotations[index].unit = textEditingController.text;
                  });
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
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
              SendQuotation();
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text("Create Quotation"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: new ListView.builder(
                    itemCount: quotations.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          child: ListTile(
                            subtitle: Column(
                              children: <Widget>[
                                quotations[index].price != null
                                    ? Column(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showDialog(index);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: smarthireBlue,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(quotations[index].price),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          textEditingController.text = "";
                                          _showDialog(index);
                                        },
                                        child: Icon(
                                          Icons.add_circle,
                                          color: smarthireBlue,
                                          size: 30.0,
                                        ),
                                      ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                quotations[index].unit != null
                                    ? Column(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showunitDialog(index);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: smarthireBlue,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(quotations[index].unit),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          textEditingController.text = "";
                                          _showDialog(index);
                                        },
                                        child: Icon(
                                          Icons.add_circle,
                                          color: smarthireBlue,
                                          size: 30.0,
                                        ),
                                      ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                quotations[index].quantity != null
                                    ? Column(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showQuanityDialog(index);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: smarthireBlue,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(quotations[index].quantity),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          textEditingController.text = "";
                                          _showQuanityDialog(index);
                                        },
                                        child: Icon(
                                          Icons.add_circle,
                                          color: smarthireBlue,
                                          size: 30.0,
                                        ),
                                      ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                quotations[index].description != null
                                    ? Column(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showDescriptionDialog(index);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: smarthireBlue,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(quotations[index].description),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          textEditingController.text = "";
                                          _showDescriptionDialog(index);
                                        },
                                        child: Icon(
                                          Icons.add_circle,
                                          color: smarthireBlue,
                                          size: 30.0,
                                        ),
                                      ),
                              ],
                            ),
                            title: Text(
                              quotations[index].item.toUpperCase(),
                              style: TextStyle(
                                  color: smarthireBlue, fontSize: 18.0),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          loading ? Center(child: CircularProgressIndicator()) : Text("")
        ],
      ),
    );
  }

  Future<void> SendQuotation() async {
    List items = [];

    for (int i = 0; i < quotations.length; i++) {
      items.add(quotations[i].toMap());
    }
    setState(() {
      loading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/savequotation',
            body: jsonEncode({
              "order_status": "quotation_sent",
              "items": items,
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
        Navigator.pop(context);
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Quotation Sent!",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: smarthireBlue);
        setState(() {});
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
