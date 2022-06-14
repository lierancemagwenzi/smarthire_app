import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/models/Provider.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class ProductController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<Product> products = [];

  bool loadcart=false;
  int quantity=1;
  AppColorModel appColorModel;

Product product;
  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();


  }

  void addToCart(Product product){
    setState(() {
      loadcart=true;
    });
    ProductOrder productOrder=new ProductOrder(quantity:quantity,product: product);

    if(!ExistsInCart(product)){
      setState(() {
        cart.value.add(productOrder);
      });
    }

    else{
      for(int i=0;i<cart.value.length;i++){
        if(cart.value[i].product.id==product.id){
        cart.value[i].quantity=quantity;
        }
      }
    }

    cart.notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loadcart=false;
        quantity=1;
      });

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Added to Cart"),
      ));
    });

  }

  bool isSameMarkets(Product product){
    int count=0;
    for(int i=0;i<cart.value.length;i++){
      if(cart.value[i].product.provider_id!=product.provider_id){
        count++;
      }
    }
    return count<1;
  }


  bool hasDifferentProductType(Product product){
    int count=0;
    for(int i=0;i<cart.value.length;i++){
      if(cart.value[i].product.product_type.toLowerCase()!=product.product_type.toLowerCase()){
        count++;
      }
    }
    return count>0;
  }



  List<Provider>getConflictingProducts(Product product){
    List<Product> products=[];
    List<Provider> providers=[];
     List<int>ids=[];

    for(int i=0;i<cart.value.length;i++){
      products.add(cart.value[i].product);
    }

    products.add(product);


    for(int i=0;i<products.length;i++){
      if(!ids.contains(products[i].provider_id)){
        providers.add(new Provider(id: products[i].provider_id,name: products[i].provider_name));
        ids.add(products[i].provider_id);
      }

    }
    return providers;
    
  }




  bool ExistsInCart(Product product){
    bool exists=true;
int count=0;
    for(int i=0;i<cart.value.length;i++){

      if(cart.value[i].product.id==product.id){

       count++;
      }


    }

    return count>0;
  }




  Future<void> listenForProducts(int id) async {
    products.clear();
    final Stream<Product> stream = await productRepo.getcategoryProducts(id);
    stream.listen((Product product) {
      setState(() => products.add(product));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get Category products"),
      ));
      print(a);
    }, onDone: () {

    });
  }


  void LikeProduct() {
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To Like"),
      ));

    }

    else{

    likeproduct(new LikeModel(user_id: currentuser.value.id,product_id: product.id)).then((value) {
      print(value);
      setState(() {
   product.liked=value;
      });
    });}
  }


  void DisLikeProduct() {
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To disLike"),
      ));
    }

    else{
      dislikeproduct(new LikeModel(user_id: currentuser.value.id,product_id: product.id)).then((value) {
        print(value);
        setState(() {
          product.liked=value;
        });
      });
    }

  }



  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

}


