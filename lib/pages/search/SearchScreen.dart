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

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double height;
  double width;
  bool loading = false;
  TextEditingController searchcontroller = new TextEditingController();

  List<ProviderModel> providersList = [];

  List<ServiceModel> services = [];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: smarthireBlue,
          title: searchView(),
          actions: <Widget>[],
          bottom: TabBar(
            indicator: CircleTabIndicator(color: Colors.red, radius: 3),
            tabs: <Widget>[
              Tab(
                child: Text('Products', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('Services', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child:
                    Text('Categories', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ProductsView(),
                  Services(),
                  CategoriesView(),
                ],
              ),
      ),
    );
  }

  ProductsView() {
    List<ProviderModel> providersList = this
        .providersList
        .where((site) => site.product_type == 'product')
        .toList();

    return ListView.builder(
        itemCount: providersList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          List<String> images = [];
          List<double> aspect_ratios = [];
          List<String> gallery =
              providersList[index].product_gallery.split("#");
          List<String> ratios = providersList[index].aspect_ratio.split("#");

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
                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: ServiceProviderScreen(
                            providerModel: providersList[index],
                          )));
                    },
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(providersList[index].location),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(providersList[index].provider_name),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: smarthireBlue,
                    ),
                    leading: AspectRatio(
                      aspectRatio: 6 / 6,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          global.fileserver + images[0],
                        ),
                        backgroundColor: smarthireBlue,
                      ),
                    ),
                    title: new Text(providersList[index].service_name)),
              ),
            ),
          );
        });
  }

  Services() {
    List<ProviderModel> providersList = this
        .providersList
        .where((site) => site.product_type == 'service')
        .toList();

    return ListView.builder(
        itemCount: providersList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          List<String> images = [];
          List<double> aspect_ratios = [];
          List<String> gallery =
              providersList[index].product_gallery.split("#");
          List<String> ratios = providersList[index].aspect_ratio.split("#");

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
                      Navigator.push(
                          context,
                          SlideRightRoute(
                              page: ServiceProviderScreen(
                            providerModel: providersList[index],
                          )));
                    },
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(providersList[index].location),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(providersList[index].provider_name),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: smarthireBlue,
                    ),
                    leading: AspectRatio(
                      aspectRatio: 6 / 6,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          global.fileserver + images[0],
                        ),
                        backgroundColor: smarthireBlue,
                      ),
                    ),
                    title: new Text(providersList[index].service_name)),
              ),
            ),
          );
        });
  }

  CategoriesView() {
    return ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          SlideRightRoute(
                            page: CategoryScreen(
                              serviceModel: services[index],
                            ),
                          ));
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: smarthireBlue,
                    ),
                    leading: AspectRatio(
                      aspectRatio: 6 / 6,
                      child: CircleAvatar(
                        backgroundColor: smarthireBlue,
                        backgroundImage: NetworkImage(services[index].banner),
                      ),
                    ),
                    title: new Text(services[index].service_name)),
              ),
            ),
          );
        });
    ;
  }

  searchView() {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.005),
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
          onEditingComplete: () {
            if (searchcontroller.text != null &&
                searchcontroller.text.length > 0) {
              getProducts();
              searchCategories();
            }
          },
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
    );
  }

  searchCategories() {
    this.services.clear();
    for (int i = 0; i < global.services.length; i++) {
      if (global.services[i].service_name
          .toLowerCase()
          .contains(searchcontroller.text.toLowerCase())) {
        setState(() {
          this.services.add(global.services[i]);
        });
      }
    }
  }

  getProducts() async {
    setState(() {
      providersList.clear();
      loading = true;
    });
    var path = "/api/products/search/" + searchcontroller.text;
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
