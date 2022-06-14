import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/settings_controller.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/ServiceCheckout.dart';
import 'package:smarthire/src/pages/deliverypickup.dart';
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

  class  CartController extends SettingsController {
  GlobalKey<ScaffoldState> scaffoldKey;
  AppColorModel appColorModel;

  double subTotal=0;

  num delivery_fee=fee_per_km;

  double total=0;
List<ProductOrder> cart=[];

bool candeliver=false;

  CartController() {
    listenForAppColor();
    getCanDeliver();

  }

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  diabledelivery(){

    setState(() {

      candeliver=false;
    });

    calculateTotal();
    calculateSubTotal();
  }


  int cartCount(){

    return cartRepo.cart.value.length;
  }


  getCanDeliver() async {
    bool a= await Helper.CanDeliverCart();
    setState(() {

      this.candeliver=a;
    });
    calculateTotal();
    calculateSubTotal();
  }



  void calculateSubTotal(){
    num subtotal=0.0;
    for(int i=0;i<cartRepo.cart.value.length;i++){
      subtotal=subtotal+(cartRepo.cart.value[i].quantity*Helper.getPriceNum(cartRepo.cart.value[i].product.price)-Helper.getPriceNum(cartRepo.cart.value[i].product.discount));

    }

    print("subtotal"+subtotal.toString());
  setState(() {
    this.subTotal=subtotal;
  });
  }

   calculateTotal(){
    num subtotal=0.0;
    for(int i=0;i<cartRepo.cart.value.length;i++){
      subtotal=subtotal+(cartRepo.cart.value[i].quantity*Helper.getPriceNum(cartRepo.cart.value[i].product.price)-Helper.getPriceNum(cartRepo.cart.value[i].product.discount));

    }

    setState(() {this.total=subtotal+(candeliver?delivery_fee:0); });

  }


  listenForCart(){
cart.clear();
    for(int i=0;i<cartRepo.cart.value.length;i++)
      setState((){
        cart.add(cartRepo.cart.value[i]);


      });
calculateTotal();
calculateSubTotal();
    }
  removeFromCart(ProductOrder productOrder){
    setState(() {
      cartRepo.cart.value.removeWhere((element) => element.product.id==productOrder.product.id);
    });

    calculateTotal();
    calculateSubTotal();
    // listenForCart();
  }

  descrementQuantity(int index){
    print("-----");
    if(cartRepo.cart.value[index].quantity>1){
      setState(() {
        cartRepo.cart.value[index].quantity= cartRepo.cart.value[index].quantity-1;
      });
    }


cartRepo.cart.notifyListeners();
    calculateTotal();
    calculateSubTotal();
  }

  incerementQuantity(int index){
    if(cartRepo.cart.value[index].quantity<=int.parse(cartRepo.cart.value[index].product.available_quantity)){
      setState(() {
        cartRepo.cart.value[index].quantity=cartRepo.cart.value[index].quantity+1;
      });
    }
    cartRepo.cart.notifyListeners();

    calculateTotal();
    calculateSubTotal();

  }

  goToCheckout(BuildContext context){

    if(cartRepo.cart.value.isEmpty){
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => Home(index: 1)));
    }
    else{
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => DeliverPickup()));}
  }




  goToServiceCheckout(BuildContext context){
    if(cartRepo.cart.value.isEmpty){
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => Home(index: 1)));
    }
    else{
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => ServiceDeliveryPickup()));}
  }



  }





