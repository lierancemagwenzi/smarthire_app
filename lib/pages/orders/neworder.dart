import 'package:flutter/material.dart';
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
import 'package:smarthire/pages/orders/SingleOrderScreen.dart';
import 'package:smarthire/pages/orders/VideoPlayer.dart';

bool agree = false;

class NewOrderScreen extends StatefulWidget {
  ProviderModel providerModel;
  int index;

  NewOrderScreen({@required this.providerModel, this.index});

  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  PickResult selectedPlace;
  String error = "";
  double height;
  double width;
  Timer timer;
  bool exists = false;

  bool uploading = false;
  BuildContext context;
  bool done = false;

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
          Future.delayed(const Duration(seconds: 1), () {
            showSimpleNotification(
              Text("Order sent successfully"),
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => fileexists());

    this.context = context;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: 130.0,
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
              "Proceed",
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
              if (widget.providerModel.product_type == "product") {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  Validate();
//                save();
                }
              } else {
                Validate();
              }
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Place Order",
          style: TextStyle(color: smarthireBlue),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              deleteFile();
            },
            child: Icon(
              Icons.arrow_back,
              color: smarthireBlue,
            )),
      ),
      body: uploading
          ? uploadView()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            subtitle: Text(widget.providerModel.service_name,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: "sans",
                                    color: smarthireBlue)),
                            title: Text(
                              widget.providerModel.product_type.toUpperCase() +
                                  " name".toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  fontFamily: "sans",
                                  color: smarthireBlue),
                            ),
                          ),
                          widget.providerModel.product_type == "product"
                              ? ListTile(
                                  subtitle: Text(
                                      widget.providerModel.quantity +
                                          widget.providerModel.unit,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: "sans",
                                          color: smarthireBlue)),
                                  title: Text(
                                    "Quantity".toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        fontFamily: "sans",
                                        color: smarthireBlue),
                                  ),
                                )
                              : Container(),
                          ListTile(
                            subtitle: Text(
                                widget.providerModel.currency +
                                    widget.providerModel.price,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: "sans",
                                    color: smarthireBlue)),
                            title: Text(
                              "Price".toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  fontFamily: "sans",
                                  color: smarthireBlue),
                            ),
                          ),
                          widget.providerModel.product_type == "product"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: TextFormField(
                                    style: TextStyle(color: smarthireBlue),
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,

//                  keyboardType: TextInputType.number,
//                  inputFormatters: <TextInputFormatter>[
//                    WhitelistingTextInputFormatter.digitsOnly
//                  ],
                                    decoration: InputDecoration(
//                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: "Quantity",
                                      labelStyle: TextStyle(
                                          color: smarthireBlue, fontSize: 18.0),
                                      hintText: 'quantity',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: smarthireBlue, width: 0.0),
                                      ),
                                      border: new OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: smarthireBlue),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintStyle: new TextStyle(
                                          color: smarthireBlue,
                                          fontFamily: 'sans',
                                          fontSize: 14.0),
                                    ),
                                    validator: (v) {
                                      if (v.trim().isEmpty)
                                        return 'Please enter something';
                                      final n = num.tryParse(v);
                                      if (n == null) {
                                        return '"$v" is not a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              : Container(),
                          widget.providerModel.product_type == "service"
                              ? ServiceLocation()
                              : ProductLocation(),
                          widget.providerModel.product_type == "service"
                              ? InkWell(
                                  onTap: () async {
                                    final PickedFile file =
                                        await _picker.getVideo(
                                            source: ImageSource.camera,
                                            maxDuration:
                                                const Duration(seconds: 20));
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
                                    trailing: file != null && exists
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
                                            child:
                                                Icon(Icons.play_circle_outline))
                                        : Icon(
                                            Icons.add_circle_outline,
                                            color: smarthireBlue,
                                            size: 30.0,
                                          ),
                                    title: Text(
                                      file != null && exists
                                          ? "Review Video[Change]"
                                          : "Add Review Video",
                                      style: TextStyle(color: smarthireBlue),
                                    ),
                                  ))
                              : Container()
                        ],
                      ),
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text("")
                  ],
                ),
              ),
            ),
    );
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
                "Saving order...",
                style: TextStyle(color: smarthireBlue),
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

  ServiceLocation() {
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
                  ? Text(selectedPlace.formattedAddress ?? "")
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
                    fontWeight: FontWeight.bold, color: smarthireBlue),
              ),
            )),
      ],
    );
  }

  ProductLocation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: ThemeData(unselectedWidgetColor: Color(0xff005f8e)),
          child: CheckboxListTile(
            title: AutoSizeText(
              "Delivery?".toUpperCase(),
              maxLines: 1,
              style: TextStyle(color: smarthireBlue),
            ),
            value: agree,
            checkColor: Color(0xff0B1A2D),
            activeColor: Colors.white,
            onChanged: (bool val) {
              setState(() {
                agree = val;
              });
              if (agree) {
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
              } else {}
            },
          ),
        ),
        selectedPlace != null && agree
            ? ListTile(
                onTap: () {
                  print(selectedPlace.formattedAddress);
                },
                subtitle: selectedPlace != null && agree
                    ? Text(selectedPlace.formattedAddress ?? "")
                    : Container(
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                title: Text(
                  "Delivery Adrress".toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: smarthireBlue,
                      fontSize: 18.0),
                ),
              )
            : Text(""),
        Container(
          height: height * 0.03,
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: Colors.grey.withOpacity(0.3),

              width: 2.0,
            ),
          )),
        ),
      ],
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

          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              loading = false;
            });
            showSimpleNotification(
                Container(
                    height: height * 0.1,
                    child: Center(
                        child: Text(
                      "Order placed successfully",
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ))),
                background: smarthireBlue);
            Navigator.pushReplacement(
                context,
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
        showSimpleNotification(
            Container(
                height: height * 0.1,
                child: Center(
                    child: Text(
                  "Timeout Occured.Try again",
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
                  "A network Occured.Try again",
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

        print('kkkkkk General Error: $e');
      }
    }
  }
}

typedef CancelUploadCallback = Future<void> Function(String id);

class UploadItemView extends StatelessWidget {
  final UploadItem item;
  final CancelUploadCallback onCancel;
  double height;
  double width;
  UploadItemView({
    Key key,
    this.item,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ?
//    new CircularPercentIndicator(
//      radius: 50.0,
//      lineWidth: 5.0,
//      percent: progress,
//      center: progress==1.0?Icon(Icons.done,color: Colors.white,): Text((progress*100).toString()+"%"),
//      progressColor: Color(0xff005f8e),
//    )
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Text(
              (progress * 100).toInt().toString() + "%",
              style: TextStyle(color: smarthireDark, fontSize: 26.0),
            ),
          )
//    CircularPercentIndicator(
//      radius: width*0.6,
//      lineWidth: 5.0,
//      percent: progress,
//      center: Text((progress*100).toInt().toString()+"%",style: TextStyle(color: Colors.white),),
//      progressColor: Color(0xff005f8e),
//    )

        : item.status == UploadTaskStatus.complete
            ? Text("")
            : Container(
                height: 50,
                width: 50,
              );
//    final buttonWidget = item.status == UploadTaskStatus.running
//        ? Container(
//            height: 50,
//            width: 50,
//            child: IconButton(
//              icon: Icon(
//                Icons.cancel,
//                color: smarthireDark,
//                size: 40.0,
//              ),
//              onPressed: () => onCancel(item.id),
//            ),
//          )
//        : Container();
    return item.status == UploadTaskStatus.complete
        ? Center(
            child: Text(
              "complete",
              style: TextStyle(
                  color: smarthireDark, fontFamily: "mainfont", fontSize: 26.0),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget,
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  item.status.description,
                  style: TextStyle(
                      color: smarthireDark,
                      fontFamily: 'mainfont',
                      fontSize: 20.0),
                ),
              ),
//              buttonWidget
            ],
          );
  }
}
