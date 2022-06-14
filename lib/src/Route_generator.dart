import 'package:flutter/material.dart';
import 'package:smarthire/pages/orders/PayCallOutFee.dart';
import 'package:smarthire/src/elements/AcceptDeclineWidget.dart';
import 'package:smarthire/src/elements/CashCheckout.dart';
import 'package:smarthire/src/elements/MTNCheckout.dart';
import 'package:smarthire/src/models/RouteParameter.dart';
import 'package:smarthire/src/pages/AcceptAvailableTimes.dart';
import 'package:smarthire/src/pages/Login.dart';
import 'package:smarthire/src/pages/PayCallOutFee.dart';
import 'package:smarthire/src/pages/Register.dart';
import 'package:smarthire/src/pages/Verify.dart';
import 'package:smarthire/src/pages/seller/orders/AddAvailableTimes.dart';
import 'package:smarthire/src/pages/seller/orders/AddDeliveryDate.dart';
import 'package:smarthire/src/pages/seller/orders/ChargeCallOutFee.dart';
import 'package:smarthire/src/pages/seller/orders/Confirm.dart';
import 'package:smarthire/src/pages/seller/orders/CreateQuotationScreen.dart';
import 'package:smarthire/src/pages/seller/orders/TrackingNeutral.dart';
import 'package:smarthire/src/pages/sentorders/CompleteOrder.dart';
import 'package:smarthire/src/pages/sentorders/PayQuotation.dart';
import 'package:smarthire/src/pages/sentorders/RequestQuotation.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {


      case '/add_delivery_date':
        return MaterialPageRoute(builder: (_) => AddDeliveryDate(orderModel: args,));
    case '/confirm_callout_payment':
    return MaterialPageRoute(builder: (_) => ConfirmPayment(orderModel: args,));
      case '/request_quotation':
        return MaterialPageRoute(builder: (_) => RequestQuotation(orderModel: args,));
      case '/complete_order':
        return MaterialPageRoute(builder: (_) => CompleteOrderWidget(orderModel: args,));
      case '/create_quotation':
        return MaterialPageRoute(builder: (_) => CreateQuotationwidget(orderModel: args,));

      case '/pay_quotation':
        return MaterialPageRoute(builder: (_) => PayQuotation(orderModel: args,));
      case '/accept_available_times':
        return MaterialPageRoute(builder: (_) => AcceptAvailableTimes(orderModel: args,));
      case '/pay_call_out':
        return MaterialPageRoute(builder: (_) => PayCallOutFeeWidget(orderModel: args,));
      case '/goto_tracking':
        return MaterialPageRoute(builder: (_) => TrackingNeutral(orderModel: args,));
      case '/add_available_times':
        return MaterialPageRoute(builder: (_) => AddAvailableTimes(orderModel: args,));
      case '/charge_call_out_fee':
        return MaterialPageRoute(builder: (_) => ChargeCallOutFeeWidget(orderModel: args,));
      case '/action_order':
        return MaterialPageRoute(builder: (_) => AcceptDeclineOrderWidget(orderModel: args,));
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/cash':
        return MaterialPageRoute(builder: (_) => CashCheckout());

      case '/mtn':
        return MaterialPageRoute(builder: (_) => MTNCheckout());

      case '/Register':
        return MaterialPageRoute(builder: (_) => RegistrationScreen());

      case '/Verify':
        return MaterialPageRoute(builder: (_) => VerificationScreen());
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Center(child: Text('Route Error')))));
    }
  }
}
