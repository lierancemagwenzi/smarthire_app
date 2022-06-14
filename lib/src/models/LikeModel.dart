class LikeModel{
  int  user_id;
    int product_id;
  LikeModel({this.user_id,this.product_id});



  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['product_id'] = product_id;
    map['user_id'] = user_id;
    return map;
  }

}