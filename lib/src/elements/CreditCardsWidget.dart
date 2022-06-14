import 'package:flutter/material.dart';
import 'package:smarthire/src/controllers/checkout_controller.dart';
import 'package:smarthire/src/elements/NewPaymentInfoDialog.dart';
import 'package:smarthire/src/models/PaymentMethod.dart';
import 'package:smarthire/src/repository/settings_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';


import '../helpers/helper.dart';


// ignore: must_be_immutable
class CreditCardsWidget extends StatelessWidget {
  PaymentMethod  paymentMethod;
  ValueChanged<PaymentMethod> onChanged;
CheckoutController checkoutController;
  CreditCardsWidget({
    this.paymentMethod,
    this.onChanged,this.checkoutController,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
          width: 259,
          height: 165,
          decoration: BoxDecoration(
            color:appcolor.value.bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          width: 275,
          height: 177,
          decoration: BoxDecoration(
            color:appcolor.value.bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 25),
          width: 300,
          height: 195,
          decoration: BoxDecoration(
            color:appcolor.value.bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), blurRadius: 20, offset: Offset(0, 5)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Payment type",
                  style: Theme.of(context).textTheme.caption,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Text(
                      payment_method.value.name,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
                    ),
                    Image.asset(
                      'assets/momopay.jpeg',
                      height: 50,
                      width: 50,
                    ),

                  ],
                ),


                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
payment_method.value.card_type,

                      style: Theme.of(context).textTheme.caption,
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      payment_method.value.cardInfo.card,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(letterSpacing: 1.4)),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
