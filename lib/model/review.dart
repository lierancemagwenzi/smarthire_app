class ReviewModel{
  int id;
  String comment;
  String user_profile;
  String reviewer_name;
  String review_date;
  int provider_id;

  ReviewModel({this.id, this.comment, this.user_profile, this.reviewer_name,
      this.review_date, this.provider_id});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["id"],
      comment: json['comment'],
      user_profile: json['user_profile'],
      reviewer_name: json['reviewer_name'],
      review_date: json['review_date'],
      provider_id: json['provider_id'],
    );
  }
}