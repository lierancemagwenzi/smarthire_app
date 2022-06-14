import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/Department.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class HomePageController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<Product> popularproducts = [];
  List<Product> popularservices = [];
  List<ServiceModel> services = [];
  List<SliderModel> sliders = [];
  List<Department> deaprtments = [];

  AppColorModel appColorModel;
  AddressModel addressModel;

  HomePageController() {
    addressModel= new AddressModel();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();
    listenForSliders();
    listenForDepartments();

    listenForServices();
    listenForAddress();
    listenForPopularProducts("popularproducts");
    listenForPopularServices("popularservices");

  }
  listenForAddress(){

    print("Getting address"+delivery_address.value.toMap().toString());
    setState(() {
      addressModel.user_id=delivery_address.value.user_id;
      addressModel.address=delivery_address.value.address;
      addressModel.longitude=delivery_address.value.longitude;
      addressModel.latitude=delivery_address.value.latitude;
    });

    print(addressModel.toMap());
  }

  Future<void> listenForSliders() async {
    sliders.clear();
    final Stream<SliderModel> stream = await getSliders();
    stream.listen((SliderModel sliderModel) {
      setState(() => sliders.add(sliderModel));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForDepartments() async {
    services.clear();
    final Stream<Department> stream = await getdepartments();
    stream.listen((Department department) {
      setState(() => deaprtments.add(department));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get departments"),
      ));
      print(a);
    }, onDone: () {});
  }


  Future<void> listenForServices() async {
    services.clear();
    final Stream<ServiceModel> stream = await getServices();
    stream.listen((ServiceModel serviceModel) {
      setState(() => services.add(serviceModel));
    }, onError: (a) {

      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get services"),
      ));
      print(a);
    }, onDone: () {});
  }


  Future<void> listenForPopularProducts(String url) async {
    popularproducts.clear();
    final Stream<Product> stream = await getPopularProducts(url);
    stream.listen((Product product) {


        setState(() => popularproducts.add(product));


    }, onError: (a) {

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Cannot get popular products"),
      // ));
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForPopularServices(String url) async {
    popularservices.clear();
    final Stream<Product> stream = await getPopularProducts(url);
    stream.listen((Product product) {
        setState(() => popularservices.add(product));
    }, onError: (a) {

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("Cannot get popular products"),
      // ));
      print(a);
    }, onDone: () {

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text("got services"+ popularservices.length.toString()),
      // ));
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


