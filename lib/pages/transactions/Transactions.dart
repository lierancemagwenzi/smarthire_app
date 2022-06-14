import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/TransactionModel.dart';
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
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/DeliveryFee.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/orders/PlaceOrder.dart';
import 'package:smarthire/pages/orders/customer/CustomerCompletedOrder.dart';
import '../../constants/colors.dart';
import '../../constants/globals.dart';
import '../../constants/sizeroute.dart';
import '../../model/provider.dart';
import '../../model/provider.dart';
import '../../model/provider.dart';
import '../../model/provider.dart';
import '../providers/ShowLocation.dart';

class AccountTransactionsScreen extends StatefulWidget {
  @override
  _AccountTransactionsScreenState createState() =>
      _AccountTransactionsScreenState();
}

class _AccountTransactionsScreenState extends State<AccountTransactionsScreen> {
  double height;
  double width;
  bool loading = false;
  @override
  void initState() {
    if (globals.id != 0) {
      getTransaction();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicatorColor: smarthireBlue,
//                indicator: CircleTabIndicator(color: Colors.red, radius: 3),
                tabs: <Widget>[
                  Tab(
                    child: Text('Received Transactions',
                        style: TextStyle(color: smarthireDark)),
                  ),
                  Tab(
                    child: Text('My Transactions',
                        style: TextStyle(color: smarthireDark)),
                  ),
                ],
              ),
            ),
          ),
          body: globals.id == 0
              ? Center(
                  child: Text(
                  "Sign In to see your transactions",
                  style: TextStyle(
                      color: smarthireDark,
                      fontSize: 20.0,
                      fontFamily: "mainfont"),
                ))
              : loading
                  ? Center(child: CircularProgressIndicator())
//                  : globals.transactions.length < 1
//                      ? Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Center(
//                                child: Text(
//                              "No transactions found",
//                              style: TextStyle(
//                                  color: smarthireBlue,
//                                  fontFamily: "sans",
//                                  fontSize: 16.0),
//                            )),
//                            RaisedButton(
//                              color: smarthireBlue,
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(20)),
//                              onPressed: () {
//                                _getData();
//                              },
//                              child: Text(
//                                "Reload",
//                                style: TextStyle(
//                                    color: Colors.white, fontFamily: "sans"),
//                              ),
//                            )
//                          ],
//                        )
                  : TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[Receivedtrans(), Mytrans()])),
    );
  }

  Mytrans() {
    List<Transaction> transactions = globals.transactions
        .where((userDetail) => (userDetail.customer_id == globals.id &&
            userDetail.provider_id != globals.id))
        .toList();
    return transactions.length < 1
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
                      Icons.monetization_on,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "You don't have any transaction ",
                  style: TextStyle(
                      color: smarthireDark,
                      fontFamily: "mainfont",
                      fontSize: 24.0),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: _getData,
            child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
                  print(format.parse(transactions[index].date));

                  var formated = format.parse(transactions[index].date);

                  var date = DateFormat.yMMMMEEEEd().format(formated);
                  String trans = "";
                  var type = transactions[index].type.split("_");

                  for (int i = 0; i < type.length; i++) {
                    trans += " " + type[i];
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
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
                            child: Text("Transaction".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: "mainfont")),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Transaction Id: #" +
                                    transactions[index].id.toString(),
                                style: TextStyle(
                                    color: smarthireBlue,
                                    fontFamily: "mainfont",
                                    fontSize: 18.0),
                              ),
                              Text(
                                "RWF" + transactions[index].amount,
                                style: TextStyle(
                                    color: smarthireDark,
                                    fontFamily: "mainfont",
                                    fontSize: 25.0),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                trans.trim(),
                                style: TextStyle(
                                    color: smarthireDark,
                                    fontFamily: "mainfont",
                                    fontSize: 18.0),
                              ),
                              Text(
                                transactions[index].status,
                                style: TextStyle(
                                    color: smarthireDark,
                                    fontFamily: "mainfont",
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                date,
                                style: TextStyle(
                                    color: smarthireDark,
                                    fontFamily: "mainfont",
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                          Container(
                            width: width,
                            color: Color(0xffbdc6c4).withOpacity(0.5),
                            child: ListTile(
                              leading: Image.asset(
                                "assets/image.png",
                              ),
                              title: Text(
                                transactions[index].product,
                                style: TextStyle(
                                    color: smarthireDark,
                                    fontFamily: "mainfont",
                                    fontSize: 24.0),
                              ),
                              subtitle: Text(
                                transactions[index].order_number,
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
                                getOrder(transactions[index].order_id);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text("View Order",
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
                  return InkWell(
                    onTap: () {
                      getOrder(transactions[index].order_id);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: smarthireBlue,
                                  size: 30.0,
                                ),
                                title: Text("item".toUpperCase()),
                                subtitle: new Text(
                                  transactions[index].product,
                                  style: TextStyle(color: smarthireBlue),
                                )),
                            ListTile(
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: smarthireBlue,
                                  size: 30.0,
                                ),
                                title: Text("Order Number".toUpperCase()),
                                subtitle: new Text(
                                  transactions[index].order_number,
                                  style: TextStyle(color: smarthireBlue),
                                )),
                            ListTile(
                                title: Text("Transaction".toUpperCase()),
                                subtitle: new Text(
                                  transactions[index].type,
                                  style: TextStyle(color: smarthireBlue),
                                )),
                            ListTile(
                                title: Text("Date".toUpperCase()),
                                subtitle: new Text(
                                  transactions[index].date,
                                  style: TextStyle(color: smarthireBlue),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  Receivedtrans() {
    List<Transaction> transactions = globals.transactions
        .where((userDetail) => (userDetail.provider_id == globals.id &&
            userDetail.customer_id != globals.id))
        .toList();
    return transactions.length < 1
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
                      Icons.monetization_on,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "You don't have any transaction ",
                  style: TextStyle(
                      color: smarthireDark,
                      fontFamily: "mainfont",
                      fontSize: 24.0),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: _getData,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
                    print(format.parse(transactions[index].date));

                    var formated = format.parse(transactions[index].date);

                    var date = DateFormat.yMMMMEEEEd().format(formated);
                    String trans = "";
                    var type = transactions[index].type.split("_");

                    for (int i = 0; i < type.length; i++) {
                      trans += " " + type[i];
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
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
                              child: Text("Transaction".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: "mainfont")),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Transaction Id: #" +
                                      transactions[index].id.toString(),
                                  style: TextStyle(
                                      color: smarthireBlue,
                                      fontFamily: "mainfont",
                                      fontSize: 18.0),
                                ),
                                Text(
                                  "RWF" + transactions[index].amount,
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  trans.trim(),
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 18.0),
                                ),
                                Text(
                                  transactions[index].status,
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 18.0),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  date,
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 18.0),
                                )
                              ],
                            ),
                            Container(
                              width: width,
                              color: Color(0xffbdc6c4).withOpacity(0.5),
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/image.png",
                                ),
                                title: Text(
                                  transactions[index].product,
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 24.0),
                                ),
                                subtitle: Text(
                                  transactions[index].order_number,
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
                                  getOrder(transactions[index].order_id);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text("View Order",
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
                    return InkWell(
                      onTap: () {
                        getOrder(transactions[index].order_id);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: smarthireBlue,
                                    size: 30.0,
                                  ),
                                  title: Text("item".toUpperCase()),
                                  subtitle: new Text(
                                    transactions[index].product,
                                    style: TextStyle(color: smarthireBlue),
                                  )),
                              ListTile(
//                          onTap: () {
//                            getOrder(transactions[index].order_id);
//                          },
//                        trailing: Icon(
//                          Icons.arrow_forward_ios,
//                          color: smarthireBlue,
//                          size: 30.0,
//                        ),
                                  title: Text("Order Number".toUpperCase()),
                                  subtitle: new Text(
                                    transactions[index].order_number,
                                    style: TextStyle(color: smarthireBlue),
                                  )),
                              ListTile(
                                  title: Text("Transaction".toUpperCase()),
                                  subtitle: new Text(
                                    transactions[index].type,
                                    style: TextStyle(color: smarthireBlue),
                                  )),
                              ListTile(
                                  title: Text("Date".toUpperCase()),
                                  subtitle: new Text(
                                    transactions[index].date,
                                    style: TextStyle(color: smarthireBlue),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
  }

  Future<void> _getData() async {
    setState(() {
      getTransaction();
    });
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
      print(orderModel.customer_location);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          loading = false;
        });
        Navigator.push(
            context,
            SlideRightRoute(
              page: CustomerCompletedOrder(
                orderModel: orderModel,
              ),
            ));
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          loading = false;
        });
      });
    }
  }

  getTransaction() async {
    setState(() {
      loading = true;
    });
    var path = "/api/orders/accounttransactions/" + globals.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print("orders" + list.length.toString());
      globals.transactions.clear();
      for (int i = 0; i < list.length; i++) {
        Transaction transaction = Transaction.fromJson(list[i]);
        setState(() {
          globals.transactions.add(transaction);
        });
      }
    } else {}
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }
}
