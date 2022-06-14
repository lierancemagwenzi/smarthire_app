class ImageUpload {
  String urls;

  ImageUpload({this.urls});
  factory ImageUpload.fromJson(Map<String, dynamic> json) {
    return ImageUpload(
      urls: json['urls'],
    );
  }
}
