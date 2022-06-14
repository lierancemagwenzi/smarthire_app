import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/constants/globals.dart' as globals;

import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:http/http.dart' as http;
import 'package:smarthire/pages/orders/AcceptDeclineOrder.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/model/NotificationModel.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/pages/orders/AcceptDeclineOrder.dart';
import 'package:smarthire/pages/orders/CompleteOrder.dart';
import 'package:smarthire/pages/orders/PayCallOutFee.dart';
import 'package:smarthire/pages/orders/ProductQuotationScreen.dart';
import 'package:smarthire/pages/orders/completedOrder.dart';
import 'package:smarthire/pages/orders/customer/CustomerCompletedOrder.dart';
import 'package:smarthire/pages/orders/customer/PayQuotation.dart';
import 'package:smarthire/pages/orders/provider/CreateQuotationScreen.dart';
import 'package:smarthire/pages/orders/setOutForDelivery.dart';

class OrderScreen extends StatefulWidget {
  bool showback;

  OrderScreen({@required this.showback});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  bool loading = false;
  TabController _tabController;
  var width;
  var height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return globals.id == 0
        ? Scaffold(
        backgroundColor: globals.darkmode?Colors.black:Colors.white,

//            appBar: AppBar(
//              backgroundColor: smarthireBlue,
//              automaticallyImplyLeading: false,
//            ),
            body: Center(
                child: Text(
            "Sign In To See Your Orders",
            style: TextStyle(
                color: smarthireDark, fontSize: 20.0, fontFamily: "mainfont"),
          )))
        : DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: Scaffold(
              backgroundColor: globals.darkmode?Colors.black:Colors.white,

              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  backgroundColor: globals.darkmode?Colors.black:Color(0xfffafafa),
                  leading: widget.showback == true
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: smarthireDark,
                          ))
                      : null,
                  bottom: TabBar(
                    indicatorColor:globals.darkmode?Colors.white: smarthireBlue,
//                    indicator: CircleTabIndicator(color: Colors.red, radius: 3),
                    tabs: <Widget>[
                      Tab(
                        child: Hero(
                          tag: "12",
                          transitionOnUserGestures: true,
                          //                        flightShuttleBuilder: (flightContext, animation,
                          //                            direction, fromContext, toContext) {
                          //                          return Text(
                          //                            "Products",
                          //                            style: TextStyle(
                          //                                color: Colors.black,
                          //                                fontFamily: "open-sans",
                          //                                fontSize: 14.0),
                          //                          );
                          //                        },
                          child: Text('Received orders',
                              style: TextStyle(
                                  color: smarthireDark,
                                  fontFamily: "mainfont")),
                        ),
                      ),
                      Tab(
                        child: Hero(
                          tag: "13",
                          transitionOnUserGestures: true,
                          //                        flightShuttleBuilder: (flightContext, animation,
                          //                            direction, fromContext, toContext) {
                          //                          return Text(
                          //                            "Categories",
                          //                            style: TextStyle(
                          //                                color: Colors.black,
                          //                                fontFamily: "open-sans",
                          //                                fontSize: 14.0),
                          //                          );
                          //                        },
                          child: Text('My Orders',
                              style: TextStyle(
                                  color: smarthireDark,
                                  fontFamily: "mainfont")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
//        body:  ListView.builder
//          (
//          itemCount: global.orders.length,
//          itemBuilder: (BuildContext ctxt, int index) {
//        return InkWell(
//
//          onTap: (){
//            Navigator.push(context,
//                SizeRoute(page: SingleOrderScreen(orderModel: global.orders[index],)));
////                  Navigator.push(
////                    context,
////                    PageRouteBuilder(
////                      transitionDuration: Duration(seconds: 1),
////                      pageBuilder: (_, __, ___) =>
////                          ServiceProviderScreen(
////                            index: index,
//////                            providerModel: providerModel,
////                          ),
////                    ),
////                  );
//          },
//          child: Card(
//              child:  Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: ListTile(
//                    leading: AspectRatio(
//                        aspectRatio: 6/6,
//                        child: CircleAvatar(backgroundColor: smarthireBlue,)),
//                    subtitle: Text(global.orders[index].provider_name,style: TextStyle(color: smarthireBlue,fontSize: 13.0,fontFamily: "sans"),),
//                    title: Text(global.orders[index].provider_name,style: TextStyle(color: smarthireBlue,fontSize: 16.0,fontFamily: "sans"),)),
//              )),
//        );
//      },
//      )
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ReceivedOrders(),
                  MyOrders(),
                ],
              ),
            ),
          );
  }

  ReceivedOrders() {
    return globals.orders.length < 1
        ? Container(
            width: width,
            height: height,
            color: Color(0xfffafafa),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffc2c8d1), shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "You don't have any orders ",
                  style: TextStyle(
                      color: smarthireDark,
                      fontFamily: "mainfont",
                      fontSize: 24.0),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: _getData,
                child: ListView.builder(
                    itemCount: global.orders.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                          .parse(globals.orders[index].date, true);
                      var dateLocal = dateTime.toLocal();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () {},
                                color: smarthireBlue,
                                textColor: Colors.white,
                                child: Text("Order Received".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontFamily: "mainfont")),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Order Id: #" +
                                        globals.orders[index].id.toString(),
                                    style: TextStyle(
                                        color: smarthireBlue,
                                        fontFamily: "mainfont",
                                        fontSize: 16.0),
                                  ),
                                  Container(
                                    child: globals.orders[index].order_status ==
                                            "order_completed"
                                        ? Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: smarthireBlue),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                            ),
                                          )
                                        : globals.orders[index].order_status ==
                                                    "order-declined" ||
                                                globals.orders[index]
                                                        .order_status ==
                                                    "customer_cancelled" ||
                                                globals.orders[index]
                                                        .order_status ==
                                                    "provider_cancelled"
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: smarthireBlue),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              )
                                            : Icon(Icons.timer),
                                  )
                                ],
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontFamily: "mainfont",
                                    fontSize: 16.0),
                              ),
                              Container(
                                width: width,
                                color: Color(0xffbdc6c4).withOpacity(0.5),
                                child: ListTile(
                                  leading: Image.asset(
                                    "assets/image.png",
                                  ),
                                  title: Text(
                                    globals.orders[index].product_name,
                                    style: TextStyle(
                                        color: smarthireDark,
                                        fontFamily: "mainfont",
                                        fontSize: 24.0),
                                  ),
                                  subtitle: Text(
                                    globals.orders[index].customer_name,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "mainfont",
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                height: height * 0.07,
                                color: Color(0xffbdc6c4).withOpacity(0.5),
                                child: InkWell(
                                  onTap: () {
                                    getOrder(globals.orders[index].id);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text("View",
                                            style: TextStyle(
                                                color: smarthireDark,
                                                fontFamily: "mainfont",
                                                fontSize: 20.0)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
    Container(
      child: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.builder(
          itemCount: global.orders.length,
          itemBuilder: (BuildContext ctxt, int index) {
            var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                .parse(globals.orders[index].date, true);
            var dateLocal = dateTime.toLocal();
            String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);

            return InkWell(
              onTap: () {
                getOrder(globals.orders[index].id);
              },
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: smarthireBlue,
                    ),
                    leading:
                        globals.orders[index].order_status == "order_completed"
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: smarthireBlue),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            : globals.orders[index].order_status ==
                                        "order-declined" ||
                                    globals.orders[index].order_status ==
                                        "customer_cancelled" ||
                                    globals.orders[index].order_status ==
                                        "provider_cancelled"
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: smarthireBlue),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  )
                                : Icon(Icons.timer),
                    title: Text(
                      global.orders[index].product_name.toUpperCase(),
                      style: TextStyle(
                          color: smarthireBlue,
//                                        fontSize: 13.0,
                          fontFamily: "sans"),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          global.orders[index].order_number,
                          maxLines: 1,
                          style: TextStyle(
                              color: smarthireBlue,
                              fontSize: 12.0,
                              fontFamily: "sans"),
                        ),
                        AutoSizeText(
                          formattedDate,
                          maxLines: 1,
                          style: TextStyle(
                              color: smarthireBlue,
                              fontSize: 13.0,
                              fontFamily: "sans"),
                        ),
                      ],
                    )),
              )),
            );
          },
        ),
      ),
    );
  }

  MyOrders() {
    return globals.myorders.length < 1
        ? Container(
            width: width,
            height: height,
            color: Color(0xfffafafa),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffc2c8d1), shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.shopping_basket,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "You never made any orders",
                  style: TextStyle(
                      color: smarthireDark,
                      fontFamily: "mainfont",
                      fontSize: 24.0),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: _getData,
                child: ListView.builder(
                    itemCount: global.myorders.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                          .parse(globals.myorders[index].date, true);
                      var dateLocal = dateTime.toLocal();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () {},
                                color: smarthireBlue,
                                textColor: Colors.white,
                                child: Text("Order Sent".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontFamily: "mainfont")),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Order Id: #" +
                                        globals.myorders[index].id.toString(),
                                    style: TextStyle(
                                        color: smarthireBlue,
                                        fontFamily: "mainfont",
                                        fontSize: 16.0),
                                  ),
                                  Container(
                                    child: globals.myorders[index].order_status ==
                                            "order_completed"
                                        ? Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: smarthireBlue),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                            ),
                                          )
                                        : globals.myorders[index].order_status ==
                                                    "order-declined" ||
                                                globals.myorders[index]
                                                        .order_status ==
                                                    "customer_cancelled" ||
                                                globals.myorders[index]
                                                        .order_status ==
                                                    "provider_cancelled"
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: smarthireBlue),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              )
                                            : Icon(Icons.timer),
                                  )
                                ],
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontFamily: "mainfont",
                                    fontSize: 16.0),
                              ),
                              Container(
                                width: width,
                                color: Color(0xffbdc6c4).withOpacity(0.5),
                                child: ListTile(
                                  leading: Image.asset(
                                    "assets/image.png",
                                  ),
                                  title: Text(
                                    globals.myorders[index].product_name,
                                    style: TextStyle(
                                        color: smarthireDark,
                                        fontFamily: "mainfont",
                                        fontSize: 24.0),
                                  ),
                                  subtitle: Text(
                                    globals.myorders[index].provider_name,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "mainfont",
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                height: height * 0.07,
                                color: Color(0xffbdc6c4).withOpacity(0.5),
                                child: InkWell(
                                  onTap: () {
                                    getOrder(globals.myorders[index].id);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text("View",
                                            style: TextStyle(
                                                color: smarthireDark,
                                                fontFamily: "mainfont",
                                                fontSize: 20.0)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
    return Container(
      child: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.builder(
          itemCount: global.myorders.length,
          itemBuilder: (BuildContext ctxt, int index) {
            var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                .parse(globals.myorders[index].date, true);
            var dateLocal = dateTime.toLocal();
            String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);

            return InkWell(
              onTap: () {
                getOrder(globals.myorders[index].id);
              },
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    leading: globals.myorders[index].order_status ==
                            "order_completed"
                        ? Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: smarthireBlue),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          )
                        : globals.myorders[index].order_status ==
                                    "order-declined" ||
                                globals.myorders[index].order_status ==
                                    "customer_cancelled" ||
                                globals.myorders[index].order_status ==
                                    "provider_cancelled"
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: smarthireBlue),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              )
                            : Icon(Icons.timer),
                    title: AutoSizeText(
                      global.myorders[index].product_name.toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                          color: smarthireBlue,
//                                              fontSize: 13.0,
                          fontFamily: "sans"),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                              color: smarthireBlue,
                              fontSize: 13.0,
                              fontFamily: "sans"),
                        ),
                        AutoSizeText(
                          global.myorders[index].order_number,
                          maxLines: 1,
                          style: TextStyle(
                              color: smarthireBlue,
                              fontSize: 12.0,
                              fontFamily: "sans"),
                        ),
                      ],
                    )),
              )),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {
      getOrders();
      getMyOrders();
    });
  }

  getOrder(int id) async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/single/" + id.toString();
    var response = await get(url + path);

//    print("response+body" + response.body);
    if (response.statusCode == 201) {
      OrderModel orderModel =
          OrderModel.fromCustomer(json.decode(response.body));
      print("%%%%%%%%%%%%%%%%%%%%%%%%" + orderModel.order_status);
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

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 1);
    getMyOrders();
    getOrders();
    super.initState();
  }

  getOrders() async {
    var path = "/api/orders/" + global.id.toString();
    var response = await http.get(global.url + path);
    print("reviews" + response.body);
    if (response.statusCode == 201) {
      global.orders.clear();
      List<dynamic> list = json.decode(response.body);
      print(list);
      print("orders" + list.length.toString());
      for (int i = 0; i < list.length; i++) {
        OrderModel orderModel = OrderModel.fromCustomer(list[i]);
        setState(() {
          global.orders.add(orderModel);
        });
      }
    } else {}
  }

  getMyOrders() async {
    var path = "/api/customer/orders/" + global.id.toString();
    var response = await http.get(global.url + path);
    print("reviews" + response.body);
    if (response.statusCode == 201) {
      global.myorders.clear();

      List<dynamic> list = json.decode(response.body);
      print(list);
      print("myorders" + list.length.toString());
      for (int i = 0; i < list.length; i++) {
        OrderModel orderModel = OrderModel.fromJson(list[i]);
        setState(() {
          global.myorders.add(orderModel);
        });
      }
    } else {}
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
