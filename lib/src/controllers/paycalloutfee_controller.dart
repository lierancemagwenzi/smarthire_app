import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/settings_controller.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/AvailableTime.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/PaymentMethod.dart';
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

class PayCallOutController extends SettingsController {
  GlobalKey<ScaffoldState> scaffoldKey;
  String calloutfee='0.00';
  List<AvailableTime> available_times=[];
  OrderModel orderModel;
  bool loading=false;
  AppColorModel appColorModel;

  bool success=false;



  PayCallOutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }

  void goToOrders(BuildContext context){

    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) => Home(index: 0)));

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  setPaymentMethod(PaymentMethod paymentMethod,BuildContext context){
    setState(() {
      payment_method.value=paymentMethod;
    });


    // goToCheckout(context);


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


  void  Paycalloutfee(String selected_time,String url,BuildContext context) {
    setState(() {
      loading=true;
    });
    var callout={
      "id":orderModel.id,
      "call_out_fee":orderModel.callout_fee,
      "payment_method":payment_method.value.toMap(),
      "payment_method_id":payment_method.value.id,
      "time":selected_time
    };
    paycallout(callout,url).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          Toast.show("Submited successfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          success=true;
          this.orderModel=value;

        }
        else{
          success=false;
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To pay callout fee"),
          ));
        }
      });
    });
  }

}


