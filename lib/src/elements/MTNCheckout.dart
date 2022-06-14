import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/controllers/order_controller.dart';
import 'package:smarthire/src/elements/CircularLoadingWidget.dart';
import 'package:smarthire/src/elements/CreditCardsWidget.dart';
import 'package:smarthire/src/helpers/Helper.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class MTNCheckout extends StatefulWidget {


  @override
  _MTNCheckoutState createState() => _MTNCheckoutState();
}

class _MTNCheckoutState extends StateMVC<MTNCheckout> {


  OrderController _con;
  _MTNCheckoutState() : super(OrderController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(

            onTap:(){

              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: appcolor.value.darkcolor,)),
        centerTitle: true,
        title: Text(
          "Checkout",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
body: cart.value.isEmpty
    ? CircularLoadingWidget(height: 400)
    : Stack(
  fit: StackFit.expand,
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.only(bottom: 255),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.payment,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  "Payment Mode",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
           "Confirm payment method",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            SizedBox(height: 20),
            new CreditCardsWidget(
                paymentMethod: payment_method.value,
                onChanged: (creditCard) {
                  // _con.updateCreditCard(creditCard);
                }),
            SizedBox(height: 40),

            SizedBox(height: 40),

          ],
        ),
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

              SizedBox(height: 20),
              Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: FlatButton(
                      onPressed: () {

_con.goToMtnCheckout(context);
                      },
                      disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      color:appcolor.value.darkcolor,
                      shape: StadiumBorder(),
                      child: Text(
                        "Confirm Payment",
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
      ),
    ),
  ],
),
    );


  }
}
