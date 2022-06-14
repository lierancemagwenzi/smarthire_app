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
import 'package:toast/toast.dart';

class AcceptDeclineController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;


  OrderModel orderModel;
  bool loading=false;
  AppColorModel appColorModel;

  AcceptDeclineController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }


  void  acceptOrder(BuildContext context,String type) {

    setState(() {
      loading=true;
    });
    acceptorder(orderModel.id,type).then((value) {
      print(value);
      setState(() {

        loading=false;
        if(value!=null){

          Toast.show("Order  accepted successfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          this.orderModel=value;

    Navigator.of(context).pushReplacementNamed('/${orderModel.orderStatus.provider_next_stage}',arguments: orderModel);

    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text("Order Accepted "),
    ));
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Accept  Order"),
          ));

        }
      });
    });
  }

}


