import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class AccountController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<ServiceModel> categories=[];
bool       loading=false;

  List<String>services=[];
  List<int >serviceids=[];

  List<Product> products = [];
  AppColorModel appColorModel;

  AccountController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  Future<void> listenForServices() async {
    categories.clear();
    final Stream<ServiceModel> stream = await getServices();
    stream.listen((ServiceModel serviceModel) {
      setState(() => categories.add(serviceModel));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get services"),
      ));
      print(a);
    }, onDone: () {

      addCategories();
    });
  }


  void addCategories(){

    for (int i = 0; i <categories.length; i++) {
      if(categories[i].type==productUploadModel.product_type.toLowerCase()){
        services.add(categories[i].service_name);
        serviceids.add(categories[i].id);
      }

    }
  }


  Future<void> listenForProducts(int id) async {
    setState(() {
      loading=true;
    });
    products.clear();
    // int id=currentuser.value.id;
    final Stream<Product> stream = await productRepo.getaccountProducts(id);
    stream.listen((Product product) {
      setState(() => products.add(product));
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get account products"),
      ));
      print(a);
    }, onDone: () {
      setState(() {
        loading=false;
      });

    });
  }


  void LikeProduct(Product product) {
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To Like"),
      ));

    }
    else{
      likeproduct(new LikeModel(user_id: currentuser.value.id,product_id: product.id)).then((value) {
        print(value);
        setState(() {
          product.liked=value;
        });
      });}
  }


  void DisLikeProduct(Product product) {
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To disLike"),
      ));
    }
    else{
      dislikeproduct(new LikeModel(user_id: currentuser.value.id,product_id: product.id)).then((value) {
        print(value);
        setState(() {
          product.liked=value;
        });
      });
    }

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

}


