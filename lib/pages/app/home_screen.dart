import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info/device_info.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:smarthire/src/elements/AdvertShimmer.dart';
import 'package:smarthire/components/DrawerWidget.dart';
import 'package:smarthire/components/Popularproducts.dart';
import 'package:smarthire/components/ServicesListScreen.dart';
import 'package:smarthire/components/ServicesShimmer.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/NotificationModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';

import 'package:smarthire/model/slider.dart';
import 'package:smarthire/notifications/FcmNotifications.dart';
import 'package:smarthire/pages/auth/account.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/jobs/JobsScreen.dart';
import 'package:smarthire/pages/marketplace/MarketPlace.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/providers/CategoryScreen.dart';
import 'package:smarthire/pages/providers/NewService.dart';
import 'package:smarthire/pages/search/SearchScreen.dart';
import 'package:smarthire/pages/transactions/TransactionScreen.dart';
import 'package:http/http.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreenCustomer extends StatefulWidget {
  @override
  _HomeScreenCustomerState createState() => _HomeScreenCustomerState();
}

class _HomeScreenCustomerState extends State<HomeScreenCustomer> {
  bool loading = false;
  bool _ploading = false;
  var currentPage = 1;
  var width;
  bool visible = false;
  BuildContext _context;
  var height;
  final key = new GlobalKey<ScaffoldState>();
  final _controller = FadeInController();
  int _currentIndex = 1;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  List<Widget> screens;

  @override
  void initState() {
    getSliders();
    getServices();
    getDeviceDetails();
    getPopularproducts();
    getPopularServices();
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Search() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 8.0),
      child: VisibilityDetector(
        key: Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          debugPrint(
              'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');

          if (visiblePercentage > 80) {
            setState(() {
              visible = true;
            });
          } else {
            setState(() {
              visible = false;
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * 0.83,
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
            ),
            Icon(
              Icons.add_circle,
              size: 40.0,
              color: smarthireBlue,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _context = context;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: key,
        backgroundColor: global.darkmode?Colors.black:smarthireWhite,
        drawer: DrawerWidget(key, context),
        endDrawer: ServicesListScreen(),

//      appBar: CustomAppBar(
//        height: height*0.15,
//
//        child: SafeArea(
//
//        child: Row(
//
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//          children: [
//          InkWell(
//            onTap: (){
//                Navigator.push(
//                  context,
//                  PageRouteBuilder(
//                    transitionDuration: Duration(seconds: 1),
//                    pageBuilder: (_, __, ___) =>
//                        global.id==0?LoginPage(
//                        ):Account(),
//                  ),
//                );
//
//            },
//            child: CircleAvatar(
//                backgroundColor: smarthireWhite,
//
//                child: Icon(Icons.person,size: 40.0,color:smarthireBlue,)),
//          ),
//
//          Image.asset(
//                  'assets/logo-white.png',
//                  width: 45,
//                ),
//
//          Padding(
//            padding: const EdgeInsets.only(right:8.0),
//            child: CircleAvatar(
//              backgroundColor: smarthireWhite,
//              child: Badge(
//                badgeContent: Text('3'),
//                badgeColor: smarthireYellow,
//                child: Icon(
//                        Icons.notifications,
//                        color: smarthireBlue,
//                        size: 38.0,
//                      ),
//              ),
//            ),
//          )
//
//        ],),
//      ),),

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
                          return key.currentState.openDrawer();
                        },
                        child: Icon(
                          Icons.sort,
                          color: smarthireDark,
                          size: 30.0,
                        ),
                      ),
                      Text(
                        "SmartHire",
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
                          child: Icon(Icons.category,
                              size: 30.0, color: smarthireDark),
                        ),
                      )

//                    Padding(
//                      padding: const EdgeInsets.only(top: 8.0),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: [
//                          !visible
//                              ? Padding(
//                                  padding: const EdgeInsets.only(right: 38.0),
//                                  child: FadeIn(
//                                      duration: Duration(seconds: 2),
//                                      child: InkWell(
//                                        onTap: () {
//                                          Navigator.push(
//                                              context,
//                                              SlideRightRoute(
//                                                  page: global.id == 0
//                                                      ? LoginPage()
//                                                      : SearchScreen()));
//                                        },
//                                        child: Container(
//                                          decoration: BoxDecoration(
//                                            shape: BoxShape.circle,
//                                            color: Color(0xff05ebf5)
//                                                .withOpacity(0.3),
//                                          ),
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(8.0),
//                                            child: Icon(
//                                              Icons.search,
//                                              size: 30.0,
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                        ),
//                                      )),
//                                )
//                              : Text(""),
//                          !visible
//                              ? Padding(
//                                  padding: const EdgeInsets.only(right: 38.0),
//                                  child: FadeIn(
//                                      duration: Duration(seconds: 2),
//                                      child: InkWell(
//                                          onTap: () {
//                                            if (global.id == 0) {
//                                              Navigator.push(
//                                                  context,
//                                                  SlideRightRoute(
//                                                      page: LoginPage()));
//                                            } else {
//                                              Navigator.push(
//                                                  context,
//                                                  SlideRightRoute(
//                                                      page:
//                                                          NewServiceScreen()));
//                                            }
//                                          },
//                                          child: Container(
//                                            decoration: BoxDecoration(
//                                              shape: BoxShape.circle,
//                                              color: Color(0xff05ebf5)
//                                                  .withOpacity(0.3),
//                                            ),
//                                            child: Padding(
//                                              padding:
//                                                  const EdgeInsets.all(8.0),
//                                              child: Icon(
//                                                Icons.add,
//                                                size: 30.0,
//                                                color: Colors.white,
//                                              ),
//                                            ),
//                                          ))),
//                                )
//                              : Text(""),
//                          visible
//                              ? Padding(
//                                  padding: const EdgeInsets.only(right: 38.0),
//                                  child: Icon(
//                                    Icons.notifications,
//                                    size: 30.0,
//                                    color: smarthireBlue,
//                                  ),
//                                )
//                              : Text(""),
//                          InkWell(
//                            onTap: () {
//                              Navigator.push(
//                                context,
//                                PageRouteBuilder(
//                                  transitionDuration: Duration(seconds: 1),
//                                  pageBuilder: (_, __, ___) =>
//                                      global.id == 0 ? LoginPage() : Account(),
//                                ),
//                              );
//                            },
//                            child: Container(
//                              decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                color: Color(0xff05ebf5).withOpacity(0.3),
//                              ),
//                              child: Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Center(
//                                  child: Icon(
//                                    Icons.person,
//                                    size: 30.0,
//                                    color: Colors.white,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    )
                    ],
                  ),
                ),
//      SizedBox(height: height*0.03,),
//SliderWidget(),
//      SizedBox(height: height*0.03,),
//      Search()
              ],
            ),
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            OrderScreen(),
            body(),
//          JobsScreen(),
            TransactionScreen(),
          ],
        ),

        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: global.darkmode?Colors.black:Colors.white,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.red,
              iconTheme: IconThemeData(size: 28.0),
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.yellow))),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(size: 28),
            selectedItemColor: smarthireBlue,
            unselectedItemColor: Colors.grey.withOpacity(0.7),

            onTap: onTabTapped,
            // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.shop),
                title: new Text(''),
              ),
              BottomNavigationBarItem(
                icon: Container(
                    decoration: BoxDecoration(
                        color: smarthireBlue, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )),
                title: new Text(''),
              ),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.work), title: Text('Jobs')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card), title: Text(''))
            ],
          ),
        ),
//        floatingActionButton: FloatingActionButton.extended(
//          onPressed: () {},
//          icon: Icon(Icons.work),
//          label: Text("Offer a Service"),
//          backgroundColor: smarthireBlue,
//        ),
//        bottomNavigationBar: FancyBottomNavigation(
//          tabs: [
//            TabData(iconData: Icons.home, title: "Home"),
//            TabData(iconData: Icons.shopping_basket, title: "My Orders"),
//            TabData(iconData: Icons.work, title: "My Jobs"),
//            TabData(iconData: Icons.credit_card, title: "Transactions")
//          ],
//          onTabChangedListener: (position) {
//            setState(() {
//              currentPage = position;
//            });
//          },
//          activeIconColor: smarthireBlue,
//          inactiveIconColor: smarthireWhite,
//          barBackgroundColor: smarthireBlue,
//          circleColor: smarthireWhite,
//          textColor: smarthireWhite,
//        )
      ),
    );
  }

  Header() {
    return Column(
      children: [
        SliderWidget(),
      ],
    );
  }

  Thebody() {
    return height == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: height,
            width: width,
            child: Column(
              children: <Widget>[
                Flexible(
                    child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      title: Text(""),
                      backgroundColor: Colors.white.withOpacity(0.7),
                      expandedHeight: height * 0.25,
                      pinned: false,
                      leading: Text(""),
                      flexibleSpace: Header(),
//            FlexibleSpaceBar(
//              background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
//            ),
                    ),
//                    SliverPersistentHeader(
//                      delegate: SectionHeaderDelegate("Section B"),
//                      pinned: true,
//                    ),
                    SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 0),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      page: CategoryScreen(
                                        serviceModel: global.services[index],
                                      ),
                                    ));
//                                  Navigator.push(
//                                    context,
//                                    PageRouteBuilder(
//                                      transitionDuration: Duration(seconds: 1),
//                                      pageBuilder: (_, __, ___) =>
//                                          CategoryScreen(
//                                            serviceModel: global.services[index],
//                                          ),
//                                    ),
//                                  );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: smarthireBlue,
//                                  color: Colors
//                                      .red, //                   <--- border color
                                    width: 0.7,
                                  ),
//                                color: Color(0xff05ebf5).withOpacity(0.3),
                                ),
                                child: new Card(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                          image: NetworkImage(
                                              global.services[index].banner),
                                          height: 80.0,
                                          width: 80.0,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        }, childCount: global.services.length)),
                  ],
                )),
              ],
            ),
          );
  }

  //all widgets
  SliderWidget() {
    return Container(
      child: CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            aspectRatio: 3 / 2,
            height: height * 0.25,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          itemCount: global.sliders.length,
          itemBuilder: (BuildContext context, itemIndex) {
            return Container(
              height: height * 0.25,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          global.fileserver + sliders[itemIndex].url),
                      fit: BoxFit.fill),
                ),
              ),
            );
          }),
    );
  }

  body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          global.sliders.length < 1
              ? AdvertShimmer(width, height * 0.25)
              : SliderWidget(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Popular Services",
                style: TextStyle(
                    fontFamily: "mainfont",
                    fontSize: 20.0,
                    color: smarthireDark,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  return key.currentState.openEndDrawer();
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                      fontFamily: "mainfont",
                      fontSize: 16.0,
                      color: smarthireDark,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          global.popularservices.length < 1
              ? ServiceShimmer(width, height * 0.3)
              : PopularProducts(
                  global.popularservices, width, height * 0.3, context),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Popular Products",
                style: TextStyle(
                    fontFamily: "mainfont",
                    fontSize: 20.0,
                    color: smarthireDark,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  return key.currentState.openEndDrawer();
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                      fontFamily: "mainfont",
                      fontSize: 16.0,
                      color: smarthireDark,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          global.popularservices.length < 1
              ? ServiceShimmer(width, height * 0.3)
              : PopularProducts(
                  global.popularproducts, width, height * 0.3, context),
        ],
      ),
    );
  }

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

  getPopularproducts() async {
    global.popularproducts.clear();

    setState(() {
      _ploading = true;
    });
    var path = "/api/popularproducts";
    var response = await get(url + path);

    print("popularproducts" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        ProviderModel providerModel = ProviderModel.fromJson(list[i]);
        providerModel.profile_pic =
            global.fileserver + providerModel.profile_pic;
        setState(() {
          global.popularproducts.add(providerModel);
        });
      }
    } else {}

    setState(() {
      _ploading = false;
    });
  }

  getPopularServices() async {
    global.popularservices.clear();

    setState(() {
      _ploading = true;
    });
    var path = "/api/popularservices";
    var response = await get(url + path);
    print("popularservices" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        ProviderModel providerModel = ProviderModel.fromJson(list[i]);
        providerModel.profile_pic =
            global.fileserver + providerModel.profile_pic;
        setState(() {
          global.popularservices.add(providerModel);
        });
      }
    } else {}

    setState(() {
      _ploading = false;
    });
  }

  void getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;

        global.deviceName = deviceName;
        global.identifier = identifier;
        global.deviceVersion = deviceVersion;

        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
        global.deviceName = deviceName;
        global.identifier = identifier;
        global.deviceVersion = deviceVersion;
        //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    init();
//if (!mounted) return;
  }

  Future<void> init() async {
    _firebaseMessaging.requestNotificationPermissions();

    if (!global.initialized) {
      // For iOS request permission first.

      Future.delayed(Duration(seconds: 1), () {
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");

            setState(() {
              global.unseennotifications += 1;
              global.personalnotifications.add(new NotificationModel(
                  action_id: int.parse(message['data']['action_id']),
                  title: message['notification']['title'],
                  body: message['notification']['body'],
                  seen: 0,
                  user_id: 0));
            });

//            AudioCache player = AudioCache(prefix: 'assets/sounds/');
//            player.play('sound.mp3', volume: 1.0);
            AudioCache _audioCache = AudioCache(
                prefix: "sounds/",
                fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

            _audioCache.play('sound.mp3');

            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              reverseAnimationCurve: Curves.decelerate,
              forwardAnimationCurve: Curves.elasticOut,
              flushbarStyle: FlushbarStyle.FLOATING,
              backgroundColor: smarthireBlue,
//            message:
//                "Lorem Ipsum is simply dummy text of the printing and typesetting industry",

              titleText: Text(
                message['notification']['title'],
                style: TextStyle(color: Colors.white),
              ),
              dismissDirection: FlushbarDismissDirection.HORIZONTAL,
              isDismissible: true,
              messageText: Text(
                message['notification']['body'],
                style: TextStyle(color: Colors.white),
              ),

              icon: Icon(
                Icons.notifications,
                size: 28.0,
                color: Colors.white,
              ),
              duration: Duration(seconds: 6),
              leftBarIndicatorColor: Colors.blue[300],
            )..show(context);

//          showAlertDialog(context);

//          _showItemDialog(message);
          },
          onBackgroundMessage: global.myBackgroundMessageHandler,
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            navigatorKey.currentState.push(MaterialPageRoute(
                builder: (_) => FcmNotifications(
                      map: message,
                    )));
//
//            Navigator.push(§§
//                context, SlideRightRoute(page: NotificationScreen()));

//          showAlertDialog(context);
//          Navigator.push(context, SlideRightRoute(page: NotificationScreen()));
//          _navigateToItemDetail(message);
          },
          onResume: (Map<String, dynamic> message) async {
            navigatorKey.currentState.push(MaterialPageRoute(
                builder: (_) => FcmNotifications(
                      map: message,
                    )));
            print("onResume: $message");
//            Navigator.push(
//                context, SlideRightRoute(page: NotificationScreen()));

//          showAlertDialog(context);

//          Navigator.push(context, SlideRightRoute(page: NotificationScreen()));
//          _navigateToItemDetail(message);
          },
        );

        // For testing purposes print the Firebase Messaging token

        global.initialized = true;
      });
    }
    String token = await _firebaseMessaging.getToken();
    global.RegisterToken(token);

    _firebaseMessaging.subscribeToTopic("generalnotifications");

    print("FirebaseMessaging token: $token");

    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ token: $token");
  }
}

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;
  CustomAppBar({@required this.child, this.height = kToolbarHeight});
  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: child,
    );
  }
}
