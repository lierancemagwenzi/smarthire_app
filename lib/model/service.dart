import 'package:smarthire/constants/globals.dart' as global;

class ServiceModel {
  int id;
  String service_name;
  String banner;
  String type;
  ServiceModel({this.service_name, this.id, this.banner, this.type});
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json["id"],
      banner: global.fileserver + json["banner"],
      service_name: json['name'],
      type: json['type'],
    );
  }
}
