class DeviceDetailsModel{
  String deviceName;
  String identifier;
  String deviceVersion;


  DeviceDetailsModel({this.deviceName, this.identifier,this.deviceVersion});
  factory DeviceDetailsModel.fromJson(Map<String, dynamic> json) {
    return DeviceDetailsModel(
      deviceName: json["devicename"],
      identifier: json['identifier'],
      deviceVersion: json["deviceversion"],
    );
  }
}