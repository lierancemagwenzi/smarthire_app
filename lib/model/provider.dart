import 'package:smarthire/model/service.dart';

class ProviderModel {
  int provider_id;
  int service_id;
  String quantity;
  String unit;
  String service_name;
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

  ProviderModel(
      {this.provider_id,
      this.availability,
      this.product_gallery,
      this.aspect_ratio,
      this.service_id,
      this.service_name,
      this.description,
      this.provider_name,
      this.profile_pic,
      this.price,
      this.unit,
      this.quantity,
      this.category_id,
      this.product_type,
      this.location,
      this.city,
      this.coord});

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      service_id: json["service_id"],
      product_type: json["product_type"],
      price: json["price"],
      quantity: json["quantity"],
      unit: json["unit"],
      city: json["city"],
      availability: json["availability"],
      category_id: json["category_id"],
      provider_id: json["provider_id"],
      service_name: json["service_name"],
      description: json["description"],
      coord: json["coord"],
      location: json["address"],
      provider_name: json["provider_name"],
      profile_pic: json["profile_pic"],
      product_gallery: json["product_gallery"],
      aspect_ratio: json["aspect_ratio"],
    );
  }
}
