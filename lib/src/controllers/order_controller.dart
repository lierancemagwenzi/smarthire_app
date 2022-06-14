import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/cart_controller.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/AppColorModel.dart';
import 'package:smarthire/src/models/LikeModel.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/PaymentMethod.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/Seller.dart';
import 'package:smarthire/src/models/service.dart';
import 'package:smarthire/src/models/slider.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/pages/ordersuccess.dart';
import 'package:smarthire/src/repository/address_repository.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/global_repository.dart';
import 'package:smarthire/src/repository/order_repository.dart';
import 'package:smarthire/src/repository/product_repository.dart';
import 'package:smarthire/src/repository/services_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart' as settingsRepo;
import 'package:smarthire/src/repository/product_repository.dart' as productRepo;
import 'package:smarthire/src/repository/cart_repository.dart' as cartRepo;


import 'package:smarthire/src/repository/sliders_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class  OrderController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;

  List<AddressModel> addresses=[];
  AppColorModel appColorModel;
  SellerAccount sellerAccount;



  bool loading=false;
bool gettingorders=false;
  bool success=false;

  OrderController() {
    listenForAppColor();
  }

  List<OrderModel> orders=[];

  List<OrderModel> sentorders=[];
  List<OrderModel> receivedorders=[];

  listenForAppColor(){
    appColorModel=settingsRepo.getAppColor();
  }

  num calculateCartTotal(){
    num subtotal=0.0;
    for(int i=0;i<cartRepo.cart.value.length;i++){
      subtotal=subtotal+(cartRepo.cart.value[i].quantity*Helper.getPriceNum(cartRepo.cart.value[i].product.price)-Helper.getPriceNum(cartRepo.cart.value[i].product.discount));

    }

   return  subtotal+(candeliver?delivery_fee:0);

  }


  AddOrder(){
    if(cart.value.length>0){

      setState(() {
        loading=true;
      });


      OrderModel order=new OrderModel(user_id: currentuser.value.id);

      print(order.toMap());

      order.products=[];
      order.supplier_id=cart.value[0].product.sellerAccount.id;
      order.user_id=currentuser.value.id;
      order.delivery_method_id=delivery_method.value.id;
      order.delivery_Method=delivery_method.value.toMap();
      order.payment_method_id=payment_method.value.id;
      order.payment_Method=payment_method.value.toMap();
      order.address_Model=delivery_address.value.toMap();
      order.address_id=delivery_address.value.id;
      order.amount=calculateCartTotal().toString();
      order.order_type="product";
      order.delivery_fee=candeliver?delivery_fee.toString():0.toString();
      for(int i=0;i<cart.value.length;i++){
        order.products.add(
            {"quantity":cart.value[i].quantity,"product_id":cart.value[i].product.id,"price":cart.value[i].product.price,"discount":cart.value[i].product.discount}
        );
      }

      addneworder(order).then((value) {
          if(value!=null){
            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                loading=false;
                success=true;

                orders.add(value);
              });

            });

            cart.notifyListeners();
          }
          else{
            Future.delayed(const Duration(seconds: 4), () {

              setState(() {

                loading=false;
                success=false;
              });

            });

          }

      });
    }
  }



  void goToOrders(BuildContext context){
    setState(() {
      cartRepo.cart.value.clear();
    });
    Navigator.pushReplacement(context,
        CupertinoPageRoute(builder: (context) => Home(index: 0)));

  }


  goToMtnCheckout(BuildContext context) {
    if(payment_method.value.name==null){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text("Select a payment method"),
      ));
    }

    else{
      if(cartRepo.cart.value.isEmpty){
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => Home(index: 2)));
      }
      else{
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => MTNSuccess()));
      }
    }
  }


  AddServiceOrder(){
    if(cart.value.length>0){
      setState(() {
        loading=true;
      });
      OrderModel order=new OrderModel(user_id: currentuser.value.id);
      print(order.toMap());

      order.products=[];
      order.supplier_id=cart.value[0].product.sellerAccount.id;
      order.user_id=currentuser.value.id;
      order.requested_date=service_requested_date;
      order.delivery_method_id=delivery_method.value.id!=null?delivery_method.value.id:0;
      order.delivery_Method=delivery_method.value.id!=null?delivery_method.value.toMap():null;
      order.payment_method_id=payment_method.value.id!=null?payment_method.value.id:0;
      order.payment_Method=payment_method.value.name!=null?payment_method.value.toMap():null;
      order.address_Model=delivery_address.value.name!=null?delivery_address.value.toMap():null;
      order.address_id=delivery_address.value.id;
      order.order_type="service";
      order.amount="0";
      order.delivery_fee=0.toString();
      for(int i=0;i<cart.value.length;i++){
        order.products.add(
            {"quantity":cart.value[i].quantity,"product_id":cart.value[i].product.id,"price":cart.value[i].product.price,"discount":cart.value[i].product.discount}
        );
      }

      addneworder(order).then((value) {
        if(value!=null){
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              loading=false;
              success=true;

              orders.add(value);
            });

          });

          cart.notifyListeners();
        }
        else{
          Future.delayed(const Duration(seconds: 4), () {
            setState(() {
              loading=false;
              success=false;
            });

          });

        }

      });
    }
  }

  Future<void> refreshOrders() async {
    sentorders.clear();
    listenForSentOrders();
  }


  Future<void> refreshOrders2() async {
    receivedorders.clear();
    listenForReceivedOrders(this.sellerAccount.id);
  }
  Future<void> listenForSentOrders() async {
    if (currentuser.value.id==0
    ) {

    }

    else {
      sentorders.clear();

      setState(() {
        this.gettingorders = true;
      });
      final Stream<OrderModel> stream = await getsentorders();

      stream.listen((OrderModel orderModel) {
        setState(() => sentorders.add(orderModel));
      }, onError: (a) {
        setState(() {
          this.gettingorders = false;
        });

        print(a);
      }, onDone: () {
        setState(() {
          this.gettingorders = false;
        });
      });
    }
  }


  Future<void> listenForReceivedOrders(int id) async {
    if (currentuser.value.id==0
    ) {

    }
    else {
      receivedorders.clear();

      setState(() {
        this.gettingorders = true;
      });
      final Stream<OrderModel> stream = await getreceivedorders(id);

      stream.listen((OrderModel orderModel) {
        setState(() => receivedorders.add(orderModel));
      }, onError: (a) {
        setState(() {
          this.gettingorders = false;
        });

        print(a);
      }, onDone: () {
        setState(() {
          this.gettingorders = false;
        });
      });
    }
  }


  void Cancelorder(int id,int index) {
    cancelorder(id).then((value) {
      print(value);
      setState(() {
        if(value!=null){

          this.receivedorders[index]=value;

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Cancel Order"),
          ));
        }
      });
    });
  }


  void CancelSentorder(int id,int index) {
    cancelorder(id).then((value) {
      print(value);
      setState(() {
        if(value!=null){

          this.sentorders[index]=value;

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Cancel Order"),
          ));
        }
      });
    });
  }


  OrderModel Cancelorderr(int id,int index) {
    cancelorder(id).then((value) {
      print(value);
      setState(() {
        if(value!=null){

          return value;

        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Cancel Order"),
          ));

          return null;
        }
      });
    });
  }

  void DoCancelorder(int id,int index,int seller_id,BuildContext context) {
    cancelorder(id).then((value) {
      print(value);
      setState(() {
        if(value!=null){
          Navigator.pop(context);
          listenForReceivedOrders(seller_id);
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Cancel Order"),
          ));
        }
      });
    });
  }


  void DoCancelSentorder(int id,int index,int seller_id,BuildContext context) {
    cancelorder(id).then((value) {
      print(value);
      setState(() {
        if(value!=null){
          Navigator.pop(context);
          listenForSentOrders();
        }
        else{
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text("Failed To Cancel Order"),
          ));
        }
      });
    });
  }


}


