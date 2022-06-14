import 'package:smarthire/model/service.dart';
import 'package:smarthire/src/models/Product.dart';

class ProductOrder {
  int quantity;
  Product product;
  String price;
  String discount;



  ProductOrder(
      {
        this.quantity,this.product,this.price,this.discount

      });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      quantity: json["quantity"],
      price: json['price'],
      discount: json['discount'],

    );
  }
}


