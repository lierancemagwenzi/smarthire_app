class QuotationModel {
int id;
  String price;
  String name;
int order_id;
  QuotationModel(
      {
        this.id,this.name,this.price,this.order_id
      });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      name: json["name"],
      price: json['price'],

      order_id: json['order_id'],
      id: json['id'],
    );
  }

Map<String, dynamic> toMap() {
  var map = new Map<String, dynamic>();
  map['name'] = name;
  map['price'] = price;
  map['order_id'] = order_id;
  return map;
}

}


