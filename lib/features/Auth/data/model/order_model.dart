class OrderModel {
  final String orderNumber;
  final DateTime date;
  final int numberOfProducts;
  final String paymentMethod;
  final double amount;
  final String status;

  const OrderModel({
    required this.orderNumber,
    required this.date,
    required this.numberOfProducts,
    required this.paymentMethod,
    required this.amount,
    required this.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderNumber: map['orderNumber'] ?? '',
      date: DateTime.parse(map['date']),
      numberOfProducts: map['numberOfProducts'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,
      'date': date.toIso8601String(),
      'numberOfProducts': numberOfProducts,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'status': status,
    };
  }
}