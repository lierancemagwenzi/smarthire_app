class Provider{
  int id;
  String name;

  Provider({this.id, this.name});
  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json["id"],
      name: json['name'],
    );
  }
}