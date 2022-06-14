import 'package:flutter/material.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart';


import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key key,
    @required CartController con,
    int position,

  })  : _con = con,_position=position ,     super(key: key);

  final CartController _con;

  final int _position;



  @override
  Widget build(BuildContext context) {
    return cart.value.isEmpty
        ? SizedBox(height: 0)
        : Container(
      height: MediaQuery.of(context).size.height*0.25,
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

            SizedBox(height: 10),
            Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.centerEnd,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: FlatButton(
                    onPressed: () {

                      _con.goToCheckout(context);
                    },
                    disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    color:appcolor.value.darkcolor,
                    shape: StadiumBorder(),
                    child: Text(
                 "Checkout",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Helper.getPrice(_con.total.toString(), context,
                      style: Theme.of(context).textTheme.headline4.merge(TextStyle(color:Colors.white,fontSize: 14.0)), zeroPlaceholder: 'Free'),
                )
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


