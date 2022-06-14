import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retry/retry.dart';
import 'package:share/share.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/notifications/AllNotifications.dart';
import 'package:smarthire/pages/auth/AccountPasswordReset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/pages/providers/NewService.dart';
import 'package:smarthire/pages/providers/account/ProductListing.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:ui' as ui;

import '../../constants/sizeroute.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double width;
  double height;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
              //                   <--- left side
              color: Colors.grey.withOpacity(0.3),

              width: 2.0,
            ),
          )),
          height: height * 0.1,
          child: ListTile(
            onTap: () async {
              Logout();
            },
            leading: Icon(
              Icons.close,
              color: Colors.red,
            ),
            title: Text(
              "Sign Out ",
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: "open-sans",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text("Account Information"),
      ),
      body: body(),
//      body: Stack(
//        children: <Widget>[
//          new Container(
//            color: smarthireWhite,
//          ),
//          new Image.network(
//            globals.fileserver + globals.profile,
//            fit: BoxFit.fill,
//          ),
//          new Center(
//                child: new Column(
//                  children: <Widget>[
//                    new SizedBox(
//                      height: _height / 12,
//                    ),
//                    new CircleAvatar(
//                      radius: _width < _height ? _width / 4 : _height / 4,
//                      backgroundImage:
//                          NetworkImage(globals.profile),
//                    ),
//                    new SizedBox(
//                      height: _height / 25.0,
//                    ),
//                    Text(globals.name,style: TextStyle(fontFamily: "sans",color: smarthireBlue,fontSize: 18.0,fontWeight: FontWeight.bold),),
//                    new SizedBox(
//                      height: _height / 25.0,
//                    ),
//                    // new Divider(
//                    //   height: _height / 30,
//                    //   color: smarthireBlue,
//                    // ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: [
//                        Text("Phone Number",style: TextStyle(fontFamily: "sans",color: smarthireBlue,fontWeight: FontWeight.w800),),
//                        Text(globals.mobile,style: TextStyle(fontFamily: "sans",color: smarthireBlue),),
//                      ],
//                    ),
//                    new SizedBox(
//                      height: _height / 25.0,
//                    ),
//                    // new Divider(height: _height / 30, color:smarthireBlue),
//                    new Padding(
//                      padding: new EdgeInsets.only(
//                          left: _width / 8, right: _width / 8),
//                      child: new FlatButton(
//                        onPressed: () async {
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (context) => AccountPasswordReset()));
//                          print(globals.profile+"url yachona");
//                        },
//                        child: new Container(
//                            child: new Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                new Icon(Icons.lock_open,color: smarthireWhite,),
//                                new SizedBox(
//                                  width: _width / 30,
//                                ),
//                                new Text('RESET PASSWORD',style: TextStyle(fontFamily: "sans",color: smarthireWhite),)
//                              ],
//                            )),
//                        color: smarthireBlue,
//                      ),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.only(
//                          left: _width / 8, right: _width / 8),
//                      child: new FlatButton(
//                        onPressed: () async {
//                          final pref = await SharedPreferences.getInstance();
//                          await pref.clear();
//                          setState(() {
//                            globals.id = 0;
//                          });
//
//                          Navigator.pop(context);
//                        },
//                        child: new Container(
//                            child: new Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                new Icon(Icons.exit_to_app,color: smarthireWhite,),
//                                new SizedBox(
//                                  width: _width / 30,
//                                ),
//                                new Text('LOGOUT',style: TextStyle(fontFamily: "sans",color: smarthireWhite),)
//                              ],
//                            )),
//                        color: smarthireBlue,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//        ],
//      ),
    );
  }

  body() {
    return ListView(
      children: <Widget>[
        Container(
          height: height * 0.25,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 6 / 6,
                  child: CircleAvatar(
                    radius: width * 0.3,
                    backgroundImage: NetworkImage(globals.profile),
                    backgroundColor: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.08),
                  child: Text(
                    globals.name,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontFamily: "open-sans"),
                  ),
                )
              ],
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          title: Text(
            globals.mobile,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          height: height * 0.03,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: Colors.grey.withOpacity(0.3),

              width: 2.0,
            ),
          )),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                SlideRightRoute(
                  page: AllNotifications(),
                ));
          },
          leading: Icon(
            Icons.notifications,
            color: Colors.grey,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          title: Text(
            "Notifications",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                SlideRightRoute(
                  page: NewServiceScreen(),
                ));
          },
          leading: Icon(
            Icons.add,
            color: Colors.grey,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          title: Text(
            "Add Product",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                SlideRightRoute(
                  page: ProductListing(),
                ));
          },
          leading: Icon(
            Icons.local_grocery_store,
            color: Colors.grey,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          title: Text(
            "My products",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                SlideRightRoute(
                  page: AccountPasswordReset(),
                ));
          },
          leading: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          title: Text(
            "Change Password",
            style: TextStyle(color: Colors.grey),
          ),
        ),
//        ListTile(
//          leading: Icon(
//            Icons.settings,
//            color: Colors.grey,
//          ),
//          trailing: Icon(
//            Icons.arrow_forward_ios,
//            color: Colors.grey,
//          ),
//          title: Text(
//            "Settings",
//            style: TextStyle(color: Colors.grey),
//          ),
//        ),
//        ListTile(
//          leading: Icon(
//            Icons.favorite,
//            color: Colors.grey,
//          ),
//          trailing: Icon(
//            Icons.arrow_forward_ios,
//            color: Colors.grey,
//          ),
//          title: Text(
//            "Favourites",
//            style: TextStyle(color: Colors.grey),
//          ),
//        ),
        InkWell(
          onTap: () {
            Share.share(
                'check out the  smarthire app and complete deals at the comfort of your home. https://smarthire.app');
          },
          child: ListTile(
            leading: Icon(
              Icons.person_add,
              color: Colors.grey,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
            title: Text(
              "Tell A friend",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget rowCell(int count, String type) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            '$count',
            style: new TextStyle(color: smarthireBlue),
          ),
          new Text(type,
              style: new TextStyle(
                  color: smarthireBlue, fontWeight: FontWeight.normal))
        ],
      ));

  Future<void> Logout() async {
    setState(() {
      loading = true;
    });
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
          setState(() {
            loading = false;
          });
          final pref = await SharedPreferences.getInstance();
          await pref.clear();
          setState(() {
            globals.id = 0;
          });

          Navigator.pop(context);
        });
      } else {
        Toast.show("An error occurred", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }

      loading = false;
    } on TimeoutException catch (e) {
      loading = false;
      Toast.show("An error occurred", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      loading = false;
      Toast.show("Network error", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      loading = false;
      Toast.show("An error occurred", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      print('kkkkkk General Error: $e');
    }
  }
}
