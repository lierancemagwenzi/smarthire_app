import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/provider.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';
import 'package:smarthire/pages/providers/ServiceProviderScreen.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/icons/filter.dart' as filtericon;
import 'package:smarthire/icons/services.dart' as services;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/PlaceOrder.dart';

import 'EditProductScreen.dart';

class ProductListing extends StatefulWidget {
  @override
  _ProductListingState createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  double height;
  double width;
  String filter = "";

  bool showfilter = true;
  TextEditingController searchcontroller = new TextEditingController();
  bool showsearch = false;
  List<ProviderModel> results = [];

  List<ProviderModel> providersList = [];
  String result = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: showsearch
          ? AppBar(
              backgroundColor: smarthireBlue,
              title: searchView(),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      showsearch = false;
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            )
          : AppBar(
              backgroundColor: smarthireBlue,
              title: Text("My Products"),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      showsearch = true;
                    });
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              ],
            ),
      body: loading ? Center(child: CircularProgressIndicator()) : body(),
    );
  }

  SearchProducts() {
    searchcontroller.addListener(() {
      List<String> words = searchcontroller.text.split(' ');
      setState(() {
        results.clear();
        filter = searchcontroller.text;
        for (int i = 0; i < providersList.length; i++) {
          for (int d = 0; d < words.length; d++) {
            if (providersList[i]
                    .service_name
                    .toLowerCase()
                    .contains(words[d].toLowerCase()) ||
                providersList[i]
                    .location
                    .toLowerCase()
                    .contains(words[d].toLowerCase()) ||
                providersList[i]
                        .provider_name
                        .toLowerCase()
                        .contains(words[d].toLowerCase()) &&
                    filter != "") {
              results.add(providersList[i]);
              results.toSet().toList();
            }
          }
        }
      });
    });
  }

  searchView() {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.005),
      child: Hero(
        tag: "search",
        transitionOnUserGestures: true,
        flightShuttleBuilder:
            (flightContext, animation, direction, fromContext, toContext) {
          return Icon(
            Icons.search,
            size: 50.0,
            color: Colors.white,
          );
        },
        child: Container(
          width: width * 0.9,
          child: new TextField(
            autofocus: false,
            controller: searchcontroller,
            textInputAction: TextInputAction.search,
            style: new TextStyle(
              color: Colors.white,
              fontFamily: 'open-sans',
            ),
            decoration: new InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: const Radius.circular(30.0),
                  ),
                ),
                hintStyle: new TextStyle(
                  color: Colors.white,
                  fontFamily: 'open-sans',
                ),
                hintText: "Type a search",
                fillColor: Color(0xffE2E2E2)),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getProducts();
    SearchProducts();
    super.initState();
  }

  body() {
    List<ProviderModel> providersList =
        filter == "" ? this.providersList : results;
    return result.length > 0 && providersList.length < 1
        ? Center(
            child: Text(
              result,
              style: TextStyle(
                  color: smarthireBlue, fontFamily: "sans", fontSize: 16),
            ),
          )
        : new ListView.builder(
            itemCount: providersList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              List<String> images = [];
              List<double> aspect_ratios = [];
              List<String> gallery =
                  providersList[index].product_gallery.split("#");
              List<String> ratios =
                  providersList[index].aspect_ratio.split("#");

              gallery.removeLast();
              ratios.removeLast();
              for (int i = 0; i < gallery.length; i++) {
                images.add(gallery[i]);
              }
              for (int i = 0; i < ratios.length; i++) {
                aspect_ratios.add(double.parse(ratios[i]));
              }
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideRightRoute(
                          page: ServiceProviderScreen(
                        providerModel: providersList[index],
                      )));
//                  Navigator.push(
//                    context,
//                    PageRouteBuilder(
//                      transitionDuration: Duration(seconds: 1),
//                      pageBuilder: (_, __, ___) =>
//                          ServiceProviderScreen(
//                            index: index,
////                            providerModel: providerModel,
//                          ),
//                    ),
//                  );
                },
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      trailing: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      page: EditProductScreen(
                                    providerModel: providersList[index],
                                  )));
                            },
                            child: Icon(
                              Icons.settings,
                              color: smarthireBlue,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(providersList[index].location),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              providersList[index].product_type,
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                DeleteProduct(
                                    providersList[index].service_id, index);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      leading: AspectRatio(
                          aspectRatio: 6 / 6,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              global.fileserver + images[0],
                            ),
                            backgroundColor: smarthireBlue,
                          )),
                      title: Text(
                        providersList[index].service_name,
                        style: TextStyle(
                            color: smarthireBlue,
                            fontSize: 16.0,
                            fontFamily: "sans"),
                      )),
                )),
              );
            });
  }

  DeleteProduct(int id, int index) async {
    setState(() {
      loading = true;
    });
    var path = "/api/products/delete/" + id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          providersList.removeAt(index);
          loading = false;
        });
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Product Deleted!",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: smarthireBlue);
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          loading = false;
        });
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Failed to delete.Product is referenced in an order.Try turning off its visibility",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: Colors.redAccent);
      });
    }
  }

  getProducts() async {
    setState(() {
      loading = true;
    });
    var path = "/api/accountproducts/" + global.id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print("orders" + list.length.toString());
      for (int i = 0; i < list.length; i++) {
        ProviderModel providerModel = ProviderModel.fromJson(list[i]);
        providerModel.profile_pic =
            global.fileserver + providerModel.profile_pic;

        setState(() {
          providersList.add(providerModel);
        });
      }
    } else {
      setState(() {
        result = "No products or services found";
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }
}
