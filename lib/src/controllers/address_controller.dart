import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/address_repository.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class  AddressController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<AddressModel> addresses=[];
  AppColorModel appColorModel;

   AddressController() {
    listenForAppColor();
    listenForAddresses();

  }

 void  changeAddress(AddressModel addressModel){
     setState(() {
       delivery_address.value=addressModel;
       print("changing "+delivery_address.value.toMap().toString());


     });
  }

  void deleteAddress(AddressModel addressModel) {
      removeAdrress(addressModel).then((value) {
        print(value);
        setState(() {
          if(value!=null){
            setState(() {
              this.addresses.remove(addressModel);

              if(addressModel.name==delivery_address.value.name){
                delivery_address.value=new AddressModel();
              }
            });
          }
          else{
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Failed To delete Address"),
            ));
          }
        });
      });

      listenForAddresses();
  }


  void addAddress(AddressModel addressModel) {
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To Add Address"),
      ));
    }
    else{
      addressModel.user_id=currentuser.value.id;
      addsAdrress(addressModel).then((value) {
        print(value);
        setState(() {
          if(value!=null){
            addresses.add(value);
          }

          else{

            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text("Failed To Add Address"),
            ));
          }
        });
      });}
  }

  Future<void> listenForAddresses() async {
     addresses.clear();
    if(currentuser.value.id==0){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Login To Add Address"),
      ));
    }
    else{
    addresses.clear();
    final Stream<AddressModel> stream = await getAddresses();
    stream.listen((AddressModel addressModel) {
      setState(() => addresses.add(addressModel));
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Cannot get services"),
      ));
      print(a);
    }, onDone: () {

    });
  }}

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
      }

}


