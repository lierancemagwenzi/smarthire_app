import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/pages/auth/veriry_screen.dart';
import 'package:smarthire/widget/buttonNewUser.dart';
import 'package:smarthire/widget/newEmail.dart';
import 'package:smarthire/widget/newName.dart';
import 'package:smarthire/widget/password.dart';
import 'package:smarthire/widget/singup.dart';
import 'package:smarthire/widget/textNew.dart';
import 'package:smarthire/widget/userOld.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/User.dart';
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

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  TextEditingController nameController = new TextEditingController();

  var _username = "";
  var _password = "";

  var _name = "";

  String message = "";

  double heightt;
  double width;

  Validate() {
    print("validate called");
    if (_username.length > 0 && _password.length > 0 && _name.length > 0) {
      Signup();
    } else {
      String error = "";

      if (_name.length < 1 && _username.length < 1 && _password.length < 1) {
        error = error + "Field Name,Mobile number & Password cannot be empty.";
      } else {
        if (_name.length < 1 && _username.length < 1) {
          error = error + "Field Name & Mobile number cannot be empty.";
        } else {
          if (_name.length < 1 && _password.length < 1) {
            error = error + "Field Name & Password cannot be empty.";
          } else {
            if (_username.length < 1 && _password.length < 1) {
              error = error + "Field Mobile Number & Password cannot be empty.";
            } else {
              if (_username.length < 1) {
                error = error + "Field Mobile number cannot be empty,";
              }
              if (_username.length < 1) {
                error = error + "Field Password cannot be empty.";
              }
              if (_password.length < 1) {}
            }
          }
        }
      }

      setState(() {
        message = error;
      });
    }
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
                    Row(
                      children: <Widget>[
                        SingUp(),
                        TextNew(),
                      ],
                    ),

                    message.length > 0
                        ? Container(
                            color: Colors.redAccent[100],
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: heightt * 0.02,
                                  horizontal: width * 0.025),
                              child: Text(
                                message,
                                style: TextStyle(
                                    color: smarthireWhite, fontFamily: "sans"),
                              ),
                            ),
                          )
                        : Text(""),

                    fields.InputPan.InputField(
                        controller: nameController,
                        width: MediaQuery.of(context).size.width * 0.3,
                        onchanged: (value) {
                          setState(() {
                            print(value);
                            _name = value;
                          });
                        },
                        obscure: false,
                        label: "Name"),
                    fields.InputPan.InputField(
                        controller: mobileNumberController,
                        width: MediaQuery.of(context).size.width * 0.3,
                        onchanged: (value) {
                          setState(() {
                            print(value);
                            _username = value;
                          });
                        },
                        obscure: false,
                        label: "Mobile number eg +25082748748484"),
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
                        label: "Password"),
                    button.ButtonLogin.Button(
                        width: MediaQuery.of(context).size.width,
                        callbackAction: () {
                          Validate();
                          print("pressed");
                        },
                        label: "Sign Up"),
//                NewEmail(),
//                PasswordInput(),
//                ButtonNewUser(),
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

  Future<void> Signup() async {
    print("signup called");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/register',
            body: jsonEncode({
              "phone": _username,
              "password": _password,
              "name": _name,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
        userModel.profile_pic = globals.fileserver + userModel.profile_pic;
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationCodePage(
                        user: userModel,
                        message: "Enter Code To Proceed",
                      )));
        });
      } else {
        if (response.statusCode == 401) {
          setState(() {
            message = "Account Already Exists";
          });
        }
      }
    } on TimeoutException catch (e) {
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      setState(() {});
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      print('kkkkkk General Error: $e');
    }
  }
}
