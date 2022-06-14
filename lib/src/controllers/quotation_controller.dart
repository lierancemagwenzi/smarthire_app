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
import 'package:smarthire/src/models/QuotationModel.dart';
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

class QuotationController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  OrderModel orderModel;
  bool loading=false;
  AppColorModel appColorModel;

  List<QuotationModel> quotationitems=[];

  QuotationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();

  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
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


  void  savequotation(BuildContext context) {

    var quotation=[];

    for(int i=0;i<quotationitems.length;i++){

      quotation.add(quotationitems[i].toMap());
    }

    sendquotation({"quotation":quotation,"id":orderModel.id}).then((value) {
      print(value);
      setState(() {
        loading=false;
        if(value!=null){
          this.orderModel=value;
          print("going to tracking");
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => TrackingWidget(index: 1,orderModel: value,)));        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To save  quotation"),
          ));

        }
      });
    });
  }

}

