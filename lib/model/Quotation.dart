class Quotation {
  String item;
  String price;
  String description;
  String quantity;
  String unit;
  int id;

  Quotation(
      {this.item,
      this.id,
      this.price,
      this.quantity,
      this.unit,
      this.description});
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['item'] = item;
    map['price'] = price;
    map['quantity'] = quantity;
    map['unit'] = unit;
    map['description'] = description;
    return map;
  }

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json["id"],
      price: json['price'],
      item: json['item'],
      description: json['description'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }
}
