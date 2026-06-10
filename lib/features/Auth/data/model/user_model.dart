
class UserModel {
  final String id;
  final String name;
  final String number;
  final String imageUrl;
  final bool isBlocked;          

  final int totalOrders;
  final double totalAmount;
  final double returnRatio;

  const UserModel({
    required this.id,
    required this.name,
    required this.number,
    this.imageUrl = '',
    this.isBlocked = false,
    this.totalOrders = 0,
    this.totalAmount = 0,
    this.returnRatio = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      number: map['phone'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isBlocked: map['isBlocked'] ?? false,
      totalOrders: map['totalOrders'] ?? 0,
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      returnRatio: (map['returnRatio'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': number,
      'imageUrl': imageUrl,
      'isBlocked': isBlocked,
      'totalOrders': totalOrders,
      'totalAmount': totalAmount,
      'returnRatio': returnRatio,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? number,
    String? imageUrl,
    String? fcmToken,
    bool? isBlocked,
    int? totalOrders,
    double? totalAmount,
    double? returnRatio,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      imageUrl: imageUrl ?? this.imageUrl,
      isBlocked: isBlocked ?? this.isBlocked,
      totalOrders: totalOrders ?? this.totalOrders,
      totalAmount: totalAmount ?? this.totalAmount,
      returnRatio: returnRatio ?? this.returnRatio,
    );
  }
}