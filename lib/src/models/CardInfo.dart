class CardInfo{
  int id;
  String card;
int user_id;
int payment_method;
String payment_method_name;

   CardInfo({this.id, this.card,this.user_id,this.payment_method,this.payment_method_name});

  factory    CardInfo.fromJson(Map<String, dynamic> json) {
    return    CardInfo(
      id: json["id"],
      payment_method: json['payment_method'],
      card: json['mobile'],
      user_id: json['user_id'],
      payment_method_name: json['payment_method_name'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['card'] = card;
    map['id'] = id;
    map['payment_method'] = payment_method;
    map['user_id'] = user_id;
    return map;
  }

  Map<String, dynamic> toDelete() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }
}