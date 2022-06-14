import 'package:smarthire/model/service.dart';
import 'package:smarthire/src/models/Seller.dart';

class Product {
  int provider_id;
  int id;
  String quantity;
  String unit;
  String name;
  String description;
  String provider_name;
  String price;
  int availability;
  String product_gallery;
  int category_id;
  String aspect_ratio;
  String profile_pic;
  String city;
  String product_type;
  String currency = "rwf".toUpperCase();
  String location;
  String coord;
  int  liked;
int selleraccount_id;
  String  discount;
  int  delivery_range;

SellerAccount sellerAccount;
  String available_quantity;
  int available_for_delivery;

  Product(
      {this.provider_id,
        this.sellerAccount,this.selleraccount_id,
        this.availability,
        this.product_gallery,
        this.aspect_ratio,
        this.id,
        this.name,
        this.description,
        this.provider_name,
        this.profile_pic,
        this.price,
        this.unit,this.discount,this.delivery_range,
        this.quantity,
        this.category_id,
        this.product_type,this.available_for_delivery,this.available_quantity,
        this.location,
        this.city,this.liked,
        this.coord});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["service_id"],
      product_type: json["product_type"],
      price: json["price"],
      quantity: json["quantity"],
      unit: json["unit"],
      liked: json["liked"],
      discount: json["discount"],
      available_for_delivery: json["available_for_delivery"],
      available_quantity: json["total_quantity"],
      delivery_range: json["delivery_range"],
      city: json["city"],
      availability: json["availability"],
      category_id: json["category_id"],
      provider_id: json["provider_id"],
      name: json["service_name"],
      description: json["description"],
      coord: json["coord"],
      location: json["address"],
      provider_name: json["provider_name"],
      profile_pic: json["profile_pic"],
      product_gallery: json["product_gallery"],
      aspect_ratio: json["aspect_ratio"],
      selleraccount_id: json["seller_account_id"],
      sellerAccount: json['provider_id'] != null ?
      SellerAccount(id:json['provider_id'],user_id:json['seller_account_user_id'],phone:json['phone'],city: json['seller_city'],latitide: json['latitude'] ,longitude: json['longitude']
          ,name: "provider_name",description: json['seller_description'],opening_time: json['opening_time'],closing_time: json['closing_time'], address: json['address']) : null,

    );
  }


  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json["service_id"],
      product_type: json["product_type"],
      price: json["price"],
      quantity: json["quantity"],
      unit: json["unit"],
      liked: json["liked"],
      discount: json["discount"],
      available_for_delivery: json["available_for_delivery"],
      available_quantity: json["total_quantity"],
      delivery_range: json["delivery_range"],
      city: json["city"],
      availability: json["availability"],
      category_id: json["category_id"],
      provider_id: json["provider_id"],
      name: json["service_name"],
      description: json["description"],
      coord: json["coord"],
      location: json["address"],
      provider_name: json["provider_name"],
      profile_pic: json["profile_pic"],
      product_gallery: json["product_gallery"],
      aspect_ratio: json["aspect_ratio"],
      selleraccount_id: json["seller_account_id"],
      sellerAccount: json['seller_account'] != null ? SellerAccount.fromJson(json['seller_account']) : null,
    );
  }


  factory Product.fromOrder(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      product_type: json["product_type"],
      price: json["product_price"],
      quantity: json["quantity"],
      unit: json["unit"],
      liked: json["liked"],
      discount: json["discount"],
      available_for_delivery: json["available_for_delivery"]==true?1:0,
      available_quantity: json["total_quantity"],
      delivery_range: json["delivery_range"],
      city: json["city"],
      availability: json["availability"]==true?1:0,
      category_id: json["category_id"],
      provider_id: json["seller_account_id"],
      name: json["product_name"],
      description: json["description"],
      coord: json["coord"],
      location: json["address"],
      product_gallery: json["product_gallery"],
      aspect_ratio: json["aspect_ratio"],
      selleraccount_id: json["seller_account_id"],
    );
  }

}
