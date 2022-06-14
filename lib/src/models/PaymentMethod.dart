import 'package:smarthire/src/models/CardInfo.dart';

class  PaymentMethod{
  int id;
  String name;
  int active;
  String card_type;




  CardInfo cardInfo;
   PaymentMethod({this.id, this.name,this.cardInfo,this.card_type});
  factory     PaymentMethod.fromJson(Map<String, dynamic> json) {
    return     PaymentMethod(
      id: json["id"],
      name: json['name'],
      card_type: json['card_type'],
    );
  }

  Map<String, dynamic> toDelete() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['card'] = cardInfo.card;
    return map;
  }
}