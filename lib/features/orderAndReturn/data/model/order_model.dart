import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/return_details_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/shipping_model.dart';

import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:e_com_user/general/utils/enums/payement_method.dart';
import 'package:e_com_user/general/utils/enums/payment_status.dart';

class OrderModel {
  final String orderId;
  final String orderNumber;
  final String userId;
  final String userName;
  final String userPhone;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final double amount;
  final List<OrderItemSummary> items;
  final ShippingAddress shippingAddress;
  final ReturnDetails? returnDetails;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? cancellationReason;

  const OrderModel({
    required this.orderId,
    required this.orderNumber,
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
    required this.createdAt,
    this.deliveredAt,
    this.cancellationReason,
    this.returnDetails,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      orderId: id,
      userId: map['userId'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      date: () {
        final v = map['date'] ?? map['createdAt'];
        if (v == null) return DateTime.now();
        if (v is Timestamp) return v.toDate();
        if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
        return DateTime.now();
      }(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (map['paymentMethod'] as String? ?? '').toLowerCase(),
        orElse: () => PaymentMethod.cod,
      ),
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
      createdAt: () {
        final v = map['createdAt'] ?? map['date'];
        if (v == null) return DateTime.now();
        if (v is Timestamp) return v.toDate();
        if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
        return DateTime.now();
      }(),
      deliveredAt: () {
        final v = map['deliveredAt'];
        if (v == null) return null;
        if (v is Timestamp) return v.toDate();
        if (v is String) return DateTime.tryParse(v);
        return null;
      }(),
      cancellationReason: map['cancellationReason'],
      returnDetails: map['returnDetails'] != null
          ? ReturnDetails.fromMap(map['returnDetails'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'orderNumber': orderNumber,
      'userPhone': userPhone,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'orderStatus': orderStatus.name,
      'amount': amount,
      'items': items.map((e) => e.toMap()).toList(),
      'shippingAddress': shippingAddress.toMap(),
      'createdAt': createdAt.toIso8601String(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt!.toIso8601String(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
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
