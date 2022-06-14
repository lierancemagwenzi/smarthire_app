class UserModel{
  int id;
  String name;
  String mobile;
  String profile_pic;
  int code;

  UserModel({this.id, this.name,this.mobile,this.profile_pic,this.code});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      mobile: json['phone'],
      name: json['name'],
      code: json['code'],
      profile_pic: json['profice_pic'],
    );
  }
}