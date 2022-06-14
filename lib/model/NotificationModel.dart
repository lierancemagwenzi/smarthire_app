class NotificationModel {
  int id;
  String body;
  String title;
  int seen;
  String unique_id;
  int user_id;
  String date;
  String action;
  int action_id;

  NotificationModel(
      {this.id,
      this.body,
      this.title,
      this.unique_id,
      this.date,
      this.seen,
      this.action_id,
      this.action,
      this.user_id});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json["id"],
        body: json['body'],
        unique_id: json['unique_id'],
        action: json['action'],
        action_id: json['action_id'],
        date: json['created_at'],
        seen: json['seen'],
        user_id: json['user_id'],
        title: json['title']);
  }
}
