class   AddressModel{

  int id;
  String name;
 String address;
double latitude;
double longitude;
String city;
int user_id;

int is_default;

 AddressModel({this.id, this.city,this.address,this.name,this.longitude,this.latitude,this.user_id,this.is_default});

  factory   AddressModel.fromJson(Map<String, dynamic> json) {
    return   AddressModel(
      id: json["id"],
      city: json['city'],
      address: json['address'],
      name: json['name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      is_default: json['is_default'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['city'] = city;
    map['user_id'] = user_id;
    map['address'] = address;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['name'] = name;
    return map;
  }

  Map<String, dynamic> toDelete() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }
}