import 'dart:async';
import 'dart:ffi';
import 'package:flutter/services.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/model/UploadItem.dart';
import 'package:path/path.dart' as thepath;
import 'package:smarthire/model/service.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';

class NewServiceScreen extends StatefulWidget {
  @override
  _NewServiceScreenState createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  double height;
  double width;
  String message = "";
  List<FileItem> fileitems = [];
  BuildContext context;
  String _platformMessage = 'No Error';
  int maxImageNo = 10;
  bool selectSingleImage = false;
  List<Asset> images = List<Asset>();
  String _nameerror = '';
  String _priceerror = '';
  String quantityerror = "";
  String _categoryerror = '';
  String _typeerror = '';
  String locationerror = '';
  String selectedunit;

  String uniterror = "";
  String cityerror = "";

  List<String> units = [
    "litres",
    "kg",
    "gramms",
    "single",
    "packet",
    "sack",
    "pocket",
    "bucket",
    "ml",
    "pair"
  ];
  String _imageerror = '';
  String _descriptionerror = '';
  String _error = '';
  PickResult selectedPlace;
  String selectedcity;
  String uploadURL = globals.url + "uploads";
  bool uploading = false;
  bool done = false;
  String result = "";
  bool failed = false;

  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;

  String selectedService;
  String methodSelectedValue;

  List<String> services = [];
  List<int> serviceids = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController unitController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  List<String> paymentforms = [
//    "SERVICE",
//    "GOOGLE PAY",
    "PRODUCT".toUpperCase(),
  ];

  Validate() {
    setState(() {
      _nameerror = '';
      _priceerror = '';
      _categoryerror = '';
      _typeerror = '';
      _imageerror = '';
      _descriptionerror = '';
      _typeerror = "";
      quantityerror = "";
      uniterror = "";
      cityerror = "";
    });
    if (nameController.text.length > 0 &&
        priceController.text.length > 0 &&
        selectedcity != null &&
        selectedunit != null &&
        quantityController.text.length > 0 &&
        descriptionController.text.length > 0 &&
        selectedService != null &&
        methodSelectedValue != null &&
        images.length > 0) {
      UploadFiles();
    } else {
      setState(() {
        String error = "";
        if (nameController.text.length < 1) {
          _nameerror += "Product name cannot be empty.";
        }
        if (methodSelectedValue != null &&
            methodSelectedValue == "PRODUCT" &&
            quantityController.text.length < 1) {
          quantityerror += "Product quantity cannot be empty.";
        }

        if (descriptionController.text.length < 1) {
          _descriptionerror += "Product description is required";
        }

        if (priceController.text.length < 1) {
          _priceerror += "Product price cannot be empty.";
        }

        if (images.length < 1) {
          _imageerror += "Select at least one image.";
        }

        if (methodSelectedValue == null) {
          _typeerror += "Select product Type.";
        }
        if (selectedcity == null) {
          cityerror += "Select a city";
        }

        if (selectedService == null) {
          _categoryerror += "Select product category.";
        }
        if (methodSelectedValue != null &&
            methodSelectedValue == "PRODUCT" &&
            selectedunit == null) {
          uniterror += "Product base unit is required";
        }

        if (selectedPlace == null) {
          locationerror += "Select a location.";
        }
        // message = error;
      });
    }
  }

  Widget unitFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Unit",
                  labelStyle: TextStyle(color: smarthireDark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: smarthireDark, width: 0.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
//                  prefixIcon: Icon(Icons.shopping_cart, color: Colors.black),
                  fillColor: smarthireDark),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  hint: Text(
                    "Unit",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: selectedunit,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedunit = newValue;
                    });
                    print(selectedunit);
                  },
                  items: units.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontFamily: "mainfont",
                            color: smarthireDark,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget cityFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "City",
                  labelStyle: TextStyle(color: smarthireDark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: smarthireDark, width: 0.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
//                  prefixIcon: Icon(Icons.shopping_cart, color: Colors.black),
                  fillColor: smarthireDark),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  hint: Text(
                    "City",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: selectedcity,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedcity = newValue;
                    });
                    print(selectedcity);
                  },
                  items: globals.cities.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontFamily: "mainfont",
                            color: smarthireDark,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget methodFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Type",
                  labelStyle: TextStyle(color: smarthireDark),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
//                  prefixIcon: Icon(Icons.shopping_cart, color: smarthireDark),
                  fillColor: smarthireDark),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    "Type",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: methodSelectedValue,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      methodSelectedValue = newValue;
                    });
                    print(methodSelectedValue);
                  },
                  items: paymentforms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontFamily: "mainfont",
                            color: smarthireDark,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget serviceFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  prefixIcon:
                      Icon(Icons.shopping_basket, color: smarthireDark)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    "Category",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: selectedService,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedService = newValue;
                    });
                    print(selectedService);
                  },
                  items: services.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "mainfont",
                            color: smarthireDark,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool isNumber(String value) {
    if (value == null) {
      return true;
    }
    final n = num.tryParse(value);
    return n != null;
  }

  @override
  initState() {
    globals.tasks.clear();
//    images.addAll(widget.images);
    methodSelectedValue = "PRODUCT";
    for (int i = 0; i < globals.services.length; i++) {
      services.add(globals.services[i].service_name);
      serviceids.add(globals.services[i].id);
    }
    _progressSubscription = uploader.progress.listen((progress) {
      final task = globals.tasks[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (task == null) return;
      if (task.isCompleted()) return;
      setState(() {
        globals.tasks[progress.tag] =
            task.copyWith(progress: progress.progress, status: progress.status);
      });
    });
    _resultSubscription = uploader.result.listen((result) {
      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      final task = globals.tasks[result.tag];
      if (task == null) return;
      setState(() {
        globals.tasks[result.tag] = task.copyWith(status: result.status);
        if (result.statusCode == 200) {
          Future.delayed(const Duration(milliseconds: 500), () {
//            showSimpleNotification(
//                Container(
//                    height: height * 0.1,
//                    child: Center(
//                        child: Text(
//                      "Added Successfully",
//                      style: TextStyle(color: Colors.white, fontSize: 14.0),
//                    ))),
//
//
//
//
//
//
//                background: smarthireDark);
            showSimpleNotification(
              Text("Product added successfully.Admins have been notified."),
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
              background: smarthireDark,
              autoDismiss: false,
              slideDismiss: true,
            );

            setState(() {
              uploading = false;
              images.clear();
              this.result = "Upload complete";
              done = true;
            });
            Navigator.pop(this.context);
          });
        } else {
          failed = true;
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
        failed = true;
        result = "upload failed";
        final snackBar = SnackBar(content: Text("Failed to upload"));
        Scaffold.of(context).showSnackBar(snackBar);
      });
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = globals.tasks[exp.tag];
      if (task == null) return;
      setState(() {
        globals.tasks[exp.tag] = task.copyWith(status: exp.status);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }

  getmet(Asset asset) async {
    print("clicked");
    var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
    print(path + "***************");
  }

  Future UploadFiles() async {
    globals.tasks.clear();
    fileitems.clear();
    String ratios = "";
    var now = new DateTime.now();

    for (int i = 0; i < images.length; i++) {
      Asset asset = images[i];
      print(asset.originalHeight.toString() +
          " +++++++++++++++++++++++++++++++++++++++++++++++++++***" +
          asset.originalWidth.toString());
      ratios = ratios +
          (asset.originalWidth / asset.originalHeight).toStringAsFixed(2) +
          "#";

      var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      final String savedDir = thepath.dirname(path);
      final String filename = thepath.basename(path);
      var fileItem = FileItem(
        filename: filename,
        savedDir: savedDir,
        fieldname: "file",
      );
      fileitems.add(fileItem);
    }
    final tag = "smart hire product upload ${globals.tasks.length + 1}";
    final url = uploadURL;
    var taskId = await uploader.enqueue(
      url: globals.url + "/api/saveproduct",
      data: {
        "product_name": nameController.text,
        "tag": "",
        "quantity":
            quantityController.text == null ? "0" : quantityController.text,
        "unit": selectedunit == null ? "one" : selectedunit,
        "product_type": methodSelectedValue,
        "city": selectedcity,
        "product_price": priceController.text,
        "address": selectedPlace.formattedAddress,
        "coord": selectedPlace.geometry.location.lat.toString() +
            "#" +
            selectedPlace.geometry.location.lng.toString(),
        "ratios": ratios,
        "product_description": descriptionController.text,
        "category_id": findId(selectedService).id.toString(),
        "app_user_id": globals.id.toString(),
      },
      files: fileitems,
      method: UploadMethod.POST,
      tag: tag,
      showNotification: true,
    );

    setState(() {
      uploading = true;
      globals.tasks.putIfAbsent(
          tag,
          () => UploadItem(
                id: taskId,
                tag: tag,
                type: MediaType.Video,
                status: UploadTaskStatus.enqueued,
              ));
    });
  }

  ServiceModel findId(String name) =>
      globals.services.firstWhere((book) => book.service_name == name);
  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        var a = getmet(asset);
        print(a);

        print(asset.metadata);

        bool pressed = false;
        return Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                getmet(asset);
              },
              child: Container(
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    images.removeAt(index);
                  });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        size: 20.0,
                        color: Colors.white,
                      )),
                ))
          ],
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    setState(() {
      done = false;
      failed = false;
    });
    String error = '';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 15,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "SMartHire",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: 130.0,
          height: 43.0,
          decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(30.0),
              color: smarthireBlue),
          child: FlatButton(
            child: Text(
              'SAVE ITEM',
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
            onPressed: uploading || globals.id == 0
                ? null
                : () {
                    //                setState(() {
//                  message = "";
//                });
//                Validate();
//              },
                    setState(() {
                      message = "";
                    });

                    Validate();
                  },
          ),
        ),

//        child: Padding(
//          padding: const EdgeInsets.all(14.0),
//          child: Container(
//            height: height*0.1,
//            child: RaisedButton(
//              color: smarthireDark,
//              shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//              onPressed: () {
//                setState(() {
//                  message = "";
//                });
//                Validate();
//              },
//              child: Text("Upload Product / Service".toUpperCase(),style: TextStyle(fontFamily: "mainfont",fontSize: 16.0,color: smarthireWhite),),
//            ),
//          ),
//        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Item",
          style: TextStyle(color: smarthireBlue),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: smarthireDark,
              size: 30.0,
            )),
      ),
      body: uploading
          ? uploading
              ? Container(
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
                            "uploading...",
                            style: TextStyle(color: smarthireDark),
                          ),
                        ),
                        Flexible(
                          child: ListView.separated(
                            padding: EdgeInsets.all(20.0),
                            itemCount: globals.tasks.length,
                            itemBuilder: (context, index) {
                              final item =
                                  globals.tasks.values.elementAt(index);
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
                                color: smarthireDark,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Text("")
          : Container(
              height: height,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: AutoSizeText(
                        _typeerror,
                        maxLines: 1,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    methodFieldWidget(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .02, horizontal: width * .23),
                      child: Text(
                        _nameerror,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nameController,
                        decoration: new InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "product/service name",
                            labelStyle: TextStyle(color: smarthireDark),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
                            hintStyle: new TextStyle(
                                color: smarthireDark,
                                fontFamily: 'mainfont',
                                fontSize: 14.0),
                            hintText: "Service / Product Name",
                            fillColor: smarthireWhite),
                      ),
                    ),
                    methodSelectedValue == "PRODUCT"
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height * .01,
                                horizontal: width * .23),
                            child: AutoSizeText(
                              uniterror,
                              maxLines: 1,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          )
                        : Container(),
                    methodSelectedValue == "PRODUCT"
                        ? unitFieldWidget()
                        : Container(),
                    methodSelectedValue == "PRODUCT"
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height * .02,
                                horizontal: width * .23),
                            child: Text(
                              quantityerror,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          )
                        : Container(),
                    methodSelectedValue == "PRODUCT"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              onChanged: (String newVal) {
                                setState(() {
                                  quantityerror = "";
                                });
                                if (!isNumber(newVal)) {
                                  setState(() {
                                    quantityerror = "Enter a valid number";
                                  });
                                  quantityController.clear();
                                }
                              },
//                        inputFormatters: [
//                          WhitelistingTextInputFormatter.digitsOnly
//                        ],
                              decoration: new InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: "Base Quantity",
                                  labelStyle: TextStyle(color: smarthireDark),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.edit,
                                    color: smarthireDark,
                                  ),
                                  hintStyle: new TextStyle(
                                      color: smarthireDark,
                                      fontFamily: 'mainfont',
                                      fontSize: 14.0),
                                  hintText: "base quantity",
                                  fillColor: smarthireWhite),
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: Text(
                        _priceerror,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        onChanged: (String newVal) {
                          setState(() {
                            _priceerror = "";
                          });
                          if (!isNumber(newVal)) {
                            setState(() {
                              _priceerror = "Enter a valid number";
                            });
                            priceController.clear();
                          }
                        },
                        decoration: new InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Price/Calloutfee",
                            labelStyle: TextStyle(color: smarthireDark),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
//                            labelText: "Price /callout fee",
                            hintStyle: new TextStyle(
                                color: smarthireDark,
                                fontFamily: 'mainfont',
                                fontSize: 14.0),
                            hintText: "Item Price / Callout Fee",
                            fillColor: smarthireWhite),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: Text(
                        _categoryerror,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    serviceFieldWidget(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: AutoSizeText(
                        _descriptionerror,
                        maxLines: 1,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 5, //Normal textInputField will be displayed
                        maxLines: 10,
                        decoration: new InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Description",
                            labelStyle: TextStyle(color: smarthireDark),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: smarthireDark,
                            ),
                            hintStyle: new TextStyle(
                                color: smarthireDark,
                                fontFamily: 'mainfont',
                                fontSize: 14.0),
                            hintText: "Service / Product Description",
                            fillColor: smarthireWhite),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: AutoSizeText(
                        cityerror,
                        maxLines: 1,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    cityFieldWidget(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: AutoSizeText(
                        locationerror,
                        maxLines: 1,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PlacePicker(
                                  apiKey:
                                      "AIzaSyAifHKAGENQ6hWJD2nb5RgKKQCtPkeFs00",
                                  initialPosition:
                                      LocationPicker.kInitialPosition,
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
                        child: Row(
                          children: [
                            Text(
                              "Location",
                              style: new TextStyle(
                                  color: smarthireDark,
                                  fontFamily: 'mainfont',
                                  fontSize: 14.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.add_circle,
                                size: 30.0,
                                color: smarthireDark,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    selectedPlace != null
                        ? Text(selectedPlace.formattedAddress ?? "")
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add A list of Images to support your product below",
                        style: new TextStyle(
                            color: smarthireDark,
                            fontFamily: 'mainfont',
                            fontSize: 14.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .01, horizontal: width * .23),
                      child: Text(
                        _imageerror,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          loadAssets();
                        },
                        child: Container(
                          color: smarthireDark,
                          padding: EdgeInsets.symmetric(
                              vertical: height * .015, horizontal: width * .43),
                          child: Icon(Icons.add, color: smarthireWhite),
                        )),
                    buildGridView(),
                  ],
                ),
              ),
            ),
    );
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
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
        Container(
            decoration:
                BoxDecoration(color: smarthireDark, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text(
                (progress * 100).toInt().toString() + "%",
                style: TextStyle(color: Colors.white),
              ),
            ))
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
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: smarthireDark,
                size: 40.0,
              ),
              onPressed: () => onCancel(item.id),
            ),
          )
        : Container();
    return item.status == UploadTaskStatus.complete
        ? Text(
            "complete",
            style: TextStyle(color: smarthireDark),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[Expanded(child: widget)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    item.status.description,
                    style: TextStyle(
                        color: smarthireDark, fontFamily: 'open-mainfont'),
                  ),
                ],
              ),
              buttonWidget
            ],
          );
  }
}
