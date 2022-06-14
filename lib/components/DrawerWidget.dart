import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/model/ProductUploadModel.dart';
import 'package:smarthire/notifications/AllNotifications.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/orders/AllOrdersScreen.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/productadd/FirstScreen.dart';
import 'package:smarthire/pages/providers/NewService.dart';
import 'package:smarthire/pages/providers/account/ProductListing.dart';
import 'package:smarthire/pages/registration/LoginScreen.dart';
import 'package:smarthire/pages/services/AccountProducts.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

DrawerWidget(GlobalKey<ScaffoldState> parentScaffold, BuildContext context) {

  Color textcolor=globals.darkmode?Colors.white: Color(0xff043832);
  return Drawer(

      child: Container(
        child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
        DrawerHeader(
          child: globals.id == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        color: smarthireBlue,
                        textColor: Colors.white,
                        child: Text("Sign  In",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "mainfont")),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: smarthireBlue,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      globals.name,
                      style: TextStyle(
                          fontFamily: "mainfont",
                          color: textcolor,
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      globals.mobile,
                      style: TextStyle(
                          fontFamily: "mainfont",
                          color: textcolor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w200),
                    )
                  ],
                ),
          decoration: BoxDecoration(
            color: globals.darkmode?Colors.black:Colors.grey.withOpacity(0.15),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            size: 30.0,
          ),
          title: Text(
            'Home',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.notifications,
            size: 30.0,
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {

            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => AllNotifications()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.shop,
            size: 30.0,
          ),
          title: Text(
            'My Orders',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {

            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => AllOrdersScreen()));

          },
        ),
        ListTile(
          leading: Icon(
            Icons.messenger_outline,
            size: 30.0,
          ),
          title: Text(
            'Messages',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            Toast.show("Coming Soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

          },
        ),
        ListTile(
          leading: Icon(
            Icons.favorite,
            size: 30.0,
          ),
          title: Text(
            'Favorite Products',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            Toast.show("Coming Soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);

          },
        ),
        ListTile(
          leading: Icon(
            Icons.view_list,
            size: 30.0,
          ),
          title: Text(
            'My Listings',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => AccountProducts()));
          },
        ),

        ListTile(
          leading: Icon(
            Icons.add_circle,
            size: 30.0,
          ),
          title: Text(
            'Add a Product',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            globals.productUploadModel=new ProductUploadModel();
            globals.productUploadModel.product_type="Product";
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => FirstScreen()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.add_circle,
            size: 30.0,
          ),
          title: Text(
            'Add a Service',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            globals.productUploadModel=new ProductUploadModel();
            globals.productUploadModel.product_type="Service";
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => FirstScreen()));
          },
        ),
        ListTile(
          title: Text(
            'Application Preferences',
            style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontFamily: "mainfont",
                fontSize: 16.0),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            size: 30.0,
          ),
          title: Text(
            globals.darkmode?'Light Mode':'Dark Mode',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
          globals.darkmode=!globals.darkmode;
          if(globals.darkmode){
            smarthireDark=Colors.white;
          }
          else{
            smarthireDark = Color(0xff043832);

          }

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreenCustomer()));
            // Toast.show("Coming Soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          }
          ,
        ),
        ListTile(
          leading: Icon(
            Icons.power_settings_new,
            size: 30.0,
          ),
          title: Text(
            globals.id == 0 ? "Sign In" : 'Logout',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            if (globals.id == 0) {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => LoginScreen()));
            } else {
              Logout(context);
            }
          },
        ),
    ],
  ),
      ));
}

Future<void> Logout(BuildContext context) async {
  try {
    final r = RetryOptions(maxAttempts: 2);
    final response = await r.retry(
      // Make a GET request
      () => http.post(globals.apiurl + 'api/logout',
          body: jsonEncode({
            "user_id": globals.id,
            "device": globals.identifier,
          }),
          headers: {
            'Content-type': 'application/json'
          }).timeout(Duration(seconds: 2)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    if (response.statusCode == 201) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        final pref = await SharedPreferences.getInstance();
        await pref.clear();

        globals.id = 0;

        Navigator.pop(context);
      });
    } else {
      Toast.show("An error occurred", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  } on TimeoutException catch (e) {
    Toast.show("An error occurred", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    print('kkkkk Timeout Error: $e');
  } on SocketException catch (e) {
    Toast.show("Network error", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    print('kkkkk Socket Error: $e');
  } on Error catch (e) {
    Toast.show("An error occurred", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    print('kkkkkk General Error: $e');
  }
}
