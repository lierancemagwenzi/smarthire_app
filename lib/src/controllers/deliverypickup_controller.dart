import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/cart_controller.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/DeliveryMethod.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/ServiceOrderSuccess.dart';
import 'package:smarthire/src/pages/deliverypickup.dart';
import 'package:smarthire/src/pages/payment.dart';
import 'package:smarthire/src/repository/address_repository.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;
import 'package:smarthire/src/repository/cart_repository.dart' as cartRepo;
import 'package:smarthire/src/repository/settings_repository.dart';

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class  DeliveryPickupController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  AppColorModel appColorModel;

  DeliveryMethod pickup= DeliveryMethod(id: 1,name: "pickup",selected: false,description:"You pick from the supplier");
  DeliveryMethod delivery= DeliveryMethod(id: 2,name: "delivery",selected: false,description:"The supplier delivers items to your");


  DeliveryPickupController() {
    delivery_method.value=new DeliveryMethod();
    listenForAppColor();
  }

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  bool toggleDelivery(){
    setState(() {
      pickup.selected=false;
      delivery.selected=true;
      delivery_method.value=delivery;

    });
  }

  bool togglePickup(){


    setState(() {
      pickup.selected=true;
      delivery.selected=false;
      delivery_method.value=pickup;


    });

    super.diabledelivery();
  }

@override
  goToCheckout(BuildContext context) {
    if(delivery_method.value.name==null){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Select a delivery method"),
      ));
    }

    else{
      if(cartRepo.cart.value.isEmpty){
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => Home(index: 1)));
      }
      else{
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => Payment()));}
    }

  }


  @override
  goToServiceCheckout(BuildContext context) {
    if(delivery_method.value.name==null){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Select a delivery method"),
      ));
    }

    else{
      if(cartRepo.cart.value.isEmpty){
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => Home(index: 1)));
      }
      else{
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => ServiceOrderSuccess()));}
    }
  }

  void getPaymentMethod(){


  }

}





