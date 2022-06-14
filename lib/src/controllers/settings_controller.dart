import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/CardInfo.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/PaymentMethod.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/UserModel.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;
import 'package:smarthire/src/repository/settings_repository.dart';

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';
import 'package:smarthire/storage/SharedPreferences.dart';

class  SettingsController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<PaymentMethod> paymentmethods=[];
  bool  loading=false;

  List<CardInfo> cards = [];
  AppColorModel appColorModel;
   SettingsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForPaymentMethods();
    listenForAppColor();

  }
  void UpdateProfile(UserModel userModel) {
    updateUser(userModel).then((value) async {
      print(value);


        if(value!=null){
          await SharedPreferencesTest.setAppUser(
            userModel.name,
            userModel.mobile,
            userModel.profile_pic,
            userModel.id.toString(),
          );
setState(() {           currentuser.value=value;});



          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Profile  updated"),
          ));
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To update profile info"),
          ));
        }

    });
  }


  void AddCardInfo(PaymentMethod paymentMethod,int index) {
     addCard(paymentMethod.cardInfo).then((value) {
        print(value);
        setState(() {
          if(value!=null){
            paymentmethods[index]=value;

            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(paymentMethod.cardInfo.id==null?"${paymentMethod.name}  Info added":"${paymentMethod.name}  Info updated"),
            ));
          }
          else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Failed To Add Card Info"),
            ));
          }
        });
      });
  }


  Future<void> listenForPaymentMethods() async {
    paymentmethods.clear();
    final Stream<PaymentMethod> stream = await settingsRepo.getpaymentmethods(1);

    stream.listen((PaymentMethod paymentMethod) {
      setState(() => paymentmethods.add(paymentMethod));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get payment methods"),
      ));
      print(a);
    }, onDone: () {
    });
  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

}


