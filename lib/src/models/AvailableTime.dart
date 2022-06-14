class  AvailableTime{

  int id;
  String startime;
  String endtime;

  String endtimeerror;

  AvailableTime({this.id, this.startime,this.endtime,this.endtimeerror});

  factory   AvailableTime.fromJson(Map<String, dynamic> json) {
    return   AvailableTime(
      id: json["id"],
      startime: json['starttime'],
      endtime: json['endtime'],

    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['startime'] = startime;
    map['endtime'] = endtime;

    return map;
  }

  Map<String, dynamic> toDelete() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }
}