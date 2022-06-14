class Transaction {
  String type;
  String amount;
  int id;
  int customer_id;
  int provider_id;
  String product;
  String date;
  String order_number;
  int order_id;

  String status;

  Transaction(
      {this.type,
      this.id,
      this.amount,
      this.product,
      this.customer_id,
      this.provider_id,
      this.order_number,
      this.order_id,
      this.status,
      this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      type: json['transaction_type'],
      amount: json['amount'],
      status: json['status'],
      product: json['product_name'],
      customer_id: json['customer_id'],
      provider_id: json['provider_id'],
      date: json['created_at'],
      order_id: json['order_id'],
      order_number: json['order_number'],
    );
  }
}
