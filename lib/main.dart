import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/src/App.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'model/NotificationModel.dart';
import 'storage/SharedPreferences.dart';
import 'package:smarthire/constants/globals.dart' as globals;

const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup
void showNotification(topic, v, flp, payload) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android, iOS);
  await flp.show(0, topic, '$v', platform, payload: payload);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Workmanager.initialize(callbackDispatcher,
  //     isInDebugMode:
  //         false); //to true if still in testing lev turn it to false whenever you are launching the app
  // await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //     frequency: Duration(minutes: 15), //when should it check the link
  //     initialDelay:
  //         Duration(seconds: 5), //duration before showing the notification
  //     constraints: Constraints(
  //       networkType: NetworkType.connected,
  //     ));

  await GlobalConfiguration().loadFromAsset("app_settings");

  runApp(OverlaySupport(
      child: MaterialApp(debugShowCheckedModeBanner: false, home: App())));
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, iOS);
    flp.initialize(initSetttings);
    var var1;
    int id;
    var1 = await SharedPreferencesTest.getAppUser();
    print("mainn" + var1.toString());
    print(var1.length);

    if (var1.length > 0) {
      id = int.parse(var1[3]);
    } else {
      id = 0;
    }

    globals.personalnotifications.clear();
    List<NotificationModel> data = [];
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
      () => http
          .get(globals.url + '/api/notifications/' + id.toString())
          .timeout(Duration(seconds: 5)),
      // Retry on  socketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print("personalnotifications:::::" + response.body);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      for (int i = 0; i < list.length; i++) {
        NotificationModel notificationModel =
            NotificationModel.fromJson(list[i]);

        globals.received_notifications.add(notificationModel.unique_id);

        globals.personalnotifications.add(notificationModel);
        if (notificationModel.seen == 0) {
          data.add(notificationModel);
        }
      }
      if (data.length > 0) {
        if (data.length > 1) {
          showNotification(
              "SmartHire ", "You have new notifications", flp, response.body);
        } else {
          showNotification(data[0].title, data[0].body, flp, response.body);
        }
      } else {}

//      UpdateSeen(globals.received_notifications, id);
    } else {}

    return Future.value(true);
  });
}
