import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/provider.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/providers/CategoryScreen.dart';
import 'package:smarthire/pages/providers/ServiceProviderScreen.dart';
import 'package:smarthire/constants/globals.dart' as global;
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

class ComparisonScreen extends StatefulWidget {
  String product;

  ComparisonScreen({@required this.product});

  @override
  _ComparisonScreenState createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  double height;
  double width;
  bool loading = false;
  List<ProviderModel> providersList = [];
  List<String> words = [];

  List<ProviderModel> results = [];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Price Comparisons"),
        backgroundColor: smarthireBlue,
      ),
      body:
          loading ? Center(child: CircularProgressIndicator()) : ProductsView(),
    );
  }

  ProductsView() {
    List<ProviderModel> providersList = this
        .providersList
        .where((site) => site.product_type == 'product')
        .toList();

    return Column(
      children: <Widget>[
        Center(
            child: Text(
          "Search results for " + widget.product,
          style: TextStyle(
              color: smarthireBlue, fontSize: 14.0, fontFamily: "sans"),
        )),
        providersList.length < 1
            ? Text(
                "No results found",
                style: TextStyle(color: smarthireBlue, fontSize: 18.0),
              )
            : Flexible(
                child: ListView.builder(
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

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                onTap: () {
//                      Navigator.push(
//                          context,
//                          SlideRightRoute(
//                              page: ServiceProviderScreen(
//                                providerModel: providersList[index],
//                              )));
                                },
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(providersList[index].location),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: AutoSizeText(
                                        providersList[index].currency +
                                            providersList[index].price,
                                        style: TextStyle(color: smarthireBlue),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: AutoSizeText(
                                        providersList[index].provider_name,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
//                                trailing: Icon(
//                                  Icons.arrow_forward_ios,
//                                  color: smarthireBlue,
//                                ),
                                leading: AspectRatio(
                                  aspectRatio: 6 / 6,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      global.fileserver + images[0],
                                    ),
                                    backgroundColor: smarthireBlue,
                                  ),
                                ),
                                title: new Text(
                                    providersList[index].service_name)),
                          ),
                        ),
                      );
                    }),
              ),
      ],
    );
  }

  @override
  void initState() {
    words = widget.product.split(" ");

    for (int i = 0; i < words.length; i++) {
      getProducts(words[i]);
    }
    super.initState();
  }

  getProducts(String search) async {
    setState(() {
      loading = true;

      providersList.clear();
    });
    var path = "/api/products/search/" + search;
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
      setState(() {});
    } else {}

    setState(() {
      loading = false;
    });
  }
}
