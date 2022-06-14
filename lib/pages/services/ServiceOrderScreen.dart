import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as thepath;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/UploadItem.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/review.dart';
import 'package:smarthire/pages/auth/SingleImage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'package:smarthire/pages/orders/VideoPlayer.dart';
import 'package:smarthire/pages/orders/neworder.dart';

bool agree = false;

class ServiceOrderScreen extends StatefulWidget {
  ProviderModel providerModel;
  int index;

  ServiceOrderScreen({@required this.providerModel, this.index});

  @override
  _ServiceOrderScreenState createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  PickResult selectedPlace;
  String error = "";
  double height;
  double width;
  Timer timer;
  bool exists = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool uploading = false;
  BuildContext context;
  BuildContext thecontext;

  bool done = false;
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String result = "";
  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;

  final ImagePicker _picker = ImagePicker();
  File file;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController quantityController = TextEditingController();

  Future UploadFiles() async {
    global.tasks.clear();
    final String savedDir = thepath.dirname(this.file.path);
    final String filename = thepath.basename(this.file.path);
    var fileItem = FileItem(
      filename: filename,
      savedDir: savedDir,
      fieldname: "file",
    );

    final tag = "order upload ${global.tasks.length + 1}";
    var taskId = await uploader.enqueue(
      url: global.url + "/api/savefileorder",
      data: {
        "customer_id": global.id.toString(),
        "target_id": widget.providerModel.provider_id.toString(),
        "delivery": agree ? 1.toString() : 0.toString(),
        "quantity": quantityController.text,
        "product_id": widget.providerModel.service_id.toString(),
        "customer_address": getAddress(),
        "coord": getCoord(),
      },
      files: [fileItem],
      method: UploadMethod.POST,
      tag: tag,
      showNotification: true,
    );

    setState(() {
      uploading = true;
      global.tasks.putIfAbsent(
          tag,
          () => UploadItem(
                id: taskId,
                tag: tag,
                type: MediaType.Video,
                status: UploadTaskStatus.enqueued,
              ));
    });
  }

  @override
  void initState() {
    quantityController.text = 1.toString();
    global.tasks.clear();

    setState(() {
      agree = false;
    });

    _progressSubscription = uploader.progress.listen((progress) {
      final task = global.tasks[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        global.tasks[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
      });
    });
    _resultSubscription = uploader.result.listen((result) {
      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      final task = global.tasks[result.tag];
      if (task == null) return;
      setState(() {
        global.tasks[result.tag] = task.copyWith(status: result.status);
        if (result.statusCode == 200) {
          Future.delayed(const Duration(milliseconds: 500), () {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  thecontext,
                  MaterialPageRoute(
                      builder: (context) => OrderScreen(
                            showback: true,
                          )));
            });

            setState(() {
              uploading = false;
              this.result = "Upload complete";
              done = true;
            });
            Navigator.pop(this.context);

            deleteFile();
          });
        } else {
//          showSimpleNotification(
//              Text(
//                "Failed to upload",
//                style: globals.optionStyle,
//              ),
//              background: Colors.red);
        }
      });
    }, onError: (ex, stacktrace) {
      setState(() {
        result = "upload failed";
        final snackBar = SnackBar(content: Text("Failed to upload"));
        Scaffold.of(context).showSnackBar(snackBar);
      });
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = global.tasks[exp.tag];
      if (task == null) return;
      setState(() {
        global.tasks[exp.tag] = task.copyWith(status: exp.status);
      });
    });

    super.initState();
  }

  Future<void> deleteFile() async {
    try {
      var file = this.file;

      if (await file.exists()) {
        // file exits, it is safe to call delete on it
        await file.delete();
      }
    } catch (e) {
      // error in getting access to the file
    }
  }

  Future<void> fileexists() async {
    if (file != null) {
      try {
        var file = this.file;

        if (await file.exists()) {
          // file exits, it is safe to call delete on it
          setState(() {
            exists = true;
          });
        } else {
          setState(() {
            this.file = null;
            exists = false;
          });
        }
      } catch (e) {
        setState(() {
          this.file = null;
          exists = false;
        });
        // error in getting access to the file
      }
    } else {
      setState(() {
        this.file = null;
        exists = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }

  uploadView() {
    return Container(
      height: height,
      width: width,
      color: smarthireWhite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Saving Your order",
                style: TextStyle(
                    color: smarthireDark,
                    fontFamily: "mainfont",
                    fontSize: 27.0),
              ),
            ),
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.all(20.0),
                itemCount: global.tasks.length,
                itemBuilder: (context, index) {
                  final item = global.tasks.values.elementAt(index);
                  print("${item.tag} - ${item.status}");
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: UploadItemView(
                          item: item,
                          onCancel: cancelUpload,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: smarthireBlue,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    thecontext = context;
    return Scaffold(
      backgroundColor: global.darkmode?Colors.black:Colors.white,
      key: _scaffoldKey,
      body: loading
          ? Center(child: CircularProgressIndicator())
          : uploading
              ? uploadView()
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Text(
                          "Check Out",
                          style: TextStyle(
                              color: smarthireDark,
                              fontFamily: "mainfont",
                              fontSize: 24.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        color:global.darkmode?Colors.black: Color(0xfffafafa),
                        child: InkWell(
                          onTap: () async {
                            final PickedFile file = await _picker.getVideo(
                                source: ImageSource.camera,
                                maxDuration: const Duration(seconds: 20));
                            File thefile = File(file.path);
                            Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: VideoPlayerScreen(
                                  file: thefile,
                                  showback: false,
                                ))).then((value) {
                              if (value != null) {
                                if (global.deleted) {
                                  setState(() {
                                    this.file = null;
                                  });
                                } else {
                                  setState(() {
                                    this.file = value;
                                  });
                                }

                                global.deleted = false;
                              } else {
                                if (global.deleted) {
                                  setState(() {
                                    this.file = null;
                                  });
                                } else {}
                                global.deleted = false;
                              }

                              return null;
                            });
                          },
                          child: ListTile(
                            subtitle: Text(
                              "This video will aid the service provider to understand your requirements",
                              style: TextStyle(
                                  fontFamily: "mainfont",
                                  fontSize: 16.0,
                                  color: smarthireDark.withOpacity(0.5)),
                            ),
                            trailing: file != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: VideoPlayerScreen(
                                            file: this.file,
                                            showback: false,
                                          )));
                                    },
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: smarthireDark,
                                    ))
                                : Icon(
                                    Icons.add_circle,
                                    color: smarthireDark,
                                    size: 30.0,
                                  ),
                            title: Text(
                              file != null
                                  ? "Review Video[Change]"
                                  : "Add Review Video",
                              style: TextStyle(
                                  color: smarthireDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  fontFamily: "mainfont"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ServiceLocation(context),
                      SizedBox(
                        height: 7.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: width,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                              Validate();
                            },
                            color: smarthireBlue,
                            textColor: Colors.white,
                            child: Text("Place Order".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: "mainfont")),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                ),
    );
  }

  Validate() {
    print("validate");
    setState(() {
      error = "";
    });
    if (widget.providerModel.product_type == "product") {
      if (selectedPlace == null && agree == false) {
        SendOrder();
      } else if (selectedPlace != null && agree) {
        SendOrder();
      } else {
        if (agree) {
          setState(() {
            error = "Please select an address";
          });

          print("please select ");
        } else {}
      }
    } else {
      if (selectedPlace != null) {
        print("good service adreess");
        SendOrder();
      } else {
        setState(() {
          error = "Please select an address";
        });

        print("null adreess");
      }
    }
  }

  ServiceLocation(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlacePicker(
                      apiKey: "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
                      initialPosition: LocationPicker.kInitialPosition,
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      //usePlaceDetailSearch: true,
                      onPlacePicked: (result) {
                        selectedPlace = result;
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    );
                  },
                ),
              );
            },
            child: ListTile(
              subtitle: selectedPlace != null
                  ? Text(
                      selectedPlace.formattedAddress ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: smarthireDark),
                    )
                  : Container(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ),
              title: Text(
                "Service Location" +
                    (selectedPlace == null ? "[Add]" : "[Change]"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: smarthireDark),
              ),
            )),
      ],
    );
  }

  String getAddress() {
    if (widget.providerModel.product_type == "product") {
      if (selectedPlace == null && agree == false) {
        return "";
      } else {
        return selectedPlace.formattedAddress;
      }
    } else {
      return selectedPlace.formattedAddress;
    }
  }

  getCoord() {
    if (widget.providerModel.product_type == "product") {
      if (selectedPlace == null && agree == false) {
        return [0, 0];
      } else {
        return selectedPlace.geometry.location.lat.toString() +
            "#" +
            selectedPlace.geometry.location.lng.toString();
      }
    } else {
      return selectedPlace.geometry.location.lat.toString() +
          "#" +
          selectedPlace.geometry.location.lng.toString();
    }
  }

  Future<void> SendOrder() async {
    if (file != null && widget.providerModel.product_type == "service") {
      UploadFiles();
    } else {
      setState(() {
        loading = true;
      });
      print("sending order");
      try {
        final r = RetryOptions(maxAttempts: 8);
        final response = await r.retry(
          // Make a GET request
          () => http.post(global.url + '/api/saveorder',
              body: jsonEncode({
                "customer_id": global.id,
                "target_id": widget.providerModel.provider_id,
                "delivery": agree ? 1 : 0,
                "quantity": quantityController.text,
                "product_id": widget.providerModel.service_id,
                "customer_address": getAddress(),
                "coord": getCoord(),
              }),
              headers: {
                'Content-type': 'application/json'
              }).timeout(Duration(seconds: 5)),
          retryIf: (e) => e is SocketException || e is TimeoutException,
        );
        setState(() {});
        if (response.statusCode == 201) {
          OrderModel orderModel =
              OrderModel.fromCustomer(jsonDecode(response.body));
          global.myorders.add(orderModel);

          showInSnackBar("Order placed successfully");
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              loading = false;
            });

            Navigator.pushReplacement(
                thecontext,
                MaterialPageRoute(
                    builder: (context) =>
                        SingleOrderScreen(orderModel: orderModel)));
          });

          print("inserted");

          setState(() {});
        } else {
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
          print("failed");
          if (response.statusCode == 401) {}
        }
      } on TimeoutException catch (e) {
        showInSnackBar("An error Occured.Try again");
        print('kkkkk Timeout Error: $e');
      } on SocketException catch (e) {
        showInSnackBar("An error Occured.Try again");

        setState(() {
          loading = false;
        });
        print('kkkkk Socket Error: $e');
      } on Error catch (e) {
        showInSnackBar("An error Occured.Try again");

        print('kkkkkk General Error: $e');
      }
    }
  }
}
