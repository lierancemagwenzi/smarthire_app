class CallOutPayment{
  int id;
  String status;
  String amount;
  int payment_method_id;

  CallOutPayment({this.id, this.status,this.payment_method_id,this.amount});
  factory CallOutPayment.fromJson(Map<String, dynamic> json) {
    return CallOutPayment(
      id: json["id"],
      status: json['status'],
      amount: json['amount'],
      payment_method_id: json['payment_method_id'],
    );
  }
}