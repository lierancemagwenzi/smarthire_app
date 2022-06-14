import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/model/NotificationModel.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/orders/AcceptDeclineOrder.dart';
import 'package:smarthire/pages/orders/CompleteOrder.dart';
import 'package:smarthire/pages/orders/PayCallOutFee.dart';
import 'package:smarthire/pages/orders/ProductQuotationScreen.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'package:smarthire/pages/orders/completedOrder.dart';
import 'package:smarthire/pages/orders/customer/CustomerCompletedOrder.dart';
import 'package:smarthire/pages/orders/customer/PayQuotation.dart';
import 'package:smarthire/pages/orders/provider/CreateQuotationScreen.dart';
import 'package:smarthire/pages/orders/setOutForDelivery.dart';

import '../constants/colors.dart';
import '../constants/colors.dart';
import '../constants/colors.dart';
import '../constants/sizeroute.dart';

class AllNotifications extends StatefulWidget {
  @override
  _AllNotificationsState createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  List<NotificationModel> data = [];
  List<int> ids = [];
  double height;
  double width;
  bool loading = false;

  Updateseen() async {
    print('Response status');
    var url = globals.url + 'updateseen';
    var response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'user_id': globals.id, 'notifications': ids}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfffafafa),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: smarthireBlue,
            size: 30.0,
          ),
        ),
        title: Text(
          "Account Notifications",
          style: TextStyle(
            color: smarthireDark,
            fontFamily: "mainfont",
          ),
        ),

      ),
      body: Notifications(),
    );
  }

  Notifications() {
    return Stack(
      children: <Widget>[
        new ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return InkWell(
                onTap: () {
                  if (globals.id == 0) {
                    Navigator.push(
                        context,
                        SlideRightRoute(
                          page: LoginPage(),
                        ));
                  } else {
                    getOrder(data[index].action_id);
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: smarthirePurple,
                        size: 30.0,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireDark,
                        size: 30.0,
                      ),
                      title: Text(
                        data[index].title,
                        style:
                            TextStyle(color: smarthireDark, fontFamily: "sans"),
                      ),
                      subtitle: Text(
                        data[index].title,
                        style:
                            TextStyle(color: smarthireDark, fontFamily: "sans"),
                      ),
                    ),
                  ),
                ),
              );
            }),
        loading ? Center(child: CircularProgressIndicator()) : Container()
      ],
    );
  }

  getOrder(int id) async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/single/" + id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      OrderModel orderModel =
          OrderModel.fromCustomer(json.decode(response.body));

      if (orderModel.provider_id == globals.id) {
        if (orderModel.order_status == "pending-provider-response" &&
            orderModel.provider_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: ActionOrderScreen(
                  id: orderModel.id,
                ),
              ));
        } else if (orderModel.order_status == "callout_fee_paid" &&
            orderModel.provider_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: CreateQuotationScreen(
                  orderModel: orderModel,
                ),
              ));
        } else if (orderModel.order_status == "order_completed" &&
            orderModel.provider_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: CompletedOrder(
                  orderModel: orderModel,
                ),
              ));
        } else if ((orderModel.order_status == "payment_made" ||
                orderModel.order_status == "out_for_delivery" ||
                orderModel.order_status == "arrived" ||
                orderModel.order_status == "delayed") &&
            orderModel.provider_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: SetOutForDelivery(orderModel: orderModel),
              ));
        } else {
          Navigator.push(
              context,
              SlideRightRoute(
                page: SingleOrderScreen(orderModel: orderModel),
              ));
        }
      } else {
        if (orderModel.order_status == "charge_callout_fee" &&
            orderModel.customer_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: PayCallOutFee(id: orderModel.id),
              ));
        } else if (orderModel.order_status == "charge_delivery_fee" &&
            orderModel.customer_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: ProductQuotationScreen(orderModel: orderModel),
              ));
        } else if (orderModel.order_status == "quotation_sent" &&
            orderModel.customer_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: PayQuotation(orderModel: orderModel),
              ));
        } else if ((orderModel.order_status == "payment_made" ||
                orderModel.order_status == "out_for_delivery" ||
                orderModel.order_status == "arrived" ||
                orderModel.order_status == "delayed") &&
            orderModel.customer_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: CompleteOrder(orderModel: orderModel),
              ));
        } else if (orderModel.order_status == "order_completed" &&
            orderModel.customer_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: CustomerCompletedOrder(
                  orderModel: orderModel,
                ),
              ));
        } else if (orderModel.order_status == "order-accepted" &&
            orderModel.delivery != 1 &&
            orderModel.customer_id == globals.id) {
          Navigator.push(
              context,
              SlideRightRoute(
                page: ProductQuotationScreen(
                  orderModel: orderModel,
                ),
              ));
        } else {
          Navigator.push(
              context,
              SlideRightRoute(
                page: SingleOrderScreen(orderModel: orderModel),
              ));
        }
      }
    } else {}

    setState(() {
      loading = false;
    });
  }

  getNotifications() async {
    globals.personalnotifications.clear();
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
      () => http
          .get(globals.url + '/api/allnotifications/' + globals.id.toString())
          .timeout(Duration(seconds: 5)),
      // Retry on  socketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print("personalnotifications:::::" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      for (int i = 0; i < list.length; i++) {
        NotificationModel notificationModel =
            NotificationModel.fromJson(list[i]);
        globals.personalnotifications.add(notificationModel);
        setState(() {
          data.add(notificationModel);
        });
      }
    } else {}
  }
}
