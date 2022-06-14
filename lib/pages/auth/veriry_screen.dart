import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/User.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/storage/SharedPreferences.dart';
import 'package:smarthire/widget/button.dart';
import 'package:smarthire/widget/buttonVerify.dart';
import 'package:smarthire/widget/first.dart';
import 'package:smarthire/widget/inputEmail.dart';
import 'package:smarthire/widget/password.dart';
import 'package:smarthire/widget/textLogin.dart';
import 'package:smarthire/widget/userOld.dart';
import 'package:smarthire/widget/verificationCode.dart';
import 'package:smarthire/widget/verifyHorizonText.dart';
import 'package:smarthire/widget/verifyVertical.dart';
import 'package:smarthire/widget/verticalText.dart';

import 'package:smarthire/widget/inputEmail.dart' as fields;
import 'package:smarthire/widget/button.dart' as button;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/User.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/veriry_screen.dart';
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

import 'ResetPassword.dart';

class VerificationCodePage extends StatefulWidget {
  String message;
  UserModel user;

  String action;

  VerificationCodePage({@required this.message, this.user, this.action});

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  TextEditingController controller = TextEditingController();

  double heightt;
  double width;
  String message = "";
  String code = "";

  @override
  void initState() {
    message = widget.message;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heightt = MediaQuery.of(context).size.height;
    return Scaffold(
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
                      VerifyVerticalText(),
                      TextVerify(),
                    ]),

                    // Text(message+widget.user.code.toString()),
//                VerificationCode(),

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
                                    color: smarthireWhite, fontFamily: "sans"),
                              ),
                            ),
                          )
                        : Text(""),
                    fields.InputPan.InputField(
                        controller: controller,
                        width: MediaQuery.of(context).size.width * 0.3,
                        onchanged: (value) {
                          setState(() {
                            print(value);
                            code = value;
                          });
                        },
                        obscure: false,
                        label: "Verification Code"),

//                button.ButtonLogin.Button(width: MediaQuery.of(context).size.width,callbackAction: (){
//
//                  return Validate();
//                  print("pressed");
//                },label: "Sign In"),
                    button.ButtonLogin.Button(
                        width: MediaQuery.of(context).size.width,
                        callbackAction: () {
                          return Validate();
                          print("pressed");
                        },
                        label: "VERIFY"),
                    FirstTime(),
                    UserOld(),
                  ],
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          right: 20.0),
                      child: Icon(
                        Icons.cancel,
                        size: 40.0,
                        color: smarthireWhite,
                      ))))
        ],
      ),
    );
  }

  Validate() {
    setState(() {
      if (code.length == 6) {
        if (code == widget.user.code.toString()) {
          if (widget.action == "recover") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(
                          user: widget.user,
                          message: "Reset Password",
                        )));
          } else {
            Verify();
          }
        } else {
          message = "Wrong code";
        }
      } else {
        if (code.length < 6) {
          message = "code too short";
        } else {
          message = "code too long";
        }
      }
    });
  }

  Future<void> Verify() async {
    print("verification called");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/verify',
            body: jsonEncode({
              "id": widget.user.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});

      print(response.body);
      if (response.statusCode == 201) {
        UserModel userModel = widget.user;
        await SharedPreferencesTest.setAppUser(
          userModel.name,
          userModel.mobile,
          userModel.profile_pic,
          userModel.id.toString(),
        );
        setState(() {
          globals.id = userModel.id;
          globals.name = userModel.name;
          globals.mobile = userModel.mobile;
          globals.profile = userModel.profile_pic;
        });
        if (globals.socket != null) {
          globals.socket.disconnect();
        }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreenCustomer()));
      } else {
        setState(() {
          message = "An error occured";
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
