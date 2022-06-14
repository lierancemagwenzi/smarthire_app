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
import 'package:smarthire/pages/services/ProductScreen.dart';

class CategoriesScreen extends StatefulWidget {
  ServiceModel serviceModel;

  CategoriesScreen({@required this.serviceModel});
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final key = new GlobalKey<ScaffoldState>();
  double height;
  double width;
  bool loading = false;

  bool showfiltergrid = false;
  String filtertype;
  String currentrprovider = "";
  String city = "";
  String product_type = '';
  int provider = 0;
  String selectedlocation;
  ProviderModel selectedProvider;

  bool grid = false;
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
      backgroundColor: global.darkmode?Colors.black:Colors.white,

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
                      "Category",
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
              widget.serviceModel.service_name,
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

  ListShow() {
    List<ProviderModel> providersList = [];

    List<ProviderModel> providersList1 =
        filter == "" ? this.providersList : results;
    providersList = providersList1;
    if (city == "" && selectedProvider == null && product_type == "") {
      providersList = providersList1;
    } else {
      if (city != "") {
        providersList = providersList.where((i) => i.city == city).toList();
      }
      if (product_type != "") {
        providersList =
            providersList.where((i) => i.product_type == product_type).toList();
      }

      if (selectedProvider != null) {
        providersList = providersList
            .where((i) => i.provider_id == selectedProvider.provider_id)
            .toList();
      }
    }
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
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ProductScreen(
                              providerModel: providersList[index],
                            )));
              },
              child: Card(
                color: global.darkmode?Colors.black:Colors.white,

                elevation: 0.0,
                child: new ListTile(
                  leading: AspectRatio(
                    aspectRatio: 6 / 6,
                    child: Container(
                      decoration: BoxDecoration(

                        image: DecorationImage(image: NetworkImage(global.fileserver+images[0]),fit: BoxFit.fitWidth),
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
    List<ProviderModel> providersList = [];

    List<ProviderModel> providersList1 =
        filter == "" ? this.providersList : results;
    providersList = providersList1;
    if (city == "" && selectedProvider == null && product_type == "") {
      providersList = providersList1;
    } else {
      if (city != "") {
        providersList = providersList.where((i) => i.city == city).toList();
      }
      if (product_type != "") {
        providersList =
            providersList.where((i) => i.product_type == product_type).toList();
      }

      if (selectedProvider != null) {
        providersList = providersList
            .where((i) => i.provider_id == selectedProvider.provider_id)
            .toList();
      }
    }

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
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ProductScreen(
                            providerModel: providersList[index],
                          )));
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),

                          image: DecorationImage(image: NetworkImage(global.fileserver+images[0]),fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
//                  height: height * 0.2,
                      width: width,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Filter Options",
                  style: TextStyle(
                      fontFamily: "mainfont",
                      color: smarthireDark,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              city.length > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "city= " + city,
                          style: TextStyle(
                              color: smarthireDark, fontFamily: "maiinfont"),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              city = "";
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: smarthireDark,
                          ),
                        )
                      ],
                    )
                  : Text(""),
              currentrprovider.length > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Provider= " + currentrprovider,
                            style: TextStyle(
                                color: smarthireDark, fontFamily: "maiinfont")),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedProvider = null;
                              currentrprovider = "";
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: smarthireDark,
                          ),
                        )
                      ],
                    )
                  : Text(""),
              product_type.length > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Providuct type= " + product_type,
                            style: TextStyle(
                                color: smarthireDark, fontFamily: "maiinfont")),
                        InkWell(
                          onTap: () {
                            setState(() {
                              product_type = "";
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: smarthireDark,
                          ),
                        )
                      ],
                    )
                  : Text(""),
              SizedBox(
                height: 5.0,
              ),
              city.length > 0 ||
                      currentrprovider.length > 0 ||
                      product_type.length > 0
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          city = "";
                          currentrprovider = "";
                          selectedProvider = null;
                          product_type = "";
                          filtertype = "";
                          showfiltergrid = false;
                        });
                      },
                      child: Text("Clear all Filters"))
                  : Text("")
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
        determineWidget()
      ],
    ));
  }

  determineWidget() {
    if (showfiltergrid) {
      if (filtertype == "location") {
        return LocationFilter();
      } else if (filtertype == "product_type") {
        return ProductTypeFilter();
      } else if (filtertype == "provider") {
        return ProviderFilter();
      } else {
        return Container();
      }
    } else {
      return AllFilters();
    }
  }

  AllFilters() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
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
            setState(() {
              showfiltergrid = true;
              filtertype = "location";
            });
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
          onTap: () {
            setState(() {
              showfiltergrid = true;
              filtertype = "product_type";
            });
          },
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
          onTap: () {
            setState(() {
              showfiltergrid = true;
              filtertype = "provider";
            });
          },
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
    );
  }

  LocationFilter() {
    List<String> locations = [];
    List<String> chosen = [];
    for (int i = 0; i < providersList.length; i++) {
      if (!chosen.contains(providersList[i].city)) {
        locations.add(providersList[i].city);
        chosen.add(providersList[i].city);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
            onTap: () {
              setState(() {
                filtertype = null;
                showfiltergrid = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.cancel,
                color: smarthireDark,
                size: 30.0,
              ),
            )),
        SizedBox(
          height: 10.0,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: locations.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedlocation = locations[index];
                    city = locations[index];
                  });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(title: new Text(locations[index])),
                  ),
                ),
              );
            }),
      ],
    );
  }

  ProviderFilter() {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
            onTap: () {
              setState(() {
                filtertype = null;
                showfiltergrid = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.cancel,
                color: smarthireDark,
                size: 30.0,
              ),
            )),
        SizedBox(
          height: 10.0,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
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
                            currentrprovider = selectedProvider.provider_name;
                          });
                        },
                        leading: CircleAvatar(
                          backgroundColor: smarthireBlue,
                          backgroundImage:
                              NetworkImage(providers[index].profile_pic),
                        ),
                        title: new Text(providers[index].provider_name)),
                  ));
            }),
      ],
    );
  }

  ProductTypeFilter() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        InkWell(
            onTap: () {
              setState(() {
                filtertype = null;
                showfiltergrid = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.cancel,
                color: smarthireDark,
                size: 30.0,
              ),
            )),
        SizedBox(
          height: 10.0,
        ),
        ListTile(
          onTap: () {
            setState(() {
              product_type = "service";
            });
          },
          title: Text(
            "Service",
            style: TextStyle(
                color: smarthireDark, fontFamily: "mainfont", fontSize: 16.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        ListTile(
          onTap: () {
            setState(() {
              product_type = "product";
            });
          },
          title: Text(
            "Product",
            style: TextStyle(
                color: smarthireDark, fontFamily: "mainfont", fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  //getats
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
