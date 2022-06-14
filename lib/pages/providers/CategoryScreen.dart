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

class CategoryScreen extends StatefulWidget {
  ServiceModel serviceModel;

  CategoryScreen({@required this.serviceModel});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  double height;
  double width;
  String selectedlocation;
  ProviderModel selectedProvider;
  bool showfilter = true;
  TextEditingController searchcontroller = new TextEditingController();
  bool showsearch = false;
  String filter = "";
  bool loading = false;
  int _selectedIndex = 0;

  List<ProviderModel> results = [];

  List<ProviderModel> providersList = [];
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
                          filter = "";
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              )
            : AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showsearch = true;
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (showfilter) {
                            showfilter = false;
                          } else {
                            showfilter = true;
                          }
                        });
                      },
                      child: Icon(
                        filtericon.MyFlutterApp.filter,
                        color: showfilter ? Colors.white : Colors.grey,
                        size: 30.0,
                      ),
                    ),
                  )
                ],
                backgroundColor: smarthireBlue,
                title: Text(
                  widget.serviceModel.service_name,
                  style: TextStyle(color: Colors.white),
                ),
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
        body: !showfilter
            ? body()
            : Row(
                children: <Widget>[
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.selected,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.list,
                          color: smarthireBlue,
                        ),
                        selectedIcon: Icon(
                          Icons.list,
                          color: smarthireBlue,
                        ),
                        label: Text(
                          'All',
                          style: TextStyle(color: smarthireBlue),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.location_on,
                          color: smarthireBlue,
                        ),
                        selectedIcon:
                            Icon(Icons.location_on, color: smarthireBlue),
                        label: Text(
                          'location',
                          style: TextStyle(color: smarthireBlue),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person, color: smarthireBlue),
                        selectedIcon: Icon(Icons.person, color: smarthireBlue),
                        label: Text(
                          'Provider',
                          style: TextStyle(color: smarthireBlue),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(services.MyFlutterApp.cargo,
                            color: smarthireBlue),
                        selectedIcon: Icon(services.MyFlutterApp.cargo,
                            color: smarthireBlue),
                        label: Text(
                          'products',
                          style: TextStyle(color: smarthireBlue),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(services.MyFlutterApp.service,
                            color: smarthireBlue),
                        selectedIcon: Icon(services.MyFlutterApp.service,
                            color: smarthireBlue),
                        label: Text(
                          'services',
                          style: TextStyle(color: smarthireBlue),
                        ),
                      )
                    ],
                  ),
                  VerticalDivider(thickness: 1, width: 1),
                  // This is the main content.
                  Expanded(
                    child: _selectedIndex == 0
                        ? body()
                        : _selectedIndex == 3
                            ? ProductsView()
                            : _selectedIndex == 4
                                ? Services()
                                : _selectedIndex == 1
                                    ? (selectedlocation == null
                                        ? Locations()
                                        : Location())
                                    : (selectedProvider == null
                                        ? Providers()
                                        : Provider()),
                  )
                ],
              )

//        loading ? Center(child: CircularProgressIndicator()) : body()

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

  Location() {
    List<ProviderModel> providersList = this
        .providersList
        .where((site) => site.city.contains(selectedlocation))
        .toList();

    return Column(
      children: <Widget>[
        ListTile(
            trailing: InkWell(
                onTap: () {
                  setState(() {
                    selectedlocation = null;
                  });
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                )),
            title: Text(selectedlocation)),
        Flexible(
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
              }),
        ),
      ],
    );
  }

  Locations() {
    List<String> locations = [];

    List<String> chosen = [];
//    for (int i = 0; i < providersList.length; i++) {
//      List<String> items = providersList[i].location.split(",");
//      if (items.length == 1 && !chosen.contains(items[0])) {
//        locations.add(items[0]);
//        chosen.add(items[0]);
//      } else if (items.length == 2 && !chosen.contains(items[0])) {
//        locations.add(items[0]);
//        chosen.add(items[0]);
//      } else if (items.length == 3 && !chosen.contains(items[1])) {
//        locations.add(items[1]);
//        chosen.add(items[1]);
//      } else if (items.length == 4 && !chosen.contains(items[2])) {
//        locations.add(items[2]);
//        chosen.add(items[3]);
//      } else if (items.length == 5 && !chosen.contains(items[3])) {
//        locations.add(items[2]);
//        chosen.add(items[2]);
//      } else {
//        locations.add(locations[i]);
//        chosen.add(locations[i]);
//      }
//    }

    for (int i = 0; i < providersList.length; i++) {
      if (!chosen.contains(providersList[i].city)) {
        locations.add(providersList[i].city);
        chosen.add(providersList[i].city);
      }
    }

    return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedlocation = locations[index];
              });
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(title: new Text(locations[index])),
              ),
            ),
          );
        });
  }

  Provider() {
    List<ProviderModel> providersList = this
        .providersList
        .where((site) => site.provider_id == selectedProvider.provider_id)
        .toList();

    return Column(
      children: <Widget>[
        ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(selectedProvider.profile_pic),
              backgroundColor: smarthireBlue,
            ),
            trailing: InkWell(
                onTap: () {
                  setState(() {
                    selectedProvider = null;
                  });
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                )),
            title: Text(selectedProvider.provider_name)),
        Flexible(
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
              }),
        ),
      ],
    );
  }

  Providers() {
    List<ProviderModel> providers = [];
    List<int> chosen = [];
    for (int i = 0; i < providersList.length; i++) {
      if (!chosen.contains(providersList[i].provider_id)) {
        providers.add(new ProviderModel(
            provider_id: providersList[i].provider_id,
            provider_name: providersList[i].provider_name,
            profile_pic: providersList[i].profile_pic));
        chosen.add(providersList[i].provider_id);
      }
    }

    return ListView.builder(
        itemCount: providers.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    onTap: () {
                      setState(() {
                        selectedProvider = providers[index];
                      });
                    },
                    leading: CircleAvatar(
                      backgroundColor: smarthireBlue,
                      backgroundImage:
                          NetworkImage(providers[index].profile_pic),
                    ),
                    title: new Text(providers[index].provider_name)),
              ));
        });
  }

  body() {
    List<ProviderModel> providersList =
        filter == "" ? this.providersList : results;
    return new ListView.builder(
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(providersList[index].location),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              providersList[index].product_type,
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              providersList[index].provider_name,
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
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

  @override
  void initState() {
    getProducts();
    SearchProducts();
    super.initState();
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

  getProducts() async {
    setState(() {
      loading = true;
    });
    var path = "/api/products/" + widget.serviceModel.id.toString();
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
