import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/model/NotificationModel.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/ProductUploadModel.dart';
import 'package:smarthire/model/TransactionModel.dart';
import 'package:smarthire/model/UploadItem.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';
import 'package:smarthire/model/slider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

IO.Socket socket;

ProductUploadModel productUploadModel;

String usertype;
List<ServiceModel> services = [];
List<SliderModel> sliders = [];
List<ProviderModel> providers = [];
bool initialized = false;
int unseennotifications = 0;

String apiurl = 'http://143.110.254.66:6294/';
var url = 'http://143.110.254.66:6294';
var fileserver = 'http://143.110.254.66/';

// var url = 'http://105.27.158.226:6294';
// String apiurl = 'http://105.27.158.226:6294/';
// var fileserver = 'http://105.27.158.226:4000/sh-console/public/';

Map<String, UploadItem> tasks = {};
String name = "";
String profile = "";
String mobile = "";
int id = 0;
List<OrderModel> orders = [];
List<OrderModel> myorders = [];
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

List<NotificationModel> personalnotifications = [];
String deviceName = "";
String identifier = "";
String deviceVersion = "";
List<ProviderModel> popularproducts = [];
List<ProviderModel> popularservices = [];

List<String> received_notifications = [];
List<Transaction> transactions = [];

bool deleted = false;

bool darkmode=false;

List<String> cities = [
  "Kigali",
  "Kicukiro",
  "Rutongo",
  "Nyanza",
  "Muhanga",
  "Kamonyi",
  "Ruhango",
  "Butare",
  "Gisagara",
  "Nyaruguru",
  "Nyamagabe",
  "Byumba",
  "Ruhengeri",
  "Cyangugu",
  "Gisenyi",
  "Kibungo",
  "Rwamagana",
  "Kibuye"
];

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("backlee: $message");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}


Future<void> RegisterToken(String token) async {
  if (1 == 0) {
  } else {
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(apiurl + 'api/registertoken',
            body: jsonEncode({
              "token": token,
              "user_id": id,
              "device": identifier,
              "name": deviceName,
              "version": deviceVersion,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      if (response.statusCode == 201) {
      } else {}
    } on TimeoutException catch (e) {
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      print('kkkkkk General Error: $e');
    }
  }
}
