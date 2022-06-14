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

class RegistrationScreen extends StatefulWidget {
  String phone;

  RegistrationScreen({
    @required this.phone,
  });

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  double height;
  double width;
  bool loading = false;
  final formKey = new GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  @override
  void initState() {
    phonecontroller.text = widget.phone;
    super.initState();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: height * 0.2,
                      width: width,
                      child: Image.asset("assets/delivery.gif"),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        "Create An Account",
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "mainfont"),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    InputField("Firstname", controller),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputField("Lastname", _controller),
                    SizedBox(
                      height: 40.0,
                    ),
                    PhoneInputField(),
                    SizedBox(
                      height: 40.0,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.8,
                        child: RaisedButton(
                          color: smarthirePurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              Login();
                            }
                          },
                          child: Text(
                            "Register",
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
            ),
          );
  }

  InputField(String hint, TextEditingController controller) {
    return new TextFormField(
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: new InputDecoration(
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
          hintText: hint,
          fillColor: Colors.white70),
    );
  }

  PhoneInputField() {
    return new TextFormField(
      controller: phonecontroller,
      enabled: false,
      decoration: new InputDecoration(
          border: new OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.7),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.7),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.7),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.grey[800]),
          labelText: "Phone",
          fillColor: Colors.white70),
    );
  }

  Future<void> Login() async {
    setState(() {
      loading = true;
    });
    try {
      final r = RetryOptions(maxAttempts: 3);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/signup',
            body: jsonEncode({
              "phone": widget.phone,
              "name": controller.text + " " + _controller.text
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
        setState(() {
          controller.text = "";
          loading = false;
        });

        Toast.show("An error occurred", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } on TimeoutException catch (e) {
      Toast.show("An error occurred", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      loading = false;

      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      Toast.show("An error occurred", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        loading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      Toast.show("An error occurred", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        loading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }
}
