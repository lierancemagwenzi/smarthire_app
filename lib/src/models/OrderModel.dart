import 'dart:convert';

import 'package:smarthire/model/User.dart';
import 'package:smarthire/src/models/Address.dart';
import 'package:smarthire/src/models/DeliveryMethod.dart';
import 'package:smarthire/src/models/OrderStatus.dart';
import 'package:smarthire/src/models/Payment.dart';
import 'package:smarthire/src/models/PaymentMethod.dart';
import 'package:smarthire/src/models/Product.dart';
import 'package:smarthire/src/models/ProductOrder.dart';
import 'package:smarthire/src/models/QuotationModel.dart';
import 'package:smarthire/src/models/Seller.dart';

class OrderModel{
  int id;
  String status;
  var payment_Method;
  var delivery_Method;
  var address_Model;
  int user_id;
  int payment_id;
  var  products;
  int supplier_id;
  int address_id;
  int payment_method_id;
  int delivery_method_id;

  String callout_fee;
  String available_times;

  AddressModel deliveryAddress;

  PaymentMethod paymentMethod;
  Payment calloutfeemethod;

  DeliveryMethod deliveryMethod;

  Payment payment;
OrderStatus orderStatus;
int status_id;

String amount;
String delivery_date;

UserModel provider;

String order_type;

String delivery_fee;

List<ProductOrder> order_products;
UserModel user;
List<QuotationModel> quotations=[];
SellerAccount sellerAccount;
String requested_date;

String order_date;
String picked_time;
  OrderModel({this.id,this.order_date,this.calloutfeemethod,this.picked_time,this.requested_date,this.amount,this.delivery_date,this.quotations,this.available_times,this.callout_fee,this.sellerAccount,this.order_type,this.order_products,this.user,this.delivery_fee,this.status_id,this.provider,this.payment,this.orderStatus,this.deliveryMethod,this.paymentMethod,this.deliveryAddress, this.status,this.products,this.payment_Method,this.delivery_Method,this.address_Model,this.user_id,this.payment_id,this.supplier_id,this.address_id,this.delivery_method_id});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['payment_method_id'] = payment_method_id;
    map['payment_method'] = payment_Method;
    map['address_id'] = address_id;
    map['delivery_method_id'] = delivery_method_id;
    map['delivery_method'] = delivery_Method;
    map['products'] = products;
    map['amount'] = amount;
    map['user_id'] = user_id;
    map['supplier_id'] = supplier_id;
    map['order_type'] = order_type;
    map['requested_date'] = requested_date;
    map['delivery_fee'] = delivery_fee;
    return map;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      // product_type: json["product_type"],
      user_id: json["user_id"],
      delivery_fee: json["delivery_fee"],

      order_date: json["createdAt"],
      requested_date: json["requested_date"],
      delivery_date: json["delivery_date"],
      callout_fee: json["callout_fee"],
      available_times: json["available_times"],
      order_type: json["order_type"],
      picked_time: json["picked_time"],

      payment_id: json["payment_id"],
      order_products: json['order_products'] != null ? List.from(json['order_products']).map((element) {
        ProductOrder productOrder=ProductOrder.fromJson(element);
        print("order product");
        print((element['product']).toString());
        Product product=element['product']!=null?Product.fromOrder(element['product']):null;

        print(product);
        productOrder.product=product;
        return productOrder;
      }).toList() : [],

      quotations: json['order_quotations'] != null ? List.from(json['order_quotations']).map((element) {
        QuotationModel quotationModel=QuotationModel.fromJson(element);
        print("order order_quotations");

        return quotationModel;
      }).toList() : [],


      delivery_method_id: json["delivery_method_id"],
      payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      deliveryMethod: json['delivery_method'] != null ? DeliveryMethod.fromJson(json['delivery_method']) : null,
      paymentMethod:  json['payment_method'] != null ? PaymentMethod.fromJson(json['payment_method']) : null,
      calloutfeemethod:  json['callout_payment'] != null ? Payment.fromJson(json['callout_payment']) : null,
      deliveryAddress: json['delivery_address'] != null ? AddressModel.fromJson(json['delivery_address']) : null,
      supplier_id: json["provider_id"],
      orderStatus: json['order_status'] != null ? OrderStatus.fromJson(json['order_status']) : null,
      sellerAccount: json['seller_account'] != null ? SellerAccount.fromJson(json['seller_account']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,

      status_id: json["status_id"],

    );
  }

  getOrderProducts(){


  }
}