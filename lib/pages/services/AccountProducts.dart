import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/components/DrawerWidget.dart';
import 'package:smarthire/components/ServicesListScreen.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/providers/ServiceProviderScreen.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/icons/filter.dart' as filtericon;
import 'package:smarthire/icons/services.dart' as services;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:smarthire/components/DrawerWidget.dart' as drawer;
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
import 'package:smarthire/pages/providers/account/EditProductScreen.dart';
import 'package:smarthire/pages/services/ProductScreen.dart';

class AccountProducts extends StatefulWidget {
  @override
  _AccountProductsState createState() => _AccountProductsState();
}

class _AccountProductsState extends State<AccountProducts> {
  final key = new GlobalKey<ScaffoldState>();
  double height;
  double width;
  bool loading = false;
  String result = "";
  bool grid = true;
  List<ProviderModel> providersList = [];
  String filter = "";

  bool showfilter = true;
  TextEditingController searchcontroller = new TextEditingController();
  bool showsearch = false;
  List<ProviderModel> results = [];

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

  @override
  void initState() {
    getProducts();
    SearchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      drawer: DrawerWidget(),
      endDrawer: ServicesListScreen(
        ishome: false,
      ),
      appBar: CustomAppBar(
        height: height * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 2.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        return Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: smarthireDark,
                        size: 30.0,
                      ),
                    ),
                    Text(
                      "Products",
                      style: TextStyle(
                          letterSpacing: 1.5,
                          color: smarthireBlue,
                          fontFamily: "mainfont",
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          return key.currentState.openEndDrawer();
                        },
                        child: Icon(Icons.filter_list,
                            size: 30.0, color: smarthireDark),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SeachField(),
            SizedBox(
              height: height * 0.03,
            ),
            TitleWidget(),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : grid ? GridShow() : ListShow())
          ],
        ),
      ),
    );
  }

  TitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.category,
              size: 40.0,
              color: smarthireDark,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              "My Products",
              style: TextStyle(
                  color: smarthireDark,
                  fontFamily: "mainfont",
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            )
          ],
        ),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  grid = false;
                });
              },
              child: Icon(
                Icons.list,
                size: 40.0,
                color: !grid ? smarthireBlue : smarthireDark,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  grid = true;
                });
              },
              child: Icon(
                Icons.apps,
                size: 40.0,
                color: !grid ? smarthireDark : smarthireBlue,
              ),
            ),
          ],
        )
      ],
    );
  }

  //widgets
  SeachField() {
    return new TextField(
      controller: searchcontroller,
      decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: smarthireBlue,
          ),
          suffixIcon: InkWell(
            onTap: () {
              return key.currentState.openDrawer();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Filter",
                      style: TextStyle(
                          color: smarthireDark, fontFamily: "mainfont"),
                    ),
                    Icon(
                      Icons.filter_list,
                      color: smarthireDark,
                    )
                  ],
                ),
              ),
            ),
          ),
          border: new OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.7),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.7),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.grey[800]),
          hintText: "Search for products",
          fillColor: Colors.white70),
    );
  }

  ActionDialog(ProviderModel providerModel) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: height * 0.4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Action",
                          style: TextStyle(
                              color: smarthireDark,
                              fontFamily: "mainfont",
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        color: smarthireWhite,
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ProductScreen(
                                          providerModel: providerModel,
                                        ))).then((value) {
                              Navigator.pop(context);
                              return null;
                            });
                          },
                          subtitle: Text(
                            "View product and see what it appears like in market",
                            style: TextStyle(
                                color: smarthireDark.withOpacity(0.5),
                                fontFamily: "mainfont"),
                          ),
                          title: Text(
                            "View",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: smarthireDark,
                                fontFamily: "mainfont"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => EditProductScreen(
                                        providerModel: providerModel,
                                      ))).then((value) {
                            Navigator.pop(context);
                            return null;
                          });
                        },
                        child: Card(
                          color: smarthireWhite,
                          child: ListTile(
                            subtitle: Text(
                              "Edit and update product details",
                              style: TextStyle(
                                  color: smarthireDark.withOpacity(0.5),
                                  fontFamily: "mainfont"),
                            ),
                            title: Text(
                              "Edit",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: smarthireDark,
                                  fontFamily: "mainfont"),
                            ),
                          ),
                        ),
                      ),
//                    SizedBox(
//                      height: 20.0,
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        RaisedButton(
//                            onPressed: () async {
//                              await Navigator.push(
//                                  context,
//                                  CupertinoPageRoute(
//                                      builder: (context) => ProductScreen(
//                                            providerModel: providerModel,
//                                          ))).then((value) {
//                                Navigator.pop(context);
//                                return null;
//                              });
//                            },
//                            child: Text(
//                              "View",
//                              style: TextStyle(
//                                  color: Colors.white, fontFamily: "mainfont"),
//                            ),
//                            color: smarthireDark),
//                        RaisedButton(
//                          onPressed: () async {
//                            await Navigator.push(
//                                context,
//                                CupertinoPageRoute(
//                                    builder: (context) => EditProductScreen(
//                                          providerModel: providerModel,
//                                        ))).then((value) {
//                              Navigator.pop(context);
//                              return null;
//                            });
//                          },
//                          child: Text(
//                            "Edit",
//                            style: TextStyle(
//                                color: Colors.white, fontFamily: "mainfont"),
//                          ),
//                          color: smarthireDark,
//                        ),
//                      ],
//                    )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  ListShow() {
    List<ProviderModel> providersList =
        filter == "" ? this.providersList : results;
    return new ListView.builder(
        itemCount: providersList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          ProviderModel providerModel=providersList[index];
          List<String> images = [];
          List<double> aspect_ratios = [];
          List<String> gallery = providerModel.product_gallery.split("#");
          List<String> ratios = providerModel.aspect_ratio.split("#");

          gallery.removeLast();
          ratios.removeLast();
          for (int i = 0; i < gallery.length; i++) {
            images.add(gallery[i]);
          }
          for (int i = 0; i < ratios.length; i++) {
            aspect_ratios.add(double.parse(ratios[i]));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () {
                ActionDialog(providersList[index]);
              },
              child: Card(
                color: Colors.white,
                elevation: 0.0,
                child: new ListTile(
                  leading: AspectRatio(
                    aspectRatio: 6 / 6,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),

                          image: DecorationImage(image: NetworkImage(global.fileserver+images[0]),fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  trailing: Text(
                    "RWF" + providersList[index].price,
                    style: TextStyle(
                        color: smarthireDark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "mainfont",
                        fontSize: 14.0),
                  ),
                  title: Text(
                    providersList[index].service_name,
                    style: TextStyle(
                        color: smarthireDark,
                        fontFamily: "mainfont",
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  subtitle: Text(
                    providersList[index].provider_name,
                    style: TextStyle(
                        color: smarthireDark.withOpacity(0.4),
                        fontFamily: "mainfont",
                        fontSize: 18.0),
                  ),
                ),
              ),
            ),
          );
        });
  }

  GridShow() {
    List<ProviderModel> providersList =
        filter == "" ? this.providersList : results;
    return GridView.builder(
        itemCount: providersList.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 6 / 6,
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 6.0),
        itemBuilder: (BuildContext context, int index) {
          ProviderModel providerModel=providersList[index];
          List<String> images = [];
          List<double> aspect_ratios = [];
          List<String> gallery = providerModel.product_gallery.split("#");
          List<String> ratios = providerModel.aspect_ratio.split("#");

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
              ActionDialog(providersList[index]);

//              Navigator.push(
//                  context,
//                  CupertinoPageRoute(
//                      builder: (context) => EditProductScreen(
//                            providerModel: providersList[index],
//                          )));
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
//                  height: height * 0.2,
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          image: DecorationImage(image: NetworkImage(global.fileserver+images[0]),fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // child: Center(
                      //   child: Icon(
                      //     Icons.photo,
                      //     size: 40.0,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ),
                  ),
                  AutoSizeText(
                    providersList[index].service_name,
                    maxLines: 2,
                    style: TextStyle(
                        color: smarthireDark,
                        fontFamily: "mainfont",
                        fontSize: 18.0),
                  ),
                  AutoSizeText(
                    providersList[index].provider_name,
                    maxLines: 1,
                    style: TextStyle(
                        color: smarthireDark.withOpacity(0.4),
                        fontFamily: "mainfont",
                        fontSize: 18.0),
                  )
                ],
              ),
            ),
          );
        });
  }

  DrawerWidget() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Text(
              "Filter Options",
              style: TextStyle(
                  fontFamily: "mainfont",
                  color: smarthireDark,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.location_on,
            size: 30.0,
          ),
          title: Text(
            'Location',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.category,
            size: 30.0,
          ),
          title: Text(
            'Service/Product',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            size: 30.0,
          ),
          title: Text(
            'Provider',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.shutter_speed,
            size: 30.0,
          ),
          title: Text(
            'Availability',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {},
        ),
      ],
    ));
  }

  //getats
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
