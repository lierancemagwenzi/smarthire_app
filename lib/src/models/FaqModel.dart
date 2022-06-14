class FaqModel{
  int id;
  String question;

  String response;

   FaqModel({this.id, this.question,this.response});

  factory     FaqModel.fromJson(Map<String, dynamic> json) {
    return     FaqModel(
      id: json["id"],
      question: json['question'],
      response: json['response'],

    );
  }

}