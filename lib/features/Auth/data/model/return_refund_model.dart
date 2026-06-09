class ReturnAndRefundModel {
  final DateTime date;
  final String orderNumber;
  final String reason;
  final String status;

  const ReturnAndRefundModel({
    required this.date,
    required this.orderNumber,
    required this.reason,
    required this.status,
  });

  factory ReturnAndRefundModel.fromMap(Map<String, dynamic> map) {
    return ReturnAndRefundModel(
      date: DateTime.parse(map['date']),
      orderNumber: map['orderNumber'] ?? '',
      reason: map['reason'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'orderNumber': orderNumber,
      'reason': reason,
      'status': status,
    };
  }
}