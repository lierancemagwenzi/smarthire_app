class OrderStatus{
  int id;
  String status;
  String provider_stage;
  String provider_next_stage;
  String customer_stage;

  String customer_next_stage;

  bool can_cancel;

  String client_explanation;
  String provider_explanation;
  bool canchat;

  OrderStatus({this.id, this.status,this.provider_next_stage,this.provider_stage,this.customer_stage,this.customer_next_stage,this.can_cancel,this.canchat,this.client_explanation,this.provider_explanation});
  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json["id"],
      status: json['status'],
      can_cancel: json['can_cancel'],
      canchat: json['canchat'],

      client_explanation: json['client_explanation'],
      provider_explanation: json['provider_explanation'],

      customer_stage: json['customer_stage'],
      provider_stage: json['provider_stage'],
      provider_next_stage: json['provider_next_stage'],
      customer_next_stage: json['customer_next_stage'],
    );
  }
}