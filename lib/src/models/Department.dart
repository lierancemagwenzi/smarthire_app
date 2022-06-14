import 'package:smarthire/constants/globals.dart' as global;

class Department {
  int id;
  String service_name;
  String banner;
  Department({this.service_name, this.id, this.banner});
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json["id"],
      banner:json["banner"],
      service_name: json['name'],
    );
  }
}
