import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/model/ImageUpload.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';

class CompleteOrder extends StatefulWidget {
  OrderModel orderModel;
  CompleteOrder({@required this.orderModel});
  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  ByteData _img = ByteData(0);
  var color = Colors.red;
  bool loading = false;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();
  double height;
  double width;
  save() async {
    final Image image = Image.memory(_img.buffer.asUint8List());

    File file = File.fromRawPath(_img.buffer.asUint8List());

    Directory tempDir = await getTemporaryDirectory();
    final file1 = await new File('${tempDir.path}/image.jpg').create();
    file1.writeAsBytesSync(_img.buffer.asUint8List());
    _upload(file1);
    print("********************path" + file1.path);
  }

  void handleClick(String value) {
    switch (value) {
      case 'See Order':
        Navigator.push(
            context,
            SlideRightRoute(
                page: SingleOrderScreen(
              orderModel: widget.orderModel,
            )));
        break;
        break;
      case 'Add Custom Product':
        break;
    }
  }

  Future<void> Complete(String url) async {
    setState(() {
      loading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(globals.url + '/api/completeorder',
            body: jsonEncode({
              "order_status": "order_completed",
              "signature": url,
              "target_id": widget.orderModel.provider_id,
              "order_number": widget.orderModel.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
//        Navigator.pop(context);
        Navigator.pop(context);
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Signature Sent.Order Completed",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: smarthireBlue);
        setState(() {});
      } else if (response.statusCode == 203) {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 3000), () {
          showSimpleNotification(
            AutoSizeText(
              "Your request failed::" + json.decode(response.body),
              maxLines: 1,
            ),
            trailing: Builder(builder: (context) {
              return FlatButton(
                  textColor: Colors.yellow,
                  onPressed: () {
                    if (OverlaySupportEntry.of(context) != null) {
                      OverlaySupportEntry.of(context).dismiss();
                    }
                  },
                  child: Text('Dismiss'));
            }),
            background: smarthireBlue,
            autoDismiss: false,
            slideDismiss: true,
          );
//                  Navigator.pop(context);
        });
      } else {
        if (response.statusCode == 401) {}
      }

      setState(() {
        loading = false;
      });
    } on TimeoutException catch (e) {
      showSimpleNotification(
          Container(
              height: height * 0.1,
              child: Center(
                  child: Text(
                "An error Occured.Try again",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ))),
          background: Colors.redAccent);
      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      showSimpleNotification(
          Container(
              height: height * 0.1,
              child: Center(
                  child: Text(
                "An error Occured.Try again",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ))),
          background: Colors.redAccent);
      setState(() {
        loading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      showSimpleNotification(
          Container(
              height: height * 0.1,
              child: Center(
                  child: Text(
                "An error Occured.Try again",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ))),
          background: Colors.redAccent);
      setState(() {
        loading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }

  void _upload(File file) {
    if (file == null) {
    } else {
      setState(() {
        loading = true;
      });
      String base64Image = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;

      String ext = fileName.split(".").last;

      var newname = new DateTime.now().millisecondsSinceEpoch.toString() +
          globals.id.toString() +
          "." +
          ext;
      http.post(globals.fileserver + "uploads/signatures/api.php", body: {
        "image": base64Image,
        "name": newname,
//      "email": globals.useremail,
      }).then((res) async {
        print("responsefromuploads:" + res.body);

        if (res.statusCode == 200) {
          setState(() {
            file = null;
          });
          ImageUpload imageUpload = ImageUpload.fromJson(json.decode(res.body));
          if (imageUpload.urls.contains("failed")) {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                loading = false;
              });
            });
          } else {
            String a = imageUpload.urls;
            imageUpload.urls = globals.fileserver + imageUpload.urls;
            Complete(a);
          }
        } else {
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              loading = false;
            });
            showSimpleNotification(
                Container(
                    height: height * 0.1,
                    child: Center(
                        child: Text(
                      "An error Occured.Try again",
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ))),
                background: Colors.redAccent);
          });
        }
      }).catchError((err) {
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "An error Occured.Try again",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ))),
            background: Colors.redAccent);
        print(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: _img.buffer.lengthInBytes == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      color: Colors.green,
                      onPressed: () async {
                        final sign = _sign.currentState;
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final image = await sign.getData();
                        var data = await image.toByteData(
                            format: ui.ImageByteFormat.png);
                        sign.clear();
                        final encoded =
                            base64.encode(data.buffer.asUint8List());
                        setState(() {
                          _img = data;
                        });
                        debugPrint("onPressed " + encoded);
                      },
                      child: Text("Save")),
                  MaterialButton(
                      color: Colors.grey,
                      onPressed: _img.buffer.lengthInBytes == 0
                          ? null
                          : () {
                              final sign = _sign.currentState;
                              sign.clear();
                              setState(() {
                                _img = ByteData(0);
                              });
                              debugPrint("cleared");
                            },
                      child: Text("Clear")),
                ],
              )
            : Container(
                height: height * 0.2,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          final sign = _sign.currentState;
                          sign.clear();
                          setState(() {
                            _img = ByteData(0);
                          });
                          debugPrint("cleared");
                        },
                        child: Text("Clear")),
                    Container(
                      width: width,
                      height: 43.0,
                      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 0.9],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Color(0xff1d83ab),
                            Color(0xff0cbab8),
                          ],
                        ),
                      ),
                      child: FlatButton(
                        child: Text(
                          "Send Signature",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Righteous',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          save();
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      appBar: AppBar(
        backgroundColor: smarthireBlue,
        title: Text("Sign and Complete"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: handleClick,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 30.0,
              ),
              itemBuilder: (BuildContext context) {
                return {
                  'See Order',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(color: smarthireBlue),
                    ),
                  );
                }).toList();
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Signature(
                      color: color,
                      key: _sign,
                      onSign: () {
                        final sign = _sign.currentState;
                        debugPrint(
                            '${sign.points.length} points in the signature');
                      },
                      backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                  color: Colors.black12,
                ),
              ),
              _img.buffer.lengthInBytes == 0
                  ? Container()
                  : LimitedBox(
                      maxHeight: 200.0,
                      child: Image.memory(_img.buffer.asUint8List())),
              Column(
                children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  MaterialButton(
//                      onPressed: () {
//                        setState(() {
//                          color =
//                              color == Colors.green ? Colors.red : Colors.green;
//                        });
//                        debugPrint("change color");
//                      },
//                      child: Text("Change color")),
//                  MaterialButton(
//                      onPressed: () {
//                        setState(() {
//                          int min = 1;
//                          int max = 10;
//                          int selection = min + (Random().nextInt(max - min));
//                          strokeWidth = selection.roundToDouble();
//                          debugPrint("change stroke width to $selection");
//                        });
//                      },
//                      child: Text("Change stroke width")),
//                ],
//              ),
                ],
              )
            ],
          ),
          loading
              ? Container(child: Center(child: CircularProgressIndicator()))
              : Text("")
        ],
      ),
    );
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
