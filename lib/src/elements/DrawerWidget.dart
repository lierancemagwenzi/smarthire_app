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
import 'package:smarthire/notifications/AllNotifications.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/orders/AllOrdersScreen.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/providers/NewService.dart';
import 'package:smarthire/pages/providers/account/ProductListing.dart';
import 'package:smarthire/pages/registration/LoginScreen.dart';
import 'package:smarthire/src/controllers/home_controller.dart';
import 'package:smarthire/src/models/ProductUploadModel.dart';
import 'package:smarthire/src/models/UserModel.dart';
import 'package:smarthire/src/pages/AccountProducts.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/Notification.dart';
import 'package:smarthire/src/pages/Settings.dart';
import 'package:smarthire/src/pages/faqs.dart';
import 'package:smarthire/src/pages/productadd/FirstScreen.dart';
import 'package:smarthire/src/pages/seller/Home.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;

DrawerWidget(GlobalKey<ScaffoldState> parentScaffold, BuildContext context,HomeController _con) {

  Color textcolor=globals.darkmode?Colors.white: Color(0xff043832);
  return Drawer(

      child: Container(
        child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
        DrawerHeader(
          child: currentuser.value.id == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {

                            Navigator.of(context).pushNamed('/Login');


                        },
                        color: smarthireBlue,
                        textColor: Colors.white,
                        child: Text("Sign  In",
                            style: settingsRepo.appcolor.value.headerStyle),
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
                        currentuser.value.name,
                      style: settingsRepo.appcolor.value.headerStyle
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                  currentuser.value.mobile,
                      style:settingsRepo.appcolor.value.bodyStyle,
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
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => Home(index: 2)));
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
  if (currentuser.value.id == 0) {
  Navigator.of(context).pushNamed('/Login');

  } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => NotificationWidget()));
          }},
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
                    builder: (context) => Home(index: 0)));


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
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Home(index: 3)));

          },
        ),

      ListTile(
        leading: Icon(
          Icons.money,
          size: 30.0,
        ),
        title: Text(
          'Seller Account',
          style: TextStyle(
              color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
        ),
        onTap: () {

  if (currentuser.value.id == 0) {
  Navigator.of(context).pushNamed('/Login');

  } else {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => SellerHome()));}
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
           Icons.brightness_6,
            size: 30.0,
          ),
          title: Text(
         settingsRepo.darkmode?'Light Mode':'Dark Mode',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            settingsRepo.darkmode=!settingsRepo.darkmode;
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => Home()));

            // Toast.show("Coming Soon", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          }
          ,
        ),

      ListTile(
        leading: Icon(
          Icons.settings,
          size: 30.0,
        ),
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
        ),
        onTap: () {
          if (currentuser.value.id == 0) {
            Navigator.of(context).pushNamed('/Login');

          } else {

            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => Settings()));

          }
        },
      ),

      ListTile(
        leading: Icon(
          Icons.help,
          size: 30.0,
        ),
        title: Text(
          'Support and Help',
          style: TextStyle(
              color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
        ),
        onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => Faqs()));


        },
      ),
        ListTile(
          leading: Icon(
            Icons.power_settings_new,
            size: 30.0,
          ),
          title: Text(
            currentuser.value.id == 0 ? "Sign In" : 'Logout',
            style: TextStyle(
                color: Colors.black, fontFamily: "mainfont", fontSize: 18.0),
          ),
          onTap: () {
            if (currentuser.value.id == 0) {
              Navigator.of(context).pushNamed('/Login');

            } else {
            _con.Logout(context);
            }
          },
        ),
    ],
  ),
      ));
}


