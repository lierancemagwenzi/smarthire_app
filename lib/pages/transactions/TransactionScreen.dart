import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:smarthire/model/NotificationModel.dart';
import 'package:smarthire/notifications/PersonalNotifications.dart';
import 'package:smarthire/pages/transactions/Transactions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/constants/globals.dart' as globals;

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return AccountTransactionsScreen();
  }

  @override
  void initState() {
    getDeviceDetails();
    init();

    super.initState();
  }

  init() async {
    globals.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await globals.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

    requestpermission(globals.flutterLocalNotificationsPlugin);
  }

  requestpermission(flutterLocalNotificationsPlugin) async {
    var result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  show(String body, String title) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await globals.flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "magwenzi");
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SingleNotification(
                payload: payload,
              )),
    );
  }

  void getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;

        globals.deviceName = deviceName;
        globals.identifier = identifier;
        globals.deviceVersion = deviceVersion;

        Initialise();

        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
        globals.deviceName = deviceName;
        globals.identifier = identifier;
        globals.deviceVersion = deviceVersion;
        Initialise();

        //UUID for iOS
      }
    } on PlatformException {
      Initialise();

      print('Failed to get platform version');
    }

//if (!mounted) return;
  }

  Initialise() async {
    final r = RetryOptions(maxAttempts: 8);
    final response = await r.retry(
      // Make a GET request
      () => http.get(globals.url + "/socket").timeout(Duration(seconds: 5)),
      // Retry on  socketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      sockets();
    } else {}
  }

  show1(String body, String title, payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await globals.flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  sockets() {
    print(" sockets::" + " sockets called");
    globals.socket = IO.io(globals.apiurl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'setUsname': globals.name} // optional
    });

    globals.socket.on('connect', (_) {
      print('connect');
      globals.socket.emit('change_username', {
        'username': globals.name,
        'id': globals.id,
        'device': globals.identifier != null ? globals.identifier : "unknown"
      });
      setState(() {});
    });

    globals.socket.on('new_notification', (data) {
      var post = jsonDecode(data);
      List<NotificationModel> datalist = [];
      print("new_notification");

      if (globals.id == 0) {
      } else {
        List<dynamic> list = json.decode(data);
        for (int i = 0; i < list.length; i++) {
          NotificationModel notificationModel =
              NotificationModel.fromJson(list[i]);
          setState(() {
            globals.personalnotifications.add(notificationModel);
            globals.received_notifications.add(notificationModel.unique_id);
            if (notificationModel.seen != 1) {
              datalist.add(notificationModel);
            }
          });
        }
        if (datalist.length > 0) {
          UpdateSeen(datalist[0].unique_id, globals.id);

          if (datalist.length > 1) {
            show1("You have some new notifications", "SmartHire Notifications",
                data);
          } else {
            show1(datalist[0].body, datalist[0].title, data);
          }
        } else {}
      }
    });

    globals.socket.on('disconnect', (_) {
      print('disconnect');
    });
    globals.socket.on('fromServer', (_) => print(_));
  }

  Future<void> UpdateSeen(String unique, int id) async {
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/updatenotifications',
            body: jsonEncode({
              "items": unique,
              "id": globals.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      if (response.statusCode == 201) {
        globals.received_notifications.clear();
      } else {
        if (response.statusCode == 401) {}
      }
    } on TimeoutException catch (e) {
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      print('kkkkkk General Error: $e');
    }
  }
}
