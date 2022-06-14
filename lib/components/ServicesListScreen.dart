import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/model/service.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/providers/CategoryScreen.dart';
import 'package:smarthire/pages/services/CategoriesScreen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ServicesListScreen extends StatefulWidget {
  bool ishome;

  ServicesListScreen({@required this.ishome});
  @override
  _ServicesListScreenState createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  List<ServiceModel> services = [];
  bool loading = false;
  List<ServiceModel> products = [];

  @override
  void initState() {
    getServices();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerWidget();
  }

  DrawerWidget() {
    services.clear();
    products.clear();
    for (int i = 0; i < globals.services.length; i++) {
      if (globals.services[i].type == "service") {
        services.add(globals.services[i]);
      }
    }

    for (int i = 0; i < globals.services.length; i++) {
      if (globals.services[i].type == "product") {
        products.add(globals.services[i]);
      }
    }

    return Drawer(
        child: Container(
          color: globals.darkmode?Colors.black:Colors.white,
          child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Text(
                    "Services",
                    style: TextStyle(
                        color: smarthireDark,
                        fontFamily: "mainfont",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  new ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return InkWell(
                          onTap: () {
                            if (widget.ishome == false) {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => CategoriesScreen(
                                            serviceModel: services[index],
                                          )));
                            } else {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => CategoriesScreen(
                                            serviceModel: services[index],
                                          )));
                            }
                          },
                          child: ListTile(
                              leading: AspectRatio(
                                aspectRatio: 6 / 6,
                                child: CircleAvatar(
                                  backgroundColor: smarthireDark,
                                  backgroundImage:
                                      NetworkImage(services[index].banner),
                                ),
                              ),
                              title: Text(services[index].service_name,
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal))),
                        );
                      }),
                  Text(
                    "Products",
                    style: TextStyle(
                        color: smarthireDark,
                        fontFamily: "mainfont",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  new ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => CategoriesScreen(
                                              serviceModel: products[index],
                                            )));
                              },
                              leading: AspectRatio(
                                aspectRatio: 6 / 6,
                                child: CircleAvatar(
                                  backgroundColor: smarthireDark,
                                  backgroundImage:
                                      NetworkImage(products[index].banner),
                                ),
                              ),
                              title: Text(products[index].service_name,
                                  style: TextStyle(
                                      color: smarthireDark,
                                      fontFamily: "mainfont",
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal))),
                        );
                      }),
                ],
              ),
    ),
        ));
  }

  getServices() async {
    setState(() {
      loading = true;
    });
    var path = "api/services";
    var response = await get(globals.apiurl + path);
    if (response.statusCode == 201) {
      globals.services.clear();
      List<dynamic> list = json.decode(response.body);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        ServiceModel serviceModel = ServiceModel.fromJson(list[i]);
        globals.services.add(serviceModel);
      }
    } else {}

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }
}
