class StageModel {
  int id;
  String stage;
  String date;

  StageModel({this.id, this.stage, this.date});
  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json["id"],
      stage: json['stage'],
      date: json['created_at'],
    );
  }
}
