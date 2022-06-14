import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/order_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class TrackingController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;


  OrderModel orderModel;

  List<Product> products = [];
  AppColorModel appColorModel;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }



  void listenforOrder(int id) async {
    final Stream<OrderModel> stream = await getOrder(id);
    stream.listen((OrderModel orderModel1) {

        setState(() {
          this.orderModel=orderModel1;
        });

    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get order"),
      ));
    }, onDone: () {
      print("fetched membership");

    });
  }



}


