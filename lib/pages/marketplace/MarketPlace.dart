import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/model/service.dart';
import 'package:smarthire/model/slider.dart';
import 'package:smarthire/notifications/PersonalNotifications.dart';
import 'package:smarthire/pages/providers/AddProduct.dart';
import 'package:smarthire/pages/providers/SeeAllScreen.dart';
import 'package:smarthire/pages/providers/SingleProviderScreen.dart';
import 'package:http/http.dart';

class MarketPlace extends StatefulWidget {
  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  bool loading = false;
  bool _ploading = false;
  var currentPage = 0;
  var width;

  List<ServiceModel> searchresults = [];

  String searchtext;
  var height;
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  // List<SearchResult> _list;
  bool _IsSearching;
  String _searchText = "";
  String selectedSearchValue = "";

  @override
  void initState() {
    init();

    getServices();
    getProviders();
    getSliders();
    super.initState();
  }

  Search() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 8.0),
      child: TextField(
        enabled: false,
//            controller: searchController,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(
                const Radius.circular(20.0),
              ),
            ),
            filled: true,
            contentPadding: EdgeInsets.all(4),
            prefixIcon: Icon(Icons.search),
            hintStyle: new TextStyle(color: smarthireBlue),
            hintText: "Search",
            fillColor: Color(0xffdddddd)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
//        floatingActionButton: FloatingActionButton.extended(
//          onPressed: () {
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => AddProductScreen()));
//
//          },
//          icon: Icon(Icons.shopping_basket_outlined),
//          label: Text("Add to Market",style: TextStyle(fontFamily: 'sans'),),
//          backgroundColor: smarthireBlue,
//        ),
      backgroundColor: Color(0xffddddd),
//        body:

      body: body(),
    );
  }

  Thebody() {
    return Column(
      children: <Widget>[
//            Search(),
        Flexible(
            child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                title: Text(""),
                backgroundColor: Colors.white.withOpacity(0.7),
                expandedHeight: height * 0.3,
                pinned: false,
                leading: Text(""),
                flexibleSpace: SliderWidget()

//            FlexibleSpaceBar(
//              background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
//            ),
                ),
            SliverPersistentHeader(
              delegate: SectionHeaderDelegate("Section B"),
              pinned: true,
            ),
            SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return new Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: AutoSizeText(
                            global.services[index].service_name,
                            style: TextStyle(
                                color: Color(0xff006064),
                                fontFamily: "sans",
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                          )),
                          Image(
                            image: NetworkImage(global.services[index].banner),
                            height: 80.0,
                            width: 80.0,
                          ),
                        ],
                      ));
                }, childCount: global.services.length)),
          ],
        )),
      ],
    );
  }

  body() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: global.services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 6 / 6),
          itemBuilder: (BuildContext context, int index) {
            return Card(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: AutoSizeText(
                      global.services[index].service_name,
                      style: TextStyle(
                          color: Color(0xff006064),
                          fontFamily: "sans",
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                    )),
                    Image(
                      image: NetworkImage(global.services[index].banner),
                      height: 80.0,
                      width: 80.0,
                    ),
                  ],
                ));
          },
        ));
  }

  providers(int id) {
    List<ProviderModel> providersList = global.providers
        .where((i) => i.category_id.toString() == id.toString())
        .toList();

    print("providersList");
    print(providersList);
    return Container(
//      height: height*0.2,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: providersList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Container(
              height: height * 0.2,
              child: providerCard(providersList[index], index),
            );
          }),
    );
  }

  providerCard(ProviderModel providerModel, int index) {
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
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (_, __, ___) => SingleProviderScreen(
              index: index,
              providerModel: providerModel,
            ),
          ),
        );
      },
      child: Container(
        height: height * 0.2,
        width: width * 0.4,
        child: Stack(
          children: [
            Card(
              child: Container(
                height: height * 0.19,
                decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                        image: NetworkImage(
                          global.fileserver + images[0],
                        ),
                        fit: BoxFit.fitHeight),
                    border: Border.all(color: Colors.blueAccent)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                width: width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      providerModel.service_name,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "sans"),
                    ),
                    AutoSizeText(
                      providerModel.currency + providerModel.price,
                      maxLines: 1,
                      style: TextStyle(fontFamily: "sans"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //all widgets
  SliderWidget() {
    return global.sliders.length < 1
        ? Container(
            height: height * 0.3,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : Container(
            height: height * 0.3,
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3 / 2,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: global.sliders.length,
                itemBuilder: (BuildContext context, itemIndex) {
                  print("The Link :" +
                      global.fileserver +
                      global.sliders[itemIndex].url);
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              global.fileserver + sliders[itemIndex].url),
                          fit: BoxFit.cover),
                    ),
                  );
                }),
          );
  }

  //all API calls
  getServices() async {
    global.services.clear();
    setState(() {
      loading = true;
    });
    var path = "/api/services";
    var response = await get(url + path);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        ServiceModel serviceModel = ServiceModel.fromJson(list[i]);
        global.services.add(serviceModel);
      }
    } else {}

    setState(() {
      loading = false;
    });
  }

  getSliders() async {
    global.sliders.clear();
    var path = "/api/sliders";
    var response = await get(url + path);
    print("link:" + url + path);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        SliderModel sliderModel = SliderModel.fromJson(list[i]);
        global.sliders.add(sliderModel);
      }
    }
  }

  getProviders() async {
    global.providers.clear();

    setState(() {
      _ploading = true;
    });
    var path = "/api/providers";
    var response = await get(url + path);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        ProviderModel providerModel = ProviderModel.fromJson(list[i]);
        providerModel.profile_pic =
            global.fileserver + providerModel.profile_pic;
        global.providers.add(providerModel);
      }
    } else {}

    setState(() {
      _ploading = false;
    });
  }

  requestpermission(flutterLocalNotificationsPlugin) async {
    var result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  init() async {
    global.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await global.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

    requestpermission(global.flutterLocalNotificationsPlugin);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  show(String body, String title) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await global.flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "magwenzi");
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleNotification(
                payload: payload,
              )),
    );
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  SectionHeaderDelegate(this.title, [this.height = 50]);
  double heightt;
  double width;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    width = MediaQuery.of(context).size.width;
    heightt = MediaQuery.of(context).size.height;
    return Headerbar();
  }

  Headerbar() {
    return Container(
      color: Colors.white.withOpacity(0.6),

//      height: heightt * 0.07,
      width: width,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Market Place".toUpperCase(),
              style: TextStyle(
                  fontFamily: "sans",
                  color: smarthireBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ],
      )),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
