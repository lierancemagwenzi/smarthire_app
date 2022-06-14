import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart' as globals;

bool agree = false;

class ProductCheckOutWidget extends StatefulWidget {
  int quantity;
  ProviderModel providerModel;

  ProductCheckOutWidget({@required this.providerModel, this.quantity});
  @override
  _ProductCheckOutWidgetState createState() => _ProductCheckOutWidgetState();
}

class _ProductCheckOutWidgetState extends State<ProductCheckOutWidget> {
  PickResult selectedPlace;
  String error = "";
  double height;
  double width;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  @override
  void initState() {
    agree = false;
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(

      child: Scaffold(
          backgroundColor: globals.darkmode?Colors.black:Colors.white,
          key: _scaffoldKey,
          body: loading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Text(
                          "Check Out",
                          style: TextStyle(
                              color: smarthireDark,
                              fontFamily: "mainfont",
                              fontSize: 24.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        color: globals.darkmode?Colors.black:Color(0xfffafafa),
                        child: ListTile(
                          title: Text(
                            "Quantity",
                            style: TextStyle(
                                color: smarthireDark,
                                fontFamily: "mainfont",
                                fontSize: 20.0),
                          ),
                          subtitle: Text(
                            widget.quantity.toString() +
                                " x " +
                                "(" +
                                widget.providerModel.quantity +
                                " " +
                                widget.providerModel.unit +
                                ")",
                            style: TextStyle(
                                color: smarthireDark,
                                fontFamily: "mainfont",
                                fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        color:globals.darkmode?Colors.black: Color(0xfffafafa),
                        child: ListTile(
                          title: Text(
                            "Price",
                            style: TextStyle(
                                color: smarthireDark,
                                fontFamily: "mainfont",
                                fontSize: 20.0),
                          ),
                          subtitle: Text(
                            "RWF" + widget.providerModel.price,
                            style: TextStyle(
                                color: smarthireDark,
                                fontFamily: "mainfont",
                                fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      AddressWidget(),
                      SizedBox(
                        height: 7.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: width,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                              Validate();
                            },
                            color: smarthireBlue,
                            textColor: Colors.white,
                            child: Text("Place Order".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: "mainfont")),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                )),
    );
  }

  AddressWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: Color(0xff005f8e)),
          child: CheckboxListTile(
            title: AutoSizeText(
              "Delivery?".toUpperCase(),
              maxLines: 1,
              style: TextStyle(color: smarthireBlue),
            ),
            value: agree,
            checkColor: Color(0xff0B1A2D),
            activeColor: Colors.white,
            onChanged: (bool val) {
              setState(() {
                agree = val;
              });
              if (agree) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PlacePicker(
                        apiKey: "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
                        initialPosition: LocationPicker.kInitialPosition,
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
              } else {}
            },
          ),
        ),
        selectedPlace != null && agree
            ? ListTile(
                onTap: () {
                  print(selectedPlace.formattedAddress);
                },
                subtitle: selectedPlace != null && agree
                    ? Text(selectedPlace.formattedAddress ?? "")
                    : Container(
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                title: Text(
                  "Delivery Adrress".toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: smarthireBlue,
                      fontSize: 18.0),
                ),
              )
            : Text(""),
        Container(
          height: height * 0.03,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: Colors.grey.withOpacity(0.3),

              width: 2.0,
            ),
          )),
        ),
      ],
    );
  }

  Validate() {
    print("validate");
    setState(() {
      error = "";
    });
    if (widget.providerModel.product_type == "product") {
      if (selectedPlace == null && agree == false) {
        SendOrder();
      } else if (selectedPlace != null && agree) {
        SendOrder();
      } else {
        if (agree) {
          setState(() {
            error = "Please select an address";
          });

          print("please select ");
        } else {}
      }
    } else {
      if (selectedPlace != null) {
        print("good service adreess");
        SendOrder();
      } else {
        setState(() {
          error = "Please select an address";
        });

        print("null adreess");
      }
    }
  }

  String getAddress() {
    if (widget.providerModel.product_type == "product") {
      if (selectedPlace == null && agree == false) {
        return "";
      } else {
        return selectedPlace.formattedAddress;
      }
    } else {
      return selectedPlace.formattedAddress;
    }
  }

  getCoord() {
    if (widget.providerModel.product_type == "product") {
      if (selectedPlace == null && agree == false) {
        return [0, 0];
      } else {
        return selectedPlace.geometry.location.lat.toString() +
            "#" +
            selectedPlace.geometry.location.lng.toString();
      }
    } else {
      return selectedPlace.geometry.location.lat.toString() +
          "#" +
          selectedPlace.geometry.location.lng.toString();
    }
  }

  Future<void> SendOrder() async {
    setState(() {
      loading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/saveorder',
            body: jsonEncode({
              "customer_id": globals.id,
              "target_id": widget.providerModel.provider_id,
              "delivery": agree ? 1 : 0,
              "quantity": widget.quantity.toString(),
              "product_id": widget.providerModel.service_id,
              "customer_address": getAddress(),
              "coord": getCoord(),
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        OrderModel orderModel =
            OrderModel.fromCustomer(jsonDecode(response.body));
        globals.myorders.add(orderModel);
        showInSnackBar("Order placed successfully");
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            loading = false;
          });

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SingleOrderScreen(orderModel: orderModel)));
        });

        print("inserted");

        setState(() {});
      } else {
        showInSnackBar("An error Occured.Try again");

        setState(() {
          loading = false;
        });
        print("failed");
        if (response.statusCode == 401) {}
      }
    } on TimeoutException catch (e) {
      showInSnackBar("An error Occured.Try again");
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      showInSnackBar("An error Occured.Try again");

      setState(() {
        loading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      showInSnackBar("An error Occured.Try again");

      print('kkkkkk General Error: $e');
    }
  }
}
