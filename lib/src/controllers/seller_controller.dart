import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/Seller.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/seller_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class SellerController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  AppColorModel appColorModel;

  List<SellerAccount> selleraccounts=[];
bool loading=false;
bool success=false;

bool showview=true;
  SellerController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();
  }

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }


  void addimage(File file) {
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To Add Account"),
      ));
    }
    else{
      setState(() {
        success=false;
        loading=true;
        showview=false;
      });
      uploadprofile(file).then((value) {
        print(value);
        setState(() {
          if(value!=null){
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Uploaded image"),
            ));
            sellerAccount.profile_photo=value;
            addSellerAccount( );
          }
          else{
            loading=false;
            success=false;
            showview=true;
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Failed to upload profile picture"),
            ));
          }
        });
      });}
  }


  void addSellerAccount( ) {
    addSeller(sellerAccount).then((value) {
        print(value);
        setState(() {
          if(value!=null){
            loading=false;
            success=true;
            showview=false;
          }
          else{
            showview=true;
            success=false;
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Failed To Add seller"),
            ));
          }
        });
      });
  }


  Future<void> liestenforaccounts() async {
    selleraccounts.clear();
    if(currentuser.value.id==0){

    }
    else{
      final Stream<SellerAccount> stream = await getselleraccounts();
      stream.listen((SellerAccount sellerAccount) {
        setState(() => selleraccounts.add(sellerAccount));
      }, onError: (a) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Cannot get accounts"),
        ));
        print(a);
      }, onDone: () {

      });
    }}

}


