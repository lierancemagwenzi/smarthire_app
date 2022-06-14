import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
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

class VerificationScreen extends StatefulWidget {
  UserModel userModel;

  VerificationScreen({
    @required this.userModel,
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  double height;
  double width;
  bool loading = false;
  final formKey = new GlobalKey<FormState>();
  TextEditingController controller2 = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String errorMessage;
  @override
  void initState() {
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
                        "Verify Your Mobile Number",
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "mainfont"),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: AutoSizeText(
                        "A verification code has been sent to " +
                            widget.userModel.mobile,
                        maxLines: 1,
                        style: TextStyle(
                            color: smarthireDark,
                            fontSize: 16.0,
                            fontFamily: "mainfont"),
                      ),
                    ),
//                    SizedBox(
//                      height: 20.0,
//                    ),
//                    InputField("Verification Code", controller),
                    SizedBox(
                      height: 20.0,
                    ),

                    Visibility(
                      child: Center(
                        child: Text(
                          "Wrong Code!",
                          style: TextStyle(
                              fontFamily: "mainfont",
                              fontSize: 16.0,
                              color: Colors.red),
                        ),
                      ),
                      visible: hasError,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: PinCodeTextField(
                        autofocus: true,
                        controller: controller,
                        hideCharacter: true,
                        highlight: true,

                        highlightColor: Colors.blue,
                        defaultBorderColor: Colors.black,
                        hasTextBorderColor: Colors.green,
                        maxLength: pinLength,
                        hasError: hasError,
                        maskCharacter: "*",
                        onTextChanged: (text) {
                          setState(() {
                            hasError = false;
                          });
                        },
                        onDone: (text) {
                          print("DONE $text");
                          print("DONE CONTROLLER ${controller.text}");
                        },
                        pinBoxWidth: 50,
                        pinBoxHeight: 64,
                        hasUnderline: true,
                        wrapAlignment: WrapAlignment.spaceAround,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 22.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
//                    highlightAnimation: true,
                        highlightAnimationBeginColor: Colors.black,
                        highlightAnimationEndColor: Colors.white12,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

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
                            setState(() {
                              hasError = false;
                            });
                            if (controller.text ==
                                widget.userModel.code.toString()) {
                              SaveUser();
                            } else {
                              hasError = true;
                            }
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
            ),
          );
  }

  SaveUser() async {
    UserModel userModel = widget.userModel;
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
    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) => HomeScreenCustomer()));
  }

  InputField(String hint, TextEditingController controller) {
    return new TextFormField(
      controller: controller,
      validator: (value) {
        if (value.isEmpty || value != widget.userModel.code.toString()) {
          return 'Please enter a valid code';
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

  body2() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Text(thisText, style: Theme.of(context).textTheme.title),
            ),
            Container(
              height: 100.0,
              child: GestureDetector(
                onLongPress: () {
                  print("LONG");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              Text("Paste clipboard stuff into the pinbox?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () async {
                                  var copiedText =
                                      await Clipboard.getData("text/plain");
                                  if (copiedText.text.isNotEmpty) {
                                    controller.text = copiedText.text;
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text("YES")),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("No"))
                          ],
                        );
                      });
                },
                child: PinCodeTextField(
                  autofocus: true,
                  controller: controller,
                  hideCharacter: true,
                  highlight: true,
                  highlightColor: Colors.blue,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.green,
                  maxLength: pinLength,
                  hasError: hasError,
                  maskCharacter: "😎",
                  onTextChanged: (text) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  onDone: (text) {
                    print("DONE $text");
                    print("DONE CONTROLLER ${controller.text}");
                  },
                  pinBoxWidth: 50,
                  pinBoxHeight: 64,
                  hasUnderline: true,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 22.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Visibility(
              child: Text(
                "Wrong PIN!",
              ),
              visible: hasError,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: <Widget>[
                  if (!kIsWeb)
                    MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Copy 1234 to Clipboard"),
                      onPressed: () {
                        setState(() {
                          Clipboard.setData(ClipboardData(text: "1111"));
                        });
                      },
                    ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("+"),
                    onPressed: () {
                      setState(() {
                        this.pinLength++;
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("-"),
                    onPressed: () {
                      setState(() {
                        this.pinLength--;
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("SUBMIT"),
                    onPressed: () {
                      setState(() {
                        this.thisText = controller.text;
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text("SUBMIT Error"),
                    onPressed: () {
                      setState(() {
                        this.hasError = true;
                      });
                    },
                  ),
                  MaterialButton(
                    color: Colors.pink,
                    textColor: Colors.white,
                    child: Text("CLEAR PIN"),
                    onPressed: () {
                      controller.clear();
                    },
                  ),
                  MaterialButton(
                    color: Colors.lime,
                    textColor: Colors.black,
                    child: Text("SET TO 456"),
                    onPressed: () {
                      controller.text = "456";
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
