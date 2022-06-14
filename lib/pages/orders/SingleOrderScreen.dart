import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:smarthire/components/ProgressIndicator.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/model/MessageModel.dart';
import 'package:smarthire/model/OrderModel.dart';
import 'package:smarthire/model/StageModel.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/pages/orders/VideoReview.dart';
import 'package:smarthire/pages/orders/showProduct.dart';
import 'package:smarthire/pages/providers/ShowLocation.dart';
import 'package:smarthire/pages/providers/account/UserProductsScreen.dart';
import 'package:smarthire/pages/services/OrderProduct.dart';

import '../../constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:retry/retry.dart';
import 'package:smarthire/constants/Transition.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as global;
import 'package:http/http.dart' as http;
import 'package:smarthire/constants/globals.dart';
import 'package:smarthire/constants/sizeroute.dart';
import 'package:smarthire/model/provider.dart';
import 'package:smarthire/model/service.dart';

import 'package:smarthire/model/slider.dart';
import 'package:smarthire/pages/auth/account.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/jobs/JobsScreen.dart';
import 'package:smarthire/pages/marketplace/MarketPlace.dart';
import 'package:smarthire/pages/orders/CallOutFeeScreen.dart';
import 'package:smarthire/pages/orders/DeliveryFee.dart';
import 'package:smarthire/pages/orders/OrderScreen.dart';
import 'package:smarthire/pages/orders/showProduct.dart';
import 'package:smarthire/pages/orders/showuser.dart';
import 'package:smarthire/pages/providers/CategoryScreen.dart';
import 'package:smarthire/pages/providers/NewService.dart';
import 'package:smarthire/pages/providers/account/UserProductsScreen.dart';
import 'package:smarthire/pages/transactions/TransactionScreen.dart';
import 'package:http/http.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/colors.dart';
import '../../constants/colors.dart';
import '../../constants/colors.dart';
import '../../model/OrderModel.dart';
import '../../model/OrderModel.dart';
import '../../model/OrderModel.dart';
import '../providers/ShowLocation.dart';

class SingleOrderScreen extends StatefulWidget {
  OrderModel orderModel;
MessageModel messageModel;
  SingleOrderScreen({@required this.orderModel,this.messageModel});

  @override
  _SingleOrderScreenState createState() => _SingleOrderScreenState();
}

class _SingleOrderScreenState extends State<SingleOrderScreen> {
  OrderModel orderModel;
  bool ploading = false;
  bool showdetails = false;
  double height;
  double width;
  int current_step = 0;
  List<StageModel> stages = [];

  List<Step> steps = [];

  List services = [];
  List products = [
//    {
//      "id": 0,
//      "key": "pending-provider-response",
//      "step": Step(
//        title: Text("Order placed"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 1,
//      "key": "charge_delivery_fee",
//      "step": Step(
//        title: Text("CallOut Fee Charge"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 1,
//      "key": "order-accepted",
//      "step": Step(
//        title: Text("Order Accepted"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 2,
//      "key": "delivery_fee_paid",
//      "step": Step(
//        title: Text("Call Out Fee Paid"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 4,
//      "key": "payment_made",
//      "step": Step(
//        title: Text("Payment Made"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 5,
//      "key": "out_for_delivery",
//      "step": Step(
//        title: Text("Out for delivery"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 6,
//      "key": "delayed",
//      "step": Step(
//        title: Text("Order delayed"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 7,
//      "key": "arrived",
//      "step": Step(
//        title: Text("Order Arrived"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
//    {
//      "id": 8,
//      "key": "order_completed",
//      "step": Step(
//        title: Text("Completed"),
//        isActive: false,
//        state: StepState.complete,
//        content: Text(""),
//      ),
//    },
  ];

  bool loading = false;

  List<String> conditions = [
    "payment_made",
    "arrived",
    "delayed",
    "callout_fee_paid",
    "out_for_delivery",
    "order_completed",
    "order-declined",
    "provider_cancelled",
    "customer_cancelled"
  ];
  setservices() {
    services = [
      {
        "id": 0,
        "key": "pending-provider-response",
        "step": Step(
          title: Text("Order placed"),
          isActive: false,
          state: StepState.complete,
          content: Text(""),
        ),
      },
      {
        "id": 1,
        "key": "charge_callout_fee",
        "step": Step(
          title: Text("CallOut Fee Charge"),
          isActive: false,
          state: StepState.complete,
          content: Text(orderModel.customer_id == globals.id
              ? "Service Provider needs to charge a call out fee to assess the situation"
              : "This is a fee for you to go assess the customer's needs"),
        ),
      },
      {
        "id": 2,
        "key": "callout_fee_paid",
        "step": Step(
          title: Text("Call Out Fee Paid"),
          isActive: false,
          state: StepState.complete,
          content: Text(orderModel.customer_id == globals.id
              ? "You have to make a payment of the Callout fee.This is a fee to call provider to assess the situtation.After this a quotation is sent to you"
              : "Customer has to make payment to procced.This is a fee to call you to assess the situtation.After this you have to send a quotation to customer"),
        ),
      },
      {
        "id": 3,
        "key": "quotation_sent",
        "step": Step(
          title: Text("Quotation Sent"),
          isActive: false,
          state: StepState.complete,
          content: Text(orderModel.customer_id == globals.id
              ? "You have to make a payment to procced after order has been accepted"
              : "Customer has to make payment to procced"),
        ),
      },
      {
        "id": 4,
        "key": "payment_made",
        "step": Step(
          title: Text("Payment Made"),
          isActive: false,
          state: StepState.complete,
          content: Text(orderModel.customer_id == globals.id
              ? "You have to make a payment to procced after order has been accepted"
              : "Customer has to make payment to procced"),
        ),
      },
      {
        "id": 5,
        "key": "out_for_delivery",
        "step": Step(
          title: Text("Out for delivery"),
          isActive: false,
          state: StepState.complete,
          content: Text(orderModel.customer_id == globals.id
              ? "Service out for delivery after you have paid for it"
              : "Service out for delivery after it has been paid for by customer"),
        ),
      },
      {
        "id": 6,
        "key": "delayed",
        "step": Step(
          title: Text("Order delayed"),
          isActive: false,
          state: StepState.complete,
          content: Text(""),
        ),
      },
      {
        "id": 7,
        "key": "arrived",
        "step": Step(
          title: Text("Order Arrived"),
          isActive: false,
          state: StepState.complete,
          content: Text(orderModel.customer_id == globals.id
              ? "Once your order has arrived"
              : "Once you have delivered Customer's order"),
        ),
      },
      {
        "id": 8,
        "key": "order_completed",
        "step": Step(
          title: Text("Completed"),
          isActive: false,
          state: StepState.complete,
          content: Text(globals.id == orderModel.customer_id
              ? "You have to sign to complete the order.Open order ${orderModel.order_number} from orders in menu after service is complete"
              : "Customer has to sign to complete the order after service is complete"),
        ),
      },
    ];
  }

  setproducts() {
    if (orderModel.delivery == 1) {
      List products = [
        {
          "id": 0,
          "key": "pending-provider-response",
          "step": Step(
            title: Text("Order placed"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Waiting for provider to accept order"
                : "You have to accept or decline the order"),
          ),
        },
        {
          "id": 1,
          "key": "charge_delivery_fee",
          "step": Step(
            title: Text("Delivery Fee Charge"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Provider has to charge delivery fee"
                : "You have to charge delivery fee"),
          ),
        },
        {
          "id": 2,
          "key": "delivery_fee_paid",
          "step": Step(
            title: Text("Call Out Fee Paid"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Dilivery fee"
                : "Delivery fee"),
          ),
        },
        {
          "id": 4,
          "key": "payment_made",
          "step": Step(
            title: Text("Payment Made"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "You have to make a payment to procced after order has been accepted"
                : "Customer has to make payment to procced"),
          ),
        },
        {
          "id": 5,
          "key": "out_for_delivery",
          "step": Step(
            title: Text("Out for delivery"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Product out for delivery after you have paid for it"
                : "Product out for delivery after it has been paid for by customer"),
          ),
        },
        {
          "id": 6,
          "key": "delayed",
          "step": Step(
            title: Text("Order delayed"),
            isActive: false,
            state: StepState.complete,
            content: Text(""),
          ),
        },
        {
          "id": 7,
          "key": "arrived",
          "step": Step(
            title: Text("Order Arrived"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Once your order has arrived"
                : "Once you have delivered Customer's order"),
          ),
        },
        {
          "id": 8,
          "key": "order_completed",
          "step": Step(
            title: Text("Completed"),
            isActive: false,
            state: StepState.complete,
            content: Text(globals.id == orderModel.customer_id
                ? "You have to sign to complete the order.Open order ${orderModel.order_number} from orders in menu after it has arrived"
                : "Customer has to sign to complete the order after it has arrived"),
          ),
        },
      ];
    } else {
      products = [
        {
          "id": 0,
          "key": "pending-provider-response",
          "step": Step(
            title: Text("Order placed"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Waiting for provider to accept order"
                : "You have to accept or decline the order"),
          ),
        },
        {
          "id": 1,
          "key": "order-accepted",
          "step": Step(
            title: Text("Order Accepted"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Provider has to accept order to proceed"
                : "You need to accept or decline order"),
          ),
        },
        {
          "id": 4,
          "key": "payment_made",
          "step": Step(
            title: Text("Payment Made"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "You have to make a payment to procced after order has been accepted"
                : "Customer has to make payment to procced"),
          ),
        },
        {
          "id": 5,
          "key": "out_for_delivery",
          "step": Step(
            title: Text("Out for delivery"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Product out for delivery after you have paid for it"
                : "Product out for delivery after it has been paid for by customer"),
          ),
        },
        {
          "id": 6,
          "key": "delayed",
          "step": Step(
            title: Text("Order delayed"),
            isActive: false,
            state: StepState.complete,
            content: Text(""),
          ),
        },
        {
          "id": 7,
          "key": "arrived",
          "step": Step(
            title: Text("Order Arrived"),
            isActive: false,
            state: StepState.complete,
            content: Text(orderModel.customer_id == globals.id
                ? "Once your order has arrived"
                : "Once you have delivered Customer's order"),
          ),
        },
        {
          "id": 8,
          "key": "order_completed",
          "step": Step(
            title: Text("Completed"),
            isActive: false,
            state: StepState.complete,
            content: Text(globals.id == orderModel.customer_id
                ? "You have to sign to complete the order.Open order ${orderModel.order_number} from orders in menu after it has arrived"
                : "Customer has to sign to complete the order after it has arrived"),
          ),
        },
      ];
    }
  }




  @override
  void initState() {

    SchedulerBinding.instance.addPostFrameCallback((_) {

      if(widget.messageModel!=null){


        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
Navigator.pop(context);

},
          type: CoolAlertType.success,
          text: widget.messageModel.title,
        );
      }

    });
    // TODO: implement initState
    this.orderModel = widget.orderModel;
    setproducts();
    setservices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(

      onWillPop: ()async{

        if(loading){

          return false;
        }

        else{return true;}
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: !conditions.contains(orderModel.order_status)
            ? BottomAppBar(
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
                        Colors.red,
                        Colors.redAccent,
                      ],
                    ),
                  ),
                  child: FlatButton(
                    child: Text(
                      "Cancel Order",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      DeclineOrder();
                    },
                  ),
                ),
              )
            : null,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xfffafafa),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: smarthireDark,
              size: 30.0,
            ),
          ),
          title: Text(
            "Order Details",
            style: TextStyle(
              color: smarthireBlue,
              fontFamily: "mainfont",
            ),
          ),
          bottom: loading
              ? MyLinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(smarthireBlue),
                )
              : null,
        ),
        body: orderModel == null
            ? Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(smarthireBlue),
              ))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: width * 0.4,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: smarthireBlue)),
                              onPressed: () {
                                setState(() {
                                  showdetails = false;
                                });
                              },
                              color: showdetails ? Colors.white : smarthireBlue,
                              textColor: Colors.white,
                              child: Text("Details".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: showdetails
                                          ? smarthireBlue
                                          : Colors.white,
                                      fontFamily: "mainfont")),
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: smarthireBlue)),
                              onPressed: loading
                                  ? null
                                  : () {
                                      setState(() {
                                        showdetails = true;
                                      });
                                      getStages();
                                    },
                              color: showdetails ? smarthireBlue : Colors.white,
                              textColor:
                                  showdetails ? Colors.white : smarthireBlue,
                              child: Text("Tracking Order".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: showdetails
                                          ? Colors.white
                                          : smarthireBlue,
                                      fontFamily: "mainfont")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    showdetails ? OrderTracking() : OrderDetails()
                  ],
                ),
              ),
      ),
    );
  }

  OrderDetails() {
    var dateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(orderModel.date, true);
    var dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateLocal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Color(0xfffafafa),
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Order Id: #" + orderModel.order_number.toString(),
                  style: TextStyle(
                      color: smarthireBlue,
                      fontFamily: "mainfont",
                      fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            formattedDate,
            style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontFamily: "mainfont",
                fontSize: 16.0),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: width,
            color: Color(0xffbdc6c4).withOpacity(0.5),
            child: ListTile(
              leading: Image.asset(
                "assets/image.png",
              ),
              title: Text(
                orderModel.product_name,
                style: TextStyle(
                    color: smarthireDark,
                    fontFamily: "mainfont",
                    fontSize: 24.0),
              ),
              subtitle: Text(
                orderModel.customer_name,
                style: TextStyle(
                    color: Colors.grey, fontFamily: "mainfont", fontSize: 16.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        orderModel.product_type == "product"
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Ordered Quantity".toUpperCase(),
                      style: TextStyle(
                          color: smarthireDark, fontFamily: "open-sans"),
                    ),
                    Text(orderModel.quantity + " X " + orderModel.product_unit,
                        style: TextStyle(
                            color: smarthireDark, fontFamily: "open-sans"))
                  ],
                ),
              )
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Order Status".toUpperCase(),
                style: TextStyle(color: smarthireDark, fontFamily: "open-sans"),
              ),
              Text(orderModel.order_status,
                  style:
                      TextStyle(color: smarthireDark, fontFamily: "open-sans"))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Order Type".toUpperCase(),
                style: TextStyle(color: smarthireDark, fontFamily: "open-sans"),
              ),
              Text(orderModel.product_type,
                  style:
                      TextStyle(color: smarthireDark, fontFamily: "open-sans"))
            ],
          ),
        ),
        CheckboxListTile(
          checkColor: Colors.white,
          activeColor: smarthireDark,
          title: Text("Delivery?".toUpperCase(),
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
          value: orderModel.delivery == 1 ? true : false,
          onChanged: (newValue) {
            setState(() {
//                      checkedValue = newValue;
            });
          },
          controlAffinity:
              ListTileControlAffinity.trailing, //  <-- leading Checkbox
        ),
        ListTile(
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          SlideRightRoute(
//                            page: UserProductsScreen(
//                                providerModel: new ProviderModel(
//                                    provider_id:
//                                        orderModel.provider_id == globals.id
//                                            ? orderModel.customer_id
//                                            : orderModel.provider_id,
//                                    provider_name:
//                                        orderModel.provider_id == globals.id
//                                            ? orderModel.customer_name
//                                            : orderModel.provider_name)),
//                          ));
//                    },
//                    trailing: Icon(
//                      Icons.arrow_forward_ios,
//                      color: smarthireBlue,
//                      size: 30.0,
//                    ),
          title: Text(
              orderModel.provider_id == globals.id
                  ? "Customer"
                  : "Provider".toUpperCase(),
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
          subtitle: Text(
              orderModel.provider_id == globals.id
                  ? orderModel.customer_name
                  : orderModel.provider_name,
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
        ),
        orderModel.product_type == "service" && orderModel.review_video != null
            ? ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideRightRoute(
                        page: ReviewVideoPlayerScreen(
                          url: globals.fileserver + orderModel.review_video,
                        ),
                      ));
                },
                title: Text(
                  "Review Video".toUpperCase(),
                  style:
                      TextStyle(color: smarthireDark, fontFamily: "open-sans"),
                ),
                trailing: Icon(
                  Icons.play_circle_outline,
                  color: smarthireDark,
                  size: 30.0,
                ),
              )
            : Container(),
        ListTile(
          onTap: () {
           getProduct(0);
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: smarthireDark,
            size: 30.0,
          ),
          title: Text("VIEW " + widget.orderModel.product_type.toUpperCase(),
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
          subtitle: Text(orderModel.product_name,
              style: TextStyle(color: smarthireDark, fontFamily: "open-sans")),
        ),
        orderModel.delivery == 1 || orderModel.product_type == "service"
            ? ListTile(
                onTap: () {
                  if (orderModel.coord != null && orderModel.coord.length > 2) {
                    Navigator.push(
                        context,
                        SlideRightRoute(
                            page: GoogleMapsDemo(
                          lat: double.parse(orderModel.coord.split("#")[0]),
                          lang: double.parse(
                            orderModel.coord.split("#")[1],
                          ),
                        )));
                  }
                },
                trailing: orderModel.customer_location == null ||
                        orderModel.customer_location.length < 2
                    ? null
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireDark,
                        size: 30.0,
                      ),
                title: Text("Customer Location".toUpperCase(),
                    style: TextStyle(
                        color: smarthireDark, fontFamily: "open-sans")),
                subtitle: Text(
                    orderModel.customer_location == null ||
                            orderModel.customer_location.length < 2
                        ? "No location"
                        : orderModel.customer_location,
                    style: TextStyle(
                        color: smarthireDark, fontFamily: "open-sans")),
              )
            : (ListTile(
                onTap: () {
                  if (orderModel.product_coords != null &&
                      orderModel.product_coords.length > 2) {
                    Navigator.push(
                        context,
                        SlideRightRoute(
                            page: GoogleMapsDemo(
                          lat: double.parse(
                              orderModel.product_coords.split("#")[0]),
                          lang: double.parse(
                            orderModel.product_coords.split("#")[1],
                          ),
                        )));
                  }
                },
                trailing: orderModel.customer_location == null ||
                        orderModel.customer_location.length < 2
                    ? null
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: smarthireDark,
                        size: 30.0,
                      ),
                title: Text("Provider Location".toUpperCase(),
                    style: TextStyle(
                        color: smarthireDark, fontFamily: "open-sans")),
                subtitle: Text(
                    orderModel.product_address == null ||
                            orderModel.product_address.length < 2
                        ? "No location"
                        : orderModel.product_address,
                    style: TextStyle(
                        color: smarthireDark, fontFamily: "open-sans")),
              )),
      ],
    );
  }

  Widget OrderTracking() {
    return steps.length < 1
        ? Center(child: Container())
        : Container(
            width: width,
            height: height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      accentColor: smarthireBlue,
                    ),
                    child: Stepper(
                      steps: steps,
                      currentStep: current_step,
                      onStepTapped: (step) {
                        setState(() {
                          current_step = step;
                        });
                      },
                      onStepContinue: () {
                        setState(() {
                          if (current_step < steps.length - 1) {
                            current_step = current_step + 1;
                          } else {
                            current_step = 0;
                          }
                        });
                      },
                      onStepCancel: () {
                        setState(() {
                          if (current_step > 0) {
                            current_step = current_step - 1;
                          } else {
                            current_step = 0;
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Future<void> DeclineOrder() async {
    setState(() {
      ploading = true;
    });
    print("sending order");
    try {
      final r = RetryOptions(maxAttempts: 8);
      final response = await r.retry(
        // Make a GET request
        () => http.post(global.url + '/api/decline',
            body: jsonEncode({
              "order_status": orderModel.customer_id == globals.id
                  ? "customer_cancelled"
                  : "provider_cancelled",
              "target_id": orderModel.customer_id == globals.id
                  ? orderModel.provider_id
                  : orderModel.customer_id,
              "order_number": orderModel.id,
            }),
            headers: {
              'Content-type': 'application/json'
            }).timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      setState(() {});
      if (response.statusCode == 201) {
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
            setState(() {
              loading=false;
            });
            Navigator.pop(context);
            // Navigator.pop(context);
          },
          type: CoolAlertType.success,
          text:"Order Cancelled",

        );
      } else {
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          showCancelBtn: false,

          onConfirmBtnTap: (){
            setState(() {
              loading=false;
            });
            Navigator.pop(context);
          },
          type: CoolAlertType.error,
          text:"An error occuured",

        );

        print("failed");
        if (response.statusCode == 401) {}
      }

      setState(() {
        ploading = false;
      });
    } on TimeoutException catch (e) {
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          setState(() {
            loading=false;
          });
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occuured",

      );


      print('kkkkk Timeout Error: $e');
    } on SocketException catch (e) {
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          setState(() {
            ploading=false;
          });
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occuured",

      );


      setState(() {
        ploading = false;
      });
      print('kkkkk Socket Error: $e');
    } on Error catch (e) {
      CoolAlert.show(
        barrierDismissible: false,
        context: context,
        showCancelBtn: false,

        onConfirmBtnTap: (){
          setState(() {
            loading=false;
          });
          Navigator.pop(context);
        },
        type: CoolAlertType.error,
        text:"An error occuured",

      );


      setState(() {
        ploading = false;
      });
      print('kkkkkk General Error: $e');
    }
  }

  getStages() async {
    setState(() {
      steps.clear();
      loading = true;
    });
    var path = "/api/orderstages/" + widget.orderModel.id.toString();
    var response = await get(url + path);
    if (response.statusCode == 201) {
      List<dynamic> list = json.decode(response.body);
      print(list);
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        StageModel stageModel = StageModel.fromJson(list[i]);
        var dateTime =
            DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(stageModel.date, true);
        var dateLocal = dateTime.toLocal();
        String formattedDate = DateFormat('HH:mm').format(dateLocal);

        DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

        var formated = format.parse(stageModel.date);

        var date = DateFormat.yMMMMEEEEd().format(formated);

        Step step = new Step(
          title: Text(stageModel.stage),
          isActive: true,
          state: StepState.complete,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
//                height: height * 0.1,
                child: Text(date + ", " + formattedDate),
              )
            ],
          ),
        );

        steps.add(step);
        stages.add(stageModel);
      }

      if (widget.orderModel.product_type == "service") {
        try {
          var current = services.firstWhere(
              (currency) => currency['key'] == stages[stages.length - 1].stage);
          if (current != null) {
            for (int i = 0; i < services.length; i++) {
              if (services[i]['id'] > current['id'] &&
                  services[i]['key'] != "delayed") {
                steps.add(services[i]['step']);
              }
            }
          }
        } catch (error) {
          setState(() {
            loading = false;
          });
        }
      } else if (widget.orderModel.product_type == "product") {
        try {
          var current = products.firstWhere(
              (currency) => currency['key'] == stages[stages.length - 1].stage);
          if (current != null) {
            for (int i = 0; i < products.length; i++) {
              if (products[i]['id'] > current['id'] &&
                  products[i]['key'] != "delayed") {
                steps.add(products[i]['step']);
              }
            }
          }
        } catch (error) {
          setState(() {
            loading = false;
          });
        }
      }
    } else {}

    setState(() {
      loading = false;
    });
  }

  getProduct(i) async {
    setState(() {
      loading = true;
    });
    var path = "/api/product/" + widget.orderModel.product_id.toString();
    var response = await get(url + path);

    print("response+body" + response.body);
    if (response.statusCode == 201) {
      ProviderModel providerModel =
      ProviderModel.fromJson(json.decode(response.body));
      providerModel.profile_pic = global.fileserver + providerModel.profile_pic;
      Navigator.push(
          context,
          SlideRightRoute(
            page: OrderProductScreen(
providerModel: providerModel,            ),
          ));

    } else {}

    setState(() {
      loading = false;
    });
  }
}
