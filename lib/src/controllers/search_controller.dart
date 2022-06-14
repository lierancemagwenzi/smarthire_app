import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/SearchModel.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/category_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class SearchController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
Product product;
  List<Product> products = [];
  List<Product> services=[];
bool productresults=true;
bool categoryresults=true;
List<ServiceModel> categories=[];
  bool servicesresults=true;
  bool searching=false;
  AppColorModel appColorModel;
  SearchController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAppColor();
    SearchProducts(SearchModel(search: 'e'));
  }

  void SearchProducts(SearchModel searchModel) {
    searchModel.user_id=currentuser.value.id!=null?currentuser.value.id:-1;
    products.clear();
    services.clear();
    setState(() {
      searching=true;
    });
    productRepo.searchProducts(searchModel).then((value) {

      print(value);
      setState(() {

        for(int i=0;i<value.length;i++){

          if(value[i].product_type=='service'){

            services.add(value[i]);
          }

          else{
            products.add(value[i]);
          }
        }

      });
      SearchCategories(searchModel);
    });
  }


  void SearchCategories(SearchModel searchModel) {
    categories.clear();
    searchCategories(searchModel).then((value) {
      print(value);
      setState(() {
        categories=value;
        searching=false;
      });
    });
  }


  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

}


