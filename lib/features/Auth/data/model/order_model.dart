
import 'package:e_com_user/features/Auth/data/model/return_refund_model.dart';
import 'package:e_com_user/features/Auth/data/model/shipping_model.dart';
import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:e_com_user/general/utils/enums/payment_status.dart';

class OrderModel {
  final String orderId;
  final String userId;            
  final String userName;         
  final String userPhone;        
  final DateTime date;
  final String paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final double amount;
  final List<OrderItemSummary> items;
  final ShippingAddress shippingAddress;
  final ReturnDetails? returnDetails; 

  const OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.date,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.amount,
    required this.items,
    required this.shippingAddress,
    this.returnDetails,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      orderId: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      paymentMethod: map['paymentMethod'] ?? 'COD',
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == map['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      orderStatus: OrderStatus.values.firstWhere(
        (e) => e.name == map['orderStatus'],
        orElse: () => OrderStatus.pending,
      ),
      amount: (map['amount'] ?? 0).toDouble(),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemSummary.fromMap(e))
          .toList(),
      shippingAddress: ShippingAddress.fromMap(map['shippingAddress'] ?? {}),
      returnDetails: map['returnDetails'] != null 
          ? ReturnDetails.fromMap(map['returnDetails']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus.name,
      'orderStatus': orderStatus.name,
      'amount': amount,
      'items': items.map((e) => e.toMap()).toList(),
      'shippingAddress': shippingAddress.toMap(),
      if (returnDetails != null) 'returnDetails': returnDetails!.toMap(),
    };
  }
}

class OrderItemSummary {
  final String productId;
  final String productName;
  final String variantName; 
  final int quantity;
  final double price;
  final String imageUrl;

  const OrderItemSummary({
    required this.productId,
    required this.productName,
    required this.variantName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItemSummary.fromMap(Map<String, dynamic> map) {
    return OrderItemSummary(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      variantName: map['variantName'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'variantName': variantName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

