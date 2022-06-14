import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/FaqModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/repository/address_repository.dart';
import 'package:smarthire/src/repository/faq_repository.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;

import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class   FaqController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<FaqModel> faqs=[];
  AppColorModel appColorModel;

   FaqController() {
    listenForAppColor();
    listenForfaqs();

  }


  Future<void> listenForfaqs() async {
      faqs.clear();
      final Stream<FaqModel> stream = await getFaqs();
      stream.listen((FaqModel faqModel) {
        setState(() => faqs.add(faqModel));
      }, onError: (a) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("Cannot get faqs"),
        ));
        print(a);
      }, onDone: () {

      });
    }
  Future<void> refreshFaqs() async {
    faqs.clear();
    listenForfaqs();
  }
  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

}
