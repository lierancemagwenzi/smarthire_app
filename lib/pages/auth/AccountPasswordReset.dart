import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/User.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/veriry_screen.dart';
import 'package:smarthire/storage/SharedPreferences.dart';
import 'package:smarthire/widget/button.dart';
import 'package:smarthire/widget/first.dart';
import 'package:smarthire/widget/inputEmail.dart';
import 'package:smarthire/widget/password.dart';
import 'package:smarthire/widget/textLogin.dart';
import 'package:smarthire/widget/verificationCode.dart';
import 'package:smarthire/widget/verticalText.dart';
import 'package:smarthire/widget/inputEmail.dart' as fields;
import 'package:smarthire/widget/button.dart' as button;
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart' as globals;

import 'ForgotPassword.dart';

class AccountPasswordReset extends StatefulWidget {
  @override
  _AccountPasswordResetState createState() => _AccountPasswordResetState();
}

class _AccountPasswordResetState extends State<AccountPasswordReset> {
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  var _password = "";
  String message = "";

  double heightt;
  double width;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Validate() {
    setState(() {
      message = "";
    });
    if (_password.length > 0) {
      ResetPassword();
    } else {
      String error = "";
      error = error + "Password cannot be empty";
      setState(() {
        message = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heightt = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [smarthireBlue.withOpacity(0.5), smarthireBlue]),
              ),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 60, left: 10),
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Text(
                                'Recover',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                          child: Container(
                            //color: Colors.green,
                            height: 200,
                            width: 200,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                ),
                                Center(
                                  child: Text(
                                    'A services marketplace with everything in one app',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      message.length > 0
                          ? Container(
                              color: Colors.redAccent[100],
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: heightt * 0.02,
                                    horizontal: width * 0.04),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                      color: smarthireWhite,
                                      fontFamily: "sans"),
                                ),
                              ),
                            )
                          : Text(""),
                      fields.InputPan.InputField(
                          controller: passwordController,
                          width: MediaQuery.of(context).size.width * 0.3,
                          onchanged: (value) {
                            setState(() {
                              print(value);
                              _password = value;
                            });
                          },
                          obscure: true,
                          label: "new password"),
                      button.ButtonLogin.Button(
                          width: MediaQuery.of(context).size.width,
                          callbackAction: () {
                            return Validate();
                            print("pressed");
                          },
                          label: "Reset Password"),
                    ],
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        "Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: "sans"),
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Future<void> ResetPassword() async {
    print("reset called");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/resetpassword',
            body: jsonEncode({
              "id": globals.id,
              "password": _password,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
//        setState(() {
//          message="Password reset successful";
//        });

        showInSnackBar("password reset successfully");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        setState(() {
          message = "An error occured.Try again ";
        });
      }
    } on TimeoutException catch (e) {
      message = "Timeout Exception";
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      setState(() {
        message = "Failed to establish connection";
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      setState(() {
        message = "An unknown error occured";
      });
      print('kkkkkk General Error: $e');
    }
  }
}
