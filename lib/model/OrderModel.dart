class OrderModel {
  int id;
  String order_num;
  String user_profile;
  String provider_name;
  String date;
  int provider_id;
  int product_id;
  String product_name;
  String customer_location;
  String provider_location;
  String calloutfee;
  String coord;
  String longlat;
  String product_gallery;
  String aspect_ratio;
  String product_type;
  String quantity;
  String order_status;
  String order_number;
  int delivery;
  String customer_name;
  String signature;
  String product_unit;
  int customer_id;
  String delivery_date;
  String product_address;
  String product_coords;
  String review_video;

  OrderModel(
      {this.id,
      this.order_num,
      this.provider_name,
      this.date,
      this.review_video,
      this.product_address,
      this.product_coords,
      this.delivery_date,
      this.product_id,
      this.signature,
      this.calloutfee,
      this.order_number,
      this.coord,
      this.quantity,
      this.product_unit,
      this.product_name,
      this.delivery,
      this.customer_location,
      this.longlat,
      this.provider_location,
      this.product_gallery,
      this.aspect_ratio,
      this.product_type,
      this.order_status,
      this.customer_id,
      this.customer_name,
      this.provider_id});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      order_num: json['order_number'],
      provider_name: json['provider_name'],
      date: json['created_at'],
      delivery_date: json['delivery_date'],
      delivery: json['delivery'],
      product_address: json['product_address'],
      product_coords: json['product_coords'],
      order_number: json['order_number'],
      provider_id: json['provider_id'],
      product_type: json["product_type"],
      coord: json['coord'],
      review_video: json['review_video'],
      quantity: json['quantity'],
      product_unit: json['product_unit'],
      signature: json['signature'],
      product_id: json["product_id"],
      calloutfee: json['callout_fee'],
      product_name: json['product_name'],
      customer_location: json['customer_address'],
      provider_location: json['provider_location'],
      longlat: json['long_lat'],
      order_status: json['order_status'],
    );
  }
  factory OrderModel.fromCustomer(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      order_num: json['order_number'],
      customer_name: json['customer_name'],
      date: json['created_at'],
      coord: json['coord'],
      quantity: json['quantity'],
      review_video: json['review_video'],
      product_unit: json['product_unit'],
      signature: json['signature'],
      provider_name: json['provider_name'],
      delivery_date: json['delivery_date'],
      product_id: json["product_id"],
      product_address: json['product_address'],
      product_coords: json['product_coords'],
      delivery: json['delivery'],
      order_number: json['order_number'],
      calloutfee: json['callout_fee'],
      customer_id: json['customer_id'],
      provider_id: json['provider_id'],
      product_type: json["product_type"],
      product_name: json['product_name'],
      customer_location: json['customer_address'],
      provider_location: json['provider_location'],
      longlat: json['long_lat'],
      order_status: json['order_status'],
    );
  }
}
