import 'package:smarthire/model/service.dart';
import 'package:smarthire/src/models/Seller.dart';

class ProductUploadModel {
  int provider_id;
  String quantity;
  String unit;
  String discount;
  String available_quantity;
  int  delivery_range;
  int available_for_delivery;

  String service_name;
  String description;
  String price;
  int availability;
  String product_gallery;
  int category_id;
  String aspect_ratio;
  String city;
  String product_type;
  String currency = "rwf".toUpperCase();
  String location;
  String coord;

  SellerAccount sellerAccount;

  ProductUploadModel(
      {this.provider_id,
        this.availability,
        this.product_gallery,
        this.aspect_ratio,
        this.service_name,
        this.description,
        this.price,
        this.unit,
        this.available_for_delivery,
        this.delivery_range,
        this.available_quantity,
        this.discount,
        this.quantity,this.sellerAccount,
        this.category_id,
        this.product_type,
        this.location,
        this.city,
        this.coord});
}
