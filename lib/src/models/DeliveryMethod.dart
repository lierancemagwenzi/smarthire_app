class DeliveryMethod{
  int id;
  String name;
  String description;

  bool selected;
  DeliveryMethod({this.id, this.name,this.selected,this.description});

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) {
    return DeliveryMethod(
      id: json["id"],
      name: json['name'],
    );
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['id'] = id;

    return map;
  }
}