import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:path/path.dart' as thepath;
import 'package:toast/toast.dart' as t;
import 'package:smarthire/model/UploadItem.dart';
import 'package:smarthire/pages/orders/LocationPicker.dart';
import 'package:smarthire/pages/services/AccountProducts.dart';


class FourthScreen extends StatefulWidget {

  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {

  int maxImageNo = 10;
  bool selectSingleImage = false;
  List<Asset> images = List<Asset>();
  String _error = '';
bool uploading=false;
  double height;
  double width;
  List<FileItem> fileitems = [];
  BuildContext context1;
  bool done = false;
  String result = "";
  bool failed = false;
   ProgressDialog pr;

  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;


  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
context1=context;
    pr =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false,);
    return WillPopScope(
      onWillPop: ()async{

        return !uploading;
      },
      child: Scaffold(
bottomNavigationBar:images.length>0? BottomAppBar(
  child: SafeArea(child:         RaisedButton(
      color: smarthireBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {

        UploadFiles();
      },
      child: Text("Upload Product",style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "mainfont"),),
  ),),
):null,
        appBar: AppBar(
          actions: [
            images.length>0?InkWell(
                onTap: (){
                  loadAssets();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Icon(Icons.add_circle,color: smarthireDark,size: 30.0,),
                )):Text(""),
          ],
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            "Add "+globals.productUploadModel.product_type,
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

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:   Text(globals.productUploadModel.product_type+ " Images",style: TextStyle(color: smarthireDark,fontSize: 20.0,fontFamily: "mainfont"),),
            ),
            buildGridView()
          ],),
        ),
      ),
    );
  }


  getmet(Asset asset) async {
    print("clicked");
    var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
    print(path + "***************");
  }

  Widget buildGridView() {
    return  Flexible(

      child:images.length<1?Center(child: InkWell(

          onTap: (){
            loadAssets();
          },
          child: Icon(Icons.add_circle,size: 40.0,color: smarthireDark,))): GridView.count(
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
      ),
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
  initState() {
    globals.tasks.clear();
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
          Future.delayed(const Duration(seconds: 5), () {
            pr.hide().then((isHidden) {
              print(isHidden);
            });
            if(globals.productUploadModel.product_type.toLowerCase()=="product"){
              Navigator.pop(this.context);
              Navigator.pop(this.context);
              Navigator.pop(this.context);
              Navigator.pop(this.context);

            }

            else{

              Navigator.pop(this.context);
              Navigator.pop(this.context);
              Navigator.pop(this.context);
            }
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => AccountProducts()));
            // showSimpleNotification(
            //   Text("Product added successfully.Admins have been notified."),
            //   trailing: Builder(builder: (context) {
            //     return FlatButton(
            //         textColor: Colors.yellow,
            //         onPressed: () {
            //           if (OverlaySupportEntry.of(context) != null) {
            //             OverlaySupportEntry.of(context).dismiss();
            //           }
            //         },
            //         child: Text('Dismiss'));
            //   }),
            //   background: smarthireDark,
            //   autoDismiss: false,
            //   slideDismiss: true,
            // );

            setState(() {
              uploading = false;
              images.clear();
              this.result = "Upload complete";
              done = true;
            });
          });
        } else {
          pr.hide().then((isHidden) {
            print(isHidden);
          });
          t.Toast.show("Failed to upload "+globals.productUploadModel.product_type, context, duration: t.Toast.LENGTH_LONG, gravity:  t.Toast.CENTER);

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
    var taskId = await uploader.enqueue(
      url: globals.url + "/api/saveproduct",
      data: {
        "product_name":globals.productUploadModel.service_name,
        "tag": "",
        "quantity":
    globals.productUploadModel.quantity,
        "unit": globals.productUploadModel.unit,
        "product_type": globals.productUploadModel.product_type,
        "city": globals.productUploadModel.city,
        "product_price":  globals.productUploadModel.price,
        "address":  globals.productUploadModel.location,
        "coord":  globals.productUploadModel.coord,
        "ratios": ratios,
        "product_description":  globals.productUploadModel.description,
        "category_id": globals.productUploadModel.category_id.toString(),
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
    final item =
    globals.tasks.values.elementAt(0);
    pr =  ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false,);

    pr.style(
        message: 'Uploading ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();
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
    CircularPercentIndicator(
     radius: 50.0,
     lineWidth: 5.0,
     percent: progress,
     center: progress==1.0?Icon(Icons.done,color: Colors.white,): Text((progress*100).toString()+"%"),
     progressColor: Color(0xff005f8e),
   )
    // Container(
    //     decoration:
    //     BoxDecoration(color: smarthireDark, shape: BoxShape.circle),
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: new Text(
    //         (progress * 100).toInt().toString() + "%",
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ))
//    CircularPercentIndicator(
//      radius: width*0.6,
//      lineWidth: 5.0,
//      percent: progress,
//      center: Text((progress*100).toInt().toString()+"%",style: TextStyle(color: Colors.white),),
//      progressColor: Color(0xff005f8e),
//    )

        : item.status == UploadTaskStatus.complete
        ? Text("Upload Complete")
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
