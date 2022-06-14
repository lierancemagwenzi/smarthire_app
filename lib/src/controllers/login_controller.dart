
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/RouteParameter.dart';
import 'package:smarthire/src/models/UserModel.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/Register.dart';
import 'package:smarthire/src/pages/Verify.dart';


import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/user_repository.dart';
import 'package:smarthire/storage/SharedPreferences.dart';

class LoginController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  AppColorModel appColorModel;

  bool loading=false;
  LoginController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();
  }

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }


  void Login(UserModel userModel,BuildContext context) {
      loginUser(userModel).then((value) {
        print(value);
        if(value==null){
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("An error occurred"),
          ));
        }
   else{
     if(value.statusCode==401){
       value.mobile=userModel.mobile;
       Navigator.pushReplacement(context,
           CupertinoPageRoute(builder: (context) => RegistrationScreen(phone: value.mobile)));

     }
     else if(value.statusCode==201){
       Navigator.pushReplacement(context,
           CupertinoPageRoute(builder: (context) => VerificationScreen(userModel: value,)));
     }
     else{
     }

        }
      });
  }


  void Register(UserModel userModel,BuildContext context) {
    registerUser(userModel).then((value) {
      print(value);
      if(value==null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("An error occurred"),
        ));
      }
      else{
        if(value.statusCode==401){

        }
        else if(value.statusCode==201){
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => VerificationScreen(userModel: value,)));
        }
        else{
        }

      }
    });
  }

  SaveUser(UserModel userModel,BuildContext context) async {
    await SharedPreferencesTest.setAppUser(
      userModel.name,
      userModel.mobile,
      userModel.profile_pic,
      userModel.id.toString(),
    );
    setState(() {
      currentuser.value.id = userModel.id;
      currentuser.value.name = userModel.name;
      currentuser.value.mobile = userModel.mobile;
      currentuser.value.profile_pic = userModel.profile_pic;
    });
    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) => Home()));
  }


}


