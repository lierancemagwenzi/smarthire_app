class SliderModel{
  int id;
  String url;

  SliderModel({this.id, this.url});
  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json["id"],
      url: json['url'],
    );
  }
}