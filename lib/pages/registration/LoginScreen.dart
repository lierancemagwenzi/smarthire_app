import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/model/User.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/veriry_screen.dart';
import 'package:smarthire/pages/registration/RegistrationScreen.dart';
import 'package:smarthire/storage/SharedPreferences.dart';
import 'package:smarthire/widget/ForgotText.dart';
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
import 'package:toast/toast.dart';

import 'VerificationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double height;
  double width;
  PhoneNumber number = PhoneNumber(isoCode: 'ZA');
  String phone = "";

  bool loading = false;
  final formKey = new GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  bool _validatephone() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      Login();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: smarthireDark,
            size: 30.0,
          ),
        ),
      ),
      body: body(),
    );
  }

  body() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: height * 0.3,
                    width: width,
                    child: Image.asset("assets/delivery.gif"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Mobile Number",
                    style: TextStyle(
                        color: smarthireDark,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "mainfont"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Enter your mobile number and tap 'continue' to get a verification code",
                    style: TextStyle(
                        color: smarthireDark,
                        fontSize: 16.0,
                        fontFamily: "mainfont"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      phone = number.phoneNumber;
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    inputDecoration: new InputDecoration(
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "phone",
                        fillColor: Colors.white70),
                    ignoreBlank: false,
                    autoValidate: true,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: controller,
                    inputBorder: OutlineInputBorder(),
                  ),
                  Center(
                    child: SizedBox(
                      width: width * 0.8,
                      child: RaisedButton(
                        color: smarthirePurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          _validatephone();
                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "mainfont",
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Future<void> Login() async {
    setState(() {
      loading = true;
    });
    print("login called" + phone);
    try {
      final r = RetryOptions(maxAttempts: 3);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/signin',
            body: jsonEncode({
              "phone": phone,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        setState(() {
          loading = false;
        });
        UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
        userModel.profile_pic = globals.fileserver + userModel.profile_pic;

        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => VerificationScreen(
                      userModel: userModel,
                    )));
      } else {
        if (response.statusCode == 401) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => RegistrationScreen(
                        phone: phone,
                      )));
        } else {
          setState(() {
            controller.text = "";
            loading = false;
          });

          Toast.show("An error occurred", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      }
    } on TimeoutException catch (e) {
      Toast.show("Timeout error", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      controller.text = "";
      loading = false;
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      Toast.show("Check your internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        controller.text = "";
        loading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      Toast.show("Check your internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        controller.text = "";
        loading = false;
        ;
      });
      print('kkkkkk General Error: $e');
    }
  }
}
