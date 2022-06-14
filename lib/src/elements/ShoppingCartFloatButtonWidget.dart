import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smarthire/src/pages/Cart.dart';
import 'package:smarthire/src/pages/ServiceCart.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart';

import '../controllers/cart_controller.dart';
import '../repository/user_repository.dart';

class ShoppingCartFloatButtonWidget extends StatefulWidget {
  const ShoppingCartFloatButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartFloatButtonWidgetState createState() => _ShoppingCartFloatButtonWidgetState();
}

class _ShoppingCartFloatButtonWidgetState extends StateMVC<ShoppingCartFloatButtonWidget> {
  CartController _con;

  _ShoppingCartFloatButtonWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        color: Theme.of(context).accentColor,
        shape: StadiumBorder(),
        onPressed: () {
          if (currentuser.value.id != 0) {

            int count=0;

            for(int i=0;i<cart.value.length;i++){

              if(cart.value[i].product.product_type.toLowerCase()=="service"){

                count=count+1;
              }
            }
            if(count>0){

              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ServiceCart()));
            }

            else{
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => Cart()));
            }

            // Navigator.push(context,
            //     CupertinoPageRoute(builder: (context) => Cart()));
          } else {
            Navigator.of(context).pushNamed('/Login');
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 28,
            ),
            Container(
              child: Text(
                cart.value.length.toString(),
                textAlign: TextAlign.center,
                style: appcolor.value.bodyStyle.copyWith(color: Colors.white),
              ),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: appcolor.value.favColor, borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            ),
          ],
        ),
      ),
    );
//    return FlatButton(
//      onPressed: () {
//        print('to shopping cart');
//      },
//      child:
//      color: Colors.transparent,
//    );
  }
}
