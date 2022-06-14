import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:html/parser.dart';
import 'package:smarthire/src/elements/tracking/OrderTracker.dart';
import 'package:smarthire/src/models/OrderModel.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/QuotationModel.dart';
import 'package:smarthire/src/repository/cart_repository.dart';
import 'package:smarthire/src/repository/settings_repository.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class Helper {
  BuildContext context;
  DateTime currentBackPressTime;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }
  static String limitString(String text, {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) + (text.length > limit ? hiddenText : '');
  }

  static num getPriceNum(String price){

    if(int.tryParse(price)!=null){

      return  int.tryParse(price);
    }

    else{
      if(double.tryParse(price)!=null){

        return  double.tryParse(price);
      }

      else{

        return 0;
      }

    }
    return int.tryParse(price) ?? 0;}


  static num getDiscount(String discount){
        if(int.tryParse(discount)!=null){

      return  int.tryParse(discount);
    }

    else{
      if(double.tryParse(discount)!=null){

        return  double.tryParse(discount);
      }

      else{

        return 0;
      }

    }


  }

  static Widget getPrice(String myPrice, BuildContext context, {TextStyle style, String zeroPlaceholder = '-'}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (getPriceNum(myPrice) == 0) {
        return Text('-', style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text:  TextSpan(
          text:  currency,
          style: style ?? style.merge(TextStyle(fontWeight: FontWeight.w400, fontSize: style.fontSize - 6)),
          children: <TextSpan>[
            TextSpan(
              text: myPrice,
              style: style.merge(TextStyle(fontWeight: FontWeight.w400),


            )),
          ],
        ),
      );
    } catch (e) {
      return Text('');
    }
  }


  static Widget getDeliveryPrice(String myPrice, BuildContext context, {TextStyle style, String zeroPlaceholder = '-'}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (getPriceNum(myPrice) == 0) {
        return Text('', style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text:  TextSpan(
          text:  currency,
          style: style ?? style.merge(TextStyle(fontWeight: FontWeight.w400, fontSize: style.fontSize - 6)),
          children: <TextSpan>[
            TextSpan(
                text: myPrice,
                style: style.merge(TextStyle(fontWeight: FontWeight.w400),


                )),
          ],
        ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }
  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }


  static String getTotalOrderPrice(OrderModel orderModel){

    num total=0;
      num subtotal=0.0;
      for(int i=0;i<orderModel.order_products.length;i++){

// print(orderModel.order_products.length);

          subtotal=subtotal+(orderModel.order_products[i].quantity*Helper.getPriceNum(orderModel.order_products[i].price)-Helper.getPriceNum(orderModel.order_products[i].discount));



      }

    total=subtotal+getPriceNum(orderModel.delivery_fee);



    return total.toString();

  }
  static String getProductCover(Product product){

    List<String> images = [];
    List<double> aspect_ratios = [];
    List<String> gallery = product.product_gallery.split("#");
    List<String> ratios = product.aspect_ratio.split("#");

    gallery.removeLast();
    ratios.removeLast();
    for (int i = 0; i < gallery.length; i++) {
      images.add(gallery[i]);
    }
    for (int i = 0; i < ratios.length; i++) {
      aspect_ratios.add(double.parse(ratios[i]));
    }
    return images.length>0?'${GlobalConfiguration().getValue('base_url')}${images[0]}':"";
  }

  static bool cansplit(Product product){
    return  product.coord!=null&& product.coord.split("#").length>1;
  }

 static Future<bool> canDeliver(Product product)async {
    bool can=true;
    can&=delivery_address.value.latitude!=null;
    if(delivery_address.value.latitude!=null){

      Geolocator geolocator=new Geolocator();
    if(Helper.cansplit(product)){
      double distance= await (geolocator.distanceBetween(double.parse(product.coord.split("#")[0]),double.parse(product.coord.split("#")[1]), delivery_address.value.latitude,delivery_address.value.longitude));

      double total=distance/1000;

      can&=total<product.delivery_range??0;
    }
    }

    can&=product.available_for_delivery==1;

    can&=product.availability==1;
    return can;

  }

static String StatusBreak(String status){


    String text= status.replaceAll('_', ' ');


    if (text == null) {
      return null;
    }

    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      final String firstLetter = word.substring(0, 1).toUpperCase();
      final String remainingLetters = word.substring(1);

      return '$firstLetter$remainingLetters';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');

}
  static Future<bool> CanDeliverCart() async {
    Geolocator geolocator=new Geolocator();
    bool can=true;
    can&=delivery_address.value.latitude!=null;
    if(delivery_address.value.latitude!=null){
    for(int i=0;i<cart.value.length;i++){
      if(Helper.cansplit(cart.value[i].product)){
        double distance= await (geolocator.distanceBetween(double.parse(cart.value[i].product.coord.split("#")[0]),double.parse(cart.value[i].product.coord.split("#")[1]), delivery_address.value.latitude,delivery_address.value.longitude));

        double total=distance/1000;

        can&=total<cart.value[i].product.delivery_range??0;
      }

      can&=cart.value[i].product.available_for_delivery==1;

      can&=cart.value[i].product.availability==1;
    }
  }

    return can;}

static String CalculateQuotationTotal(
    List<QuotationModel> quots
    ){
    num total=0;
    for(int i=0;i<quots.length;i++){

      total=total+getPriceNum(quots[i].price);

    }

    return total.toStringAsFixed(2);


}




}
