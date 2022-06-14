import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/checkout_controller.dart';
import 'package:smarthire/src/controllers/order_controller.dart';
import 'package:smarthire/src/elements/CircularLoadingWidget.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/repository/settings_repository.dart';
import 'package:smarthire/src/repository/cart_repository.dart' as cartRepo;

class CashCheckout extends StatefulWidget {

  @override
  _CashCheckoutState createState() => _CashCheckoutState();
}

class _CashCheckoutState extends StateMVC<CashCheckout> {

  OrderController _con;
  _CashCheckoutState() : super(OrderController()) {
    _con = controller;
  }


  @override
  void initState() {

_con.AddOrder();
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
key: _con.scaffoldKey,
        backgroundColor: appcolor.value.bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:_con.loading? IconButton(
            onPressed: () {
          if(_con.loading){


          }

          else{
            if(_con.success){

              _con.goToOrders(context);
            }

            else{

              Navigator.of(context).pop();
            }

          }
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ):null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
           "Order",
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),

       body:  cartRepo.cart.value.isEmpty
              ? CircularLoadingWidget(height: 500)
              : Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                                Colors.green.withOpacity(1),
                                Colors.green.withOpacity(0.2),
                              ])),
                          child: _con.loading
                              ? Padding(
                            padding: EdgeInsets.all(55),
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
                            ),
                          )
                              : Icon(
                          _con.success?  Icons.check:Icons.error,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 90,
                          ),
                        ),
                        Positioned(
                          right: -30,
                          bottom: -50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20,
                          top: -50,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        _con.loading?"placing your order":_con.success?"Your order has been successfully submitted":"Failed to place order",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w800,fontSize: 16.0,color: appcolor.value.darkcolor)),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      color: appcolor.value.bgColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "SubTotal",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(_con.subTotal.toString(), context, style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: '0')
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Delivery Fee",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            if (_con.candeliver)
                              Helper.getPrice(fee_per_km.toString(), context,
                                  style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: "free")
                            else
                              Helper.getPrice("0", context, style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: "free")
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Total",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(_con.total.toString(), context,
                                style: Theme.of(context).textTheme.headline4.merge(TextStyle(color:Colors.white,fontSize: 14.0)), zeroPlaceholder: 'Free'),
                          ],
                        ),

                        SizedBox(height: 10),
                        Stack(
                          fit: StackFit.loose,
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: FlatButton(
                                onPressed: () {
                                  _con.goToOrders(context);
                                },
                                disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color:appcolor.value.darkcolor,
                                shape: StadiumBorder(),
                                child: Text(
                                  "My Orders",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              )
            ],
          )
      ),
    );
  }
}
