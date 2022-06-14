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
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/order_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';
import 'package:toast/toast.dart';

class ConfirmCallOutPaymentController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  bool success=false;

  OrderModel orderModel;
  bool loading=false;
  AppColorModel appColorModel;

  ConfirmCallOutPaymentController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  void goToOrders(BuildContext context){
    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) => Home(index: 2)));

  }

  void listenforOrder(int id) async {
    final Stream<OrderModel> stream = await getOrder(id);
    stream.listen((OrderModel orderModel) {
      print(orderModel.toMap().toString());
      setState(() {
        this.orderModel=orderModel;
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

  void  ConfrimPayment(BuildContext context) {
    setState(() {
      loading=true;
    });
    confirmcalloutpayment(orderModel.id,orderModel.payment_id).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          Toast.show("Confirmed successfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          this.orderModel=value;
          success=true;
          // Navigator.of(context).pushReplacementNamed('/${orderModel.orderStatus.provider_next_stage}',arguments: orderModel);

          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Confirmed"),
          ));
        }
        else{
          success=false;
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Confirm Payment"),
          ));

        }
      });
    });
  }

}


