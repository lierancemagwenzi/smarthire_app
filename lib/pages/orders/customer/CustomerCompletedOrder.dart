import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/Quotation.dart';
import 'package:smarthire/model/TransactionModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/pages/orders/showuser.dart';
import 'package:smarthire/pages/providers/ShowLocation.dart';
import 'package:smarthire/pages/providers/account/UserProductsScreen.dart';
import 'package:smarthire/pages/orders/ViewQuotation.dart' as vq;
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/pages/services/OrderProduct.dart';
import '../VideoReview.dart';
import '../showProduct.dart';

class CustomerCompletedOrder extends StatefulWidget {
  OrderModel orderModel;
  CustomerCompletedOrder({@required this.orderModel});
  @override
  _CustomerCompletedOrderState createState() => _CustomerCompletedOrderState();
}

class _CustomerCompletedOrderState extends State<CustomerCompletedOrder> {
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
          "Completed Order",
          style: TextStyle(
            color: smarthireBlue,
            fontFamily: "mainfont",
          ),
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
                            TextStyle(color: smarthireDark, fontFamily: "sans"),
                      ),
                      subtitle: Text(formattedDate,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
                    ),
                    ListTile(
                      title: Text(
                        "ORDER NUMBER".toUpperCase(),
                        style:
                            TextStyle(color: smarthireDark, fontFamily: "sans"),
                      ),
                      subtitle: Text(orderModel.order_number,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
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
                                      provider_id: orderModel.provider_id,
                                      provider_name:
                                          widget.orderModel.provider_name)),
                            ));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireDark,
                        size: 30.0,
                      ),
                      title: Text("Provider".toUpperCase(),
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
                      subtitle: Text(orderModel.provider_name,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
                    ),
                    orderModel.product_type == "product"
                        ? ListTile(
                            title: Text(
                              "Ordered Quantity".toUpperCase(),
                              style: TextStyle(
                                  color: smarthireDark,
                                  fontFamily: "open-sans"),
                            ),
                            subtitle: Text(
                                orderModel.quantity +
                                    " X " +
                                    orderModel.product_unit,
                                style: TextStyle(
                                    color: smarthireDark,
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
                                  color: smarthireDark,
                                  fontFamily: "open-sans"),
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
                        getProduct(0);
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireDark,
                        size: 30.0,
                      ),
                      title: Text(widget.orderModel.product_type.toUpperCase(),
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
                      subtitle: Text(orderModel.product_name,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
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
                              color: smarthireDark, fontFamily: "sans")),
                      subtitle: Text(orderModel.order_status,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
                    ),
                    CheckboxListTile(
                      title: Text("Delivery?".toUpperCase(),
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
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
                              color: smarthireDark,
                              size: 30.0,
                            ),
                      title: Text("Location".toUpperCase(),
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
                      subtitle: Text(
                          orderModel.customer_location == null ||
                                  orderModel.customer_location.length < 2
                              ? "No location"
                              : orderModel.customer_location,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "sans")),
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
                              color: smarthireDark,
                              fontWeight: FontWeight.bold,
                              fontFamily: "sans",
                              fontSize: 18.0)),
                    ),
                    Container(
                      height: height * 0.3,
                      width: width,
                      decoration: BoxDecoration(
                        color: smarthireDark,
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
                              color: smarthireDark,
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
                              style: TextStyle(color: smarthireDark),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 30.0,
                              color: smarthireDark,
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
                              style: TextStyle(color: smarthireDark),
                            ),
                            trailing: Text(
                              "RWF" + transactions[index].amount,
                              style: TextStyle(color: smarthireDark),
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
      OrderModel orderModel = OrderModel.fromJson(json.decode(response.body));
      print(orderModel.customer_location);
      setState(() {
        this.orderModel = orderModel;
      });
    } else {}

    setState(() {
      loading = false;
    });
  }

  getProduct(i) async {
    setState(() {
      loading = true;
    });
    var path = "/api/product/" + widget.orderModel.product_id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      ProviderModel providerModel =
      ProviderModel.fromJson(json.decode(response.body));
      providerModel.profile_pic = globals.fileserver + providerModel.profile_pic;
      Navigator.push(
          context,
          SlideRightRoute(
            page: OrderProductScreen(
              providerModel: providerModel,            ),
          ));

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
