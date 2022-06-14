import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/AvailableTime.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
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

class CalloutFeeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
String calloutfee='0.00';
List<AvailableTime> available_times=[];
  OrderModel orderModel;
  bool loading=false;
  AppColorModel appColorModel;

  CalloutFeeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  void  chargecalloutfee(BuildContext context,String deliverymethod) {
    setState(() {
      loading=true;
    });

    String times="";

    for(int i=0;i<available_times.length;i++){

      times=times+available_times[i].startime+"-"+available_times[i].endtime+(i==available_times.length-1?'':',');
    }

    var callout={

      "id":orderModel.id,

      "call_out_fee":this.calloutfee!='0.00'?this.calloutfee:null,

      "available_times":times,

      "method":deliverymethod

    };
    chargecallout(callout).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          Toast.show("Callout fee charged successfully", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          this.orderModel=value;
           print("going to tracking");
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => TrackingWidget(index: 1,orderModel: value,)));
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To save  charge"),
          ));

        }
      });
    });
  }

}


