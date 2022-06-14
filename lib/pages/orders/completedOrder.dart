import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'dart:convert';
import 'package:smarthire/pages/orders/ViewQuotation.dart' as vq;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/Quotation.dart';
import 'package:smarthire/model/TransactionModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/pages/orders/showProduct.dart';
import 'package:smarthire/pages/orders/showuser.dart';
import 'package:smarthire/pages/providers/ShowLocation.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/pages/providers/account/UserProductsScreen.dart';

import 'VideoReview.dart';

class CompletedOrder extends StatefulWidget {
  OrderModel orderModel;
  CompletedOrder({@required this.orderModel});

  @override
  _CompletedOrderState createState() => _CompletedOrderState();
}

class _CompletedOrderState extends State<CompletedOrder> {
  double height;
  double width;

  OrderModel orderModel;
  bool loading = false;
  List<Quotation> items = [];
  List<Transaction> transactions = [];

  static num tryParse(String input) {
    String source = input.trim();
    return int.tryParse(source) ?? double.tryParse(source);
  }

  @override
  void initState() {
    this.orderModel = widget.orderModel;
    getOrder();
    getQuotation();
    getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    var dateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(orderModel.date, true);
    var dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text(
          "Completed Order",
          style: TextStyle(color: Colors.white, fontFamily: "sans"),
        ),
      ),
      body: orderModel == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Order Date".toUpperCase(),
                        style:
                            TextStyle(color: smarthireBlue, fontFamily: "sans"),
                      ),
                      subtitle: Text(formattedDate,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                    ),
                    ListTile(
                      title: Text(
                        "ORDER NUMBER".toUpperCase(),
                        style:
                            TextStyle(color: smarthireBlue, fontFamily: "sans"),
                      ),
                      subtitle: Text(orderModel.order_number,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                    ),
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
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            SizeRoute(
                              page: UserProductsScreen(
                                  providerModel: new ProviderModel(
                                      provider_id: orderModel.customer_id,
                                      provider_name:
                                          widget.orderModel.customer_name)),
                            ));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireBlue,
                        size: 30.0,
                      ),
                      title: Text("Customer".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                      subtitle: Text(orderModel.customer_name,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
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
                    orderModel.product_type == "service" &&
                            orderModel.review_video != null
                        ? ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                    page: ReviewVideoPlayerScreen(
                                      url: globals.fileserver +
                                          orderModel.review_video,
                                    ),
                                  ));
                            },
                            title: Text(
                              "Review Video".toUpperCase(),
                              style: TextStyle(
                                  color: smarthireBlue,
                                  fontFamily: "open-sans"),
                            ),
                            trailing: Icon(
                              Icons.play_circle_outline,
                              color: smarthireBlue,
                              size: 30.0,
                            ),
                          )
                        : Container(),
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
                      title: Text(widget.orderModel.product_type.toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                      subtitle: Text(orderModel.product_name,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                    ),
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
                    ListTile(
                      title: Text("Status".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                      subtitle: Text(orderModel.order_status,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                    ),
                    CheckboxListTile(
                      title: Text("Delivery?".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
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
                      title: Text("Location".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                      subtitle: Text(
                          orderModel.customer_location == null ||
                                  orderModel.customer_location.length < 2
                              ? "No location"
                              : orderModel.customer_location,
                          style: TextStyle(
                              color: smarthireBlue, fontFamily: "sans")),
                    ),
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
                    ListTile(
                      title: Text("Customer Signature".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans",
                              fontSize: 18.0)),
                    ),
                    Container(
                      height: height * 0.3,
                      width: width,
                      decoration: BoxDecoration(
                        color: smarthireBlue,
                        image: DecorationImage(
                          image: NetworkImage(
                              fileserver + widget.orderModel.signature),
                          fit: BoxFit.fitWidth,
                        ),
//                  shape: BoxShape.circle,
                      ),
                    ),
                    ListTile(
                      title: Text("Receipt".toUpperCase(),
                          style: TextStyle(
                              color: smarthireBlue,
                              fontWeight: FontWeight.bold,
                              fontFamily: "open-sans",
                              fontSize: 18.0)),
                    ),
                    orderModel.product_type == "service"
                        ? ListTile(
                            onTap: () {
                              if (orderModel.product_type == "service") {
                                Navigator.push(
                                    context,
                                    SizeRoute(
                                      page: vq.Quotation(
                                        orderModel: orderModel,
                                      ),
                                    ));
                              }
                            },
                            title: Text(
                              "View Quotation",
                              style: TextStyle(color: smarthireBlue),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 30.0,
                              color: smarthireBlue,
                            ),
                          )
                        : Text(""),
                    new ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: transactions.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return ListTile(
                            title: Text(
                              transactions[index].type,
                              style: TextStyle(color: smarthireBlue),
                            ),
                            trailing: Text(
                              "RWF" + transactions[index].amount,
                              style: TextStyle(color: smarthireBlue),
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
    );
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
        Quotation quotation = Quotation.fromJson(list[i]);
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

  getOrder() async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/single/" + widget.orderModel.id.toString();
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

  getTransaction() async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/transactions/" + widget.orderModel.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print("orders" + list.length.toString());
      for (int i = 0; i < list.length; i++) {
        Transaction transaction = Transaction.fromJson(list[i]);
        setState(() {
          transactions.add(transaction);
        });
      }
      setState(() {});
    } else {}

    setState(() {
      loading = false;
    });
  }
}
