import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class CategoryController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<Product> products = [];

  List<ServiceModel> departmentcategories=[];
  List<Product> likedproducts=[];


  AppColorModel appColorModel;

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();


  }

  Future<void> refresh(){

    return listenForLikedProducts();
  }


  Future<void> listenForLikedProducts() async {
    likedproducts.clear();
    final Stream<Product> stream = await productRepo.getlikedproducts();
    stream.listen((Product product) {
      setState(() => likedproducts.add(product));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get liked products"),
      ));
      print(a);
    }, onDone: () {

    });
  }

  Future<void> listenForDepartmentCategories(int id) async {
    products.clear();
    final Stream<ServiceModel> stream = await getDepartmentServices(id);
    stream.listen((ServiceModel serviceModel) {
      setState(() => departmentcategories.add(serviceModel));
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get department categories"),
      ));
      print(a);
    }, onDone: () {



    });
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


  void LikeProduct(Product product) {
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


  void DisLikeProduct(Product product) {
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


