import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthire/src/controllers/category_controller.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/Department.dart';
import 'package:smarthire/src/models/NotificationModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/UserModel.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/Notification.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/global_repository.dart' as globalRepo;
import 'package:smarthire/src/repository/settings_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class HomeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Product> popularproducts = [];
  List<Product> popularservices = [];
  List<ServiceModel> services = [];
  List<SliderModel> sliders = [];

  List<Department> deaprtments=[];

  int notification_count=0;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
   GlobalKey<NavigatorState> navigatorKey;
  AppColorModel appColorModel;

  HomeController() {
    listenForDepartments();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.navigatorKey =
        GlobalKey(debugLabel: "Main Navigator");


  }




  void getDeviceDetrails(BuildContext context) {
      settingsRepo.getDeviceDetails().then((value) {
        print(value);
        setState(() {
         settingsRepo.detailsModel.value=value;
        });

        if(value.identifier!=null){

          init(context);
        }
      });
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




  Future<void> init(BuildContext context) async {
    _firebaseMessaging.requestNotificationPermissions();
    if (!globalRepo.initialized) {
      // For iOS request permission first.

      Future.delayed(Duration(seconds: 1), () {
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");

            setState(() {
              notification_count += 1;
              personalnotifications.add(new NotificationModel(
                  action_id: int.parse(message['data']['action_id']),
                  title: message['notification']['title'],
                  body: message['notification']['body'],
                  seen: 0,
                  user_id: 0));
            });

//            AudioCache player = AudioCache(prefix: 'assets/sounds/');
//            player.play('sound.mp3', volume: 1.0);
            AudioCache _audioCache = AudioCache(
                prefix: "sounds/",
                fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

            _audioCache.play('sound.mp3');
            showFlash(
                context: context,
                duration: Duration(seconds: 5),
                builder: (_, controller) {
                  return Flash(
                    controller: controller,
                    position: FlashPosition.top,
                    style: FlashStyle.grounded,
                    backgroundColor: settingsRepo.appcolor.value.darkcolor,
                    insetAnimationDuration: Duration(seconds: 3),
                    child: FlashBar(

                      icon: Icon(
                        Icons.notifications,
                        size: 36.0,
                        color: Colors.white,
                      ),
                      message: ListTile(title:

                      Text(message['notification']['title'],style: TextStyle(color: Colors.white),),

                      subtitle:  Text(message['notification']['body'],style: TextStyle(color: Colors.white),)),
                      ),



                  );
                });
//             Flushbar(
//               flushbarPosition: FlushbarPosition.TOP,
//               reverseAnimationCurve: Curves.decelerate,
//               forwardAnimationCurve: Curves.elasticOut,
//               flushbarStyle: FlushbarStyle.FLOATING,
//               backgroundColor: appColorModel.maincolor,
// //            message:
// //                "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
//
//               titleText: Text(
//                 "hey",
//                 style: TextStyle(color: Colors.white),
//               ),
//               dismissDirection: FlushbarDismissDirection.HORIZONTAL,
//               isDismissible: true,
//               messageText: Text(
//                "hello",
//                 style: TextStyle(color: Colors.white),
//               ),
//
//               icon: Icon(
//                 Icons.notifications,
//                 size: 28.0,
//                 color: Colors.white,
//               ),
//               duration: Duration(seconds: 6),
//               leftBarIndicatorColor: Colors.blue[300],
//             )..show(context);

//          showAlertDialog(context);

//          _showItemDialog(message);
          },
          onBackgroundMessage: myBackgroundMessageHandler,
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            // navigatorKey.currentState.push(MaterialPageRoute(
            //     builder: (_) => FcmNotifications(
            //       map: message,
            //     )));
//
//            Navigator.push(§§
//                context, SlideRightRoute(page: NotificationScreen()));

//          showAlertDialog(context);
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => NotificationWidget()));
          },
          onResume: (Map<String, dynamic> message) async {
            // navigatorKey.currentState.push(MaterialPageRoute(
            //     builder: (_) => FcmNotifications(
            //       map: message,
            //     )));
            print("onResume: $message");

            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => NotificationWidget()));
//            Navigator.push(
//                context, SlideRightRoute(page: NotificationScreen()));

//          showAlertDialog(context);

//          Navigator.push(context, SlideRightRoute(page: NotificationScreen()));
//          _navigateToItemDetail(message);
          },
        );

        // For testing purposes print the Firebase Messaging token

        globalRepo. initialized = true;
      });
    }
    String token = await _firebaseMessaging.getToken();
if(currentuser.value.id!=0){
  RegisterToken(token: token,id: currentuser.value.id,  identifier: settingsRepo.detailsModel.value.identifier,deviceName: settingsRepo.detailsModel.value.deviceName,deviceVersion: settingsRepo.detailsModel.value.deviceVersion);

}

    _firebaseMessaging.subscribeToTopic("generalnotifications");

    print("FirebaseMessaging token: $token");

    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ token: $token");
  }




  void Logout(BuildContext context) {

    int user_id=currentuser.value.id;
    String device=detailsModel!=null?detailsModel.value.identifier:"unknown";
    LogoutUser(user_id,device).then((value) async {
      print(value);
      if(value==null){
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text("An error occurred"),
        ));
      }
      else{
         if(value==201){
           final pref = await SharedPreferences.getInstance();
           await pref.clear();

           setState(() {
             currentuser.value=new UserModel(id: 0);
           });
           RefreshHome(context);
          // Navigator.pushReplacement(context,
          //     CupertinoPageRoute(builder: (context) => Home()));
        }

      }
    });
  }

void RefreshHome(BuildContext context){
  Navigator.pushReplacement(context,
      CupertinoPageRoute(builder: (context) => Home()));
}

  bool   carthaservice1(){
    int count=0;

    for(int i=0;i<cart.value.length;i++){

      if(cart.value[i].product.product_type.toLowerCase()=="service"){

        count=count+1;
      }
    }
    return count>1;
}

}


