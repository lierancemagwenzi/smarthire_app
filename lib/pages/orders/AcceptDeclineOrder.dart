import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/components/ProgressIndicator.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/constants/globals.dart' as globals;

import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/MessageModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';

import 'package:smarthire/model/slider.dart';
import 'package:smarthire/pages/auth/account.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/jobs/JobsScreen.dart';
import 'package:smarthire/pages/marketplace/MarketPlace.dart';
import 'package:smarthire/pages/orders/CallOutFeeScreen.dart';
import 'package:smarthire/pages/orders/DeliveryFee.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'package:smarthire/pages/orders/VideoReview.dart';
import 'package:smarthire/pages/orders/showProduct.dart';
import 'package:smarthire/pages/orders/showuser.dart';
import 'package:smarthire/pages/providers/CategoryScreen.dart';
import 'package:smarthire/pages/providers/NewService.dart';
import 'package:smarthire/pages/providers/account/UserProductsScreen.dart';
import 'package:smarthire/pages/transactions/TransactionScreen.dart';
import 'package:http/http.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/colors.dart';
import '../../constants/colors.dart';
import '../../constants/colors.dart';
import '../../model/OrderModel.dart';
import '../../model/OrderModel.dart';
import '../../model/OrderModel.dart';
import '../providers/ShowLocation.dart';

class ActionOrderScreen extends StatefulWidget {
  int id;

  ActionOrderScreen({@required this.id});

  @override
  _ActionOrderScreenState createState() => _ActionOrderScreenState();
}

class _ActionOrderScreenState extends State<ActionOrderScreen> {
  bool loading = false;
  OrderModel orderModel;
  double height;
  double width;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool ploading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: width * 0.4,
              child: RaisedButton(
                color: smarthireBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  if (orderModel.product_type == "product") {
                    if (orderModel.delivery != 1) {
                      AcceptOrder();
                    } else {
                      Navigator.push(
                          context,
                          SizeRoute(
                            page: DeliveryFee(
                              orderModel: orderModel,
                            ),
                          ));
                    }
                  } else {
                    Navigator.push(
                        context,
                        SizeRoute(
                          page: CallOutFeeeScreen(
                            orderModel: orderModel,
                          ),
                        ));
                  }
                },
                child: Text(
                  "Accept",
                  style:
                      TextStyle(color: Colors.white, fontFamily: "open-sans"),
                ),
              ),
            ),
            Container(
              width: width * 0.4,
              child: RaisedButton(
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  DeclineOrder();
                },
                child: Text(
                  "Decline",
                  style:
                      TextStyle(color: Colors.white, fontFamily: "open-sans"),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfffafafa),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: smarthireDark,
            size: 30.0,
          ),
        ),
        title: Text(
          "New Order Details",
          style: TextStyle(
            color: smarthireBlue,
            fontFamily: "mainfont",
          ),
        ),
        bottom: loading
            ? MyLinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(smarthireBlue),
        )
            : null,
      ),
      body: orderModel == null
          ? Center(child: CircularProgressIndicator())
          : 1==1?OrderDetails():Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Date".toUpperCase(),
                        style: TextStyle(
                            color: smarthireBlue, fontFamily: "open-sans"),
                      ),
                      subtitle: Text(orderModel.date,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
                      title: Text(
                        "Order Number".toUpperCase(),
                        style: TextStyle(
                            color: smarthireBlue, fontFamily: "open-sans"),
                      ),
                      subtitle: Text(orderModel.order_number,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
                      onTap: () {
//                        Navigator.push(
//                            context,
//                            SizeRoute(
//                              page: UserProductsScreen(
//                                  providerModel: new ProviderModel(
//                                      provider_id: orderModel.customer_id,
//                                      provider_name: orderModel.customer_name)),
//                            ));
                      },
//                      trailing: Icon(
//                        Icons.arrow_forward_ios,
//                        color: smarthireBlue,
//                        size: 30.0,
//                      ),
                      title: Text("Customer".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(orderModel.customer_name,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    orderModel.product_type == "product"
                        ? ListTile(
                            title: Text(
                              "Ordered Quantity".toUpperCase(),
                              style: TextStyle(
                                  color: smarthireBlue,
                                  fontFamily: "open-sans"),
                            ),
                            subtitle: Text(
                                orderModel.quantity +
                                    " X " +
                                    orderModel.product_unit,
                                style: TextStyle(
                                    color: smarthireBlue,
                                    fontFamily: "open-sans")),
                          )
                        : Container(),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            SlideRightRoute(
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
                      title: Text("Product".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(orderModel.product_name,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    ListTile(
                      title: Text("Status".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                      subtitle: Text(orderModel.order_status,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "open-sans")),
                    ),
                    CheckboxListTile(
                      title: Text("Delivery?".toUpperCase(),
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
                      title: Text("Customer Location".toUpperCase(),
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
                  ],
                ),
                ploading ? Center(child: CircularProgressIndicator()) : Text("")
              ],
            ),
    );
  }

  OrderDetails() {
    var dateTime =
    DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(orderModel.date, true);
    var dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);
    return  ploading?Center(child: CircularProgressIndicator()):Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Color(0xfffafafa),
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Order Id: #" + orderModel.order_number.toString(),
                  style: TextStyle(
                      color: smarthireBlue,
                      fontFamily: "mainfont",
                      fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            formattedDate,
            style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontFamily: "mainfont",
                fontSize: 16.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: width,
            color: Color(0xffbdc6c4).withOpacity(0.5),
            child: ListTile(
              leading: Image.asset(
                "assets/image.png",
              ),
              title: Text(
                orderModel.product_name,
                style: TextStyle(
                    color: smarthireDark,
                    fontFamily: "mainfont",
                    fontSize: 24.0),
              ),
              subtitle: Text(
                orderModel.customer_name,
                style: TextStyle(
                    color: Colors.grey, fontFamily: "mainfont", fontSize: 16.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        orderModel.product_type == "product"
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Ordered Quantity".toUpperCase(),
                style: TextStyle(
                    color: smarthireDark, fontFamily: "open-sans"),
              ),
              Text(orderModel.quantity + " X " + orderModel.product_unit,
                  style: TextStyle(
                      color: smarthireDark, fontFamily: "open-sans"))
            ],
          ),
        )
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Order Status".toUpperCase(),
                style: TextStyle(color: smarthireDark, fontFamily: "open-sans"),
              ),
              Text(orderModel.order_status,
                  style:
                  TextStyle(color: smarthireDark, fontFamily: "open-sans"))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Order Type".toUpperCase(),
                style: TextStyle(color: smarthireDark, fontFamily: "open-sans"),
              ),
              Text(orderModel.product_type,
                  style:
                  TextStyle(color: smarthireDark, fontFamily: "open-sans"))
            ],
          ),
        ),
        CheckboxListTile(
          checkColor: Colors.white,
          activeColor: smarthireDark,
          title: Text("Delivery?".toUpperCase(),
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
          value: orderModel.delivery == 1 ? true : false,
          onChanged: (newValue) {
            setState(() {
//                      checkedValue = newValue;
            });
          },
          controlAffinity:
          ListTileControlAffinity.trailing, //  <-- leading Checkbox
        ),
        ListTile(
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          SlideRightRoute(
//                            page: UserProductsScreen(
//                                providerModel: new ProviderModel(
//                                    provider_id:
//                                        orderModel.provider_id == globals.id
//                                            ? orderModel.customer_id
//                                            : orderModel.provider_id,
//                                    provider_name:
//                                        orderModel.provider_id == globals.id
//                                            ? orderModel.customer_name
//                                            : orderModel.provider_name)),
//                          ));
//                    },
//                    trailing: Icon(
//                      Icons.arrow_forward_ios,
//                      color: smarthireBlue,
//                      size: 30.0,
//                    ),
          title: Text(
              orderModel.provider_id == globals.id
                  ? "Customer"
                  : "Provider".toUpperCase(),
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
          subtitle: Text(
              orderModel.provider_id == globals.id
                  ? orderModel.customer_name
                  : orderModel.provider_name,
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
        ),
        orderModel.product_type == "service" && orderModel.review_video != null
            ? ListTile(
          onTap: () {
            Navigator.push(
                context,
                SlideRightRoute(
                  page: ReviewVideoPlayerScreen(
                    url: globals.fileserver + orderModel.review_video,
                  ),
                ));
          },
          title: Text(
            "Review Video".toUpperCase(),
            style:
            TextStyle(color: smarthireDark, fontFamily: "open-sans"),
          ),
          trailing: Icon(
            Icons.play_circle_outline,
            color: smarthireDark,
            size: 30.0,
          ),
        )
            : Container(),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                SlideRightRoute(
                  page: ShowProductScreen(
                    id: orderModel.product_id,
                  ),
                ));
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: smarthireDark,
            size: 30.0,
          ),
          title: Text("VIEW " + orderModel.product_type.toUpperCase(),
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
          subtitle: Text(orderModel.product_name,
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
        ),
        orderModel.delivery == 1 || orderModel.product_type == "service"
            ? ListTile(
          onTap: () {
            if (orderModel.coord != null && orderModel.coord.length > 2) {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: GoogleMapsDemo(
                        lat: double.parse(orderModel.coord.split("#")[0]),
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
            color: smarthireDark,
            size: 30.0,
          ),
          title: Text("Customer Location".toUpperCase(),
              style: TextStyle(
                  color: smarthireDark, fontFamily: "open-sans")),
          subtitle: Text(
              orderModel.customer_location == null ||
                  orderModel.customer_location.length < 2
                  ? "No location"
                  : orderModel.customer_location,
              style: TextStyle(
                  color: smarthireDark, fontFamily: "open-sans")),
        )
            : (ListTile(
          onTap: () {
            if (orderModel.product_coords != null &&
                orderModel.product_coords.length > 2) {
              Navigator.push(
                  context,
                  SlideRightRoute(
                      page: GoogleMapsDemo(
                        lat: double.parse(
                            orderModel.product_coords.split("#")[0]),
                        lang: double.parse(
                          orderModel.product_coords.split("#")[1],
                        ),
                      )));
            }
          },
          trailing: orderModel.customer_location == null ||
              orderModel.customer_location.length < 2
              ? null
              : Icon(
            Icons.arrow_forward_ios,
            color: smarthireDark,
            size: 30.0,
          ),
          title: Text("Provider Location".toUpperCase(),
              style: TextStyle(
                  color: smarthireDark, fontFamily: "open-sans")),
          subtitle: Text(
              orderModel.product_address == null ||
                  orderModel.product_address.length < 2
                  ? "No location"
                  : orderModel.product_address,
              style: TextStyle(
                  color: smarthireDark, fontFamily: "open-sans")),
        )),
      ],
    );
  }




  Future<void> AcceptOrder() async {
    setState(() {
      ploading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 2);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/acceptorder',
            body: jsonEncode({
              "order_status": "order-accepted",
              "target_id": orderModel.customer_id,
              "order_number": orderModel.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 3)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
  fetchOrder(new MessageModel(title: "Order Accepted",message: "Order Accepted Successfully",type: "success",alertType: CoolAlertType.success));

      } else if (response.statusCode == 203) {
setState(() {
  ploading=false;
});
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
            Navigator.pop(context);
          },
          type: CoolAlertType.error,
          text:"Your request failed because " + json.decode(response.body),

        );
        // showSimpleNotification(
        //   AutoSizeText(
        //     "Your request failed::" + json.decode(response.body),
        //     maxLines: 1,
        //   ),
        //   trailing: Builder(builder: (context) {
        //     return FlatButton(
        //         textColor: Colors.yellow,
        //         onPressed: () {
        //           if (OverlaySupportEntry.of(context) != null) {
        //             OverlaySupportEntry.of(context).dismiss();
        //           }
        //         },
        //         child: Text('Dismiss'));
        //   }),
        //   background: smarthireBlue,
        //   autoDismiss: false,
        //   slideDismiss: true,
        // );
      } else {
        setState(() {
          ploading=false;
        });
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
            Navigator.pop(context);
          },
          type: CoolAlertType.error,
          text:"An error occurred",

        );
        if (response.statusCode == 401) {}
      }

      setState(() {
        ploading = false;
      });
    } on TimeoutException catch (e) {
      setState(() {
        ploading=false;
      });
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occurred",

      );

      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      setState(() {
        ploading=false;
      });
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occurred",

      );

      setState(() {
        ploading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      setState(() {
        ploading=false;
      });
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occurred",

      );

      setState(() {
        ploading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }

  Future<void> DeclineOrder() async {
    setState(() {
      ploading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/decline',
            body: jsonEncode({
              "order_status": "order-declined",
              "target_id": orderModel.customer_id,
              "order_number": orderModel.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        fetchOrder(new MessageModel(title: "Order Declined Successfully",message: "Order cancelled Successfully",type: "success",alertType: CoolAlertType.success));
        setState(() {});
        Navigator.pop(context);
      } else if (response.statusCode == 203) {
        showSimpleNotification(
          Text("Failed to execute::" + json.decode(response.body)),
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
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
            Navigator.pop(context);
          },
          type: CoolAlertType.error,
          text:"An error occurred",

        );

        setState(() {
          ploading = false;
        });
        if (response.statusCode == 401) {}
      }

      setState(() {
        ploading = false;
      });
    } on TimeoutException catch (e) {
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occurred",

      );

      setState(() {
        ploading = false;
      });

      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occurred",

      );

      setState(() {
        ploading = false;
      });

      setState(() {
        ploading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occurred",

      );

      setState(() {
        ploading = false;
      });

      setState(() {
        ploading = false;
      });
      print('kkkkkk General Error: $e');
    }
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


  fetchOrder(MessageModel messageModel) async {
    setState(() {
      ploading = true;
    });
    var path = "/api/orders/single/" + widget.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      OrderModel orderModel =
      OrderModel.fromCustomer(json.decode(response.body));
      print(orderModel.customer_location);
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => SingleOrderScreen(
                orderModel: orderModel,messageModel: messageModel,
              )));
    } else {}

    setState(() {
      ploading = false;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
}
