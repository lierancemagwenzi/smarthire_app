import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/cart_controller.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/PaymentMethod.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/deliverypickup.dart';
import 'package:smarthire/src/pages/ordersuccess.dart';
import 'package:smarthire/src/repository/address_repository.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';
import 'package:smarthire/src/repository/cart_repository.dart' as cartRepo;

class  CheckoutController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  AppColorModel appColorModel;
  CheckoutController() {
    payment_method.value=new PaymentMethod();
    listenForAppColor();

  }

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  setPaymentMethod(PaymentMethod paymentMethod,BuildContext context){
    setState(() {
      payment_method.value=paymentMethod;
    });
    goToCheckout(context);


  }


  @override
  goToCheckout(BuildContext context) {

    if(payment_method.value.name==null){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Select a payment method"),
      ));
    }

    else{
      if(cartRepo.cart.value.isEmpty){
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => Home(index: 1)));
      }
      else{
        Navigator.of(context).pushReplacementNamed('/${payment_method.value.name.toLowerCase()}');
      }
   }
  }





}


