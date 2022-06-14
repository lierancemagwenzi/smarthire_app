import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/seller/Tracking.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/order_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';
import 'package:toast/toast.dart';

class AddDeliveryDateController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;


  OrderModel orderModel;
  bool loading=false;
  AppColorModel appColorModel;

  AddDeliveryDateController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }


  void listenforOrder(int id,String status,BuildContext context) async {
    final Stream<OrderModel> stream = await getOrder(id);
    stream.listen((OrderModel orderModel1) {
      print(orderModel1.toMap().toString());
      print(orderModel1.orderStatus.provider_next_stage??''+(" ==="+status));
      if(orderModel1.orderStatus.provider_next_stage==status){

        setState(() {
          this.orderModel=orderModel1;
        });
      }
      else{
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Cannot get order.Order status changed"),
        ));
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get order"),
      ));
    }, onDone: () {
      print("fetched membership");

    });
  }



  void  Adddeliverydate(BuildContext context,String date) {
    setState(() {
      loading=true;
    });
    adddeliverydate(
        {
      "id":orderModel.id,"delivery_date":date,"status":orderModel.orderStatus.provider_stage

    }).then((value) {
      print(value);
      setState(() {

        loading=false;
        if(value!=null){
          Toast.show("Delivery Date  added successfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          this.orderModel=value;
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => TrackingWidget(index: 1,orderModel: value,)));

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Add delivery Date"),
          ));

        }
      });
    });
  }

}

