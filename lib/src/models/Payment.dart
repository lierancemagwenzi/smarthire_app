import 'package:smarthire/src/models/PaymentMethod.dart';

class Payment{
  int id;
  String status;
  String amount;
  int payment_method_id;
  PaymentMethod paymentMethod;

  Payment({this.id, this.status,this.payment_method_id,this.amount,this.paymentMethod});
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json["id"],
      status: json['status'],
      amount: json['amount'],
      payment_method_id: json['payment_method_id'],
      paymentMethod:  json['payment_method'] != null ? PaymentMethod.fromJson(json['payment_method']) : null,
    );
  }
}