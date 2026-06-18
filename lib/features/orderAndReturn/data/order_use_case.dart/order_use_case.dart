import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/return_refund_model.dart';
import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderUseCase {
  final FirebaseFirestore firebaseFirestore;
  OrderUseCase(this.firebaseFirestore);

  Future<OrderModel> getOrderById({required String orderId}) {
    throw UnimplementedError();
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final data = await firebaseFirestore.collection("orders").get();
      return data.docs.map((e) => OrderModel.fromMap(e.data(), e.id)).toList();
    } catch (e) {
      log("error while fetch orders usecase: $e");
      throw ("orders fetch error : $e");
    }
  }

  Stream<List<OrderModel>> streamOrders() {
    try {
      final snaps = firebaseFirestore
          .collection('orders')
          .orderBy('date', descending: true)
          .snapshots();
      return snaps.map(
        (q) => q.docs.map((d) => OrderModel.fromMap(d.data(), d.id)).toList(),
      );
    } catch (e) {
      log('streamOrders error: $e');
      return const Stream.empty();
    }
  }

  Future<void> placeOrder({required OrderModel model}) async {
    try {
      final doc = firebaseFirestore.collection("orders").doc();
      final order = OrderModel(
        orderId: doc.id,
        orderNumber: model.orderNumber,
        userId: model.userId,
        userName: model.userName,
        userPhone: model.userPhone,
        date: model.date,
        paymentMethod: model.paymentMethod,
        paymentStatus: model.paymentStatus,
        orderStatus: model.orderStatus,
        amount: model.amount,
        items: model.items,
        shippingAddress: model.shippingAddress,
        createdAt: DateTime.now(),
      );

      await doc.set(order.toMap());
    } catch (e) {
      log("un error from place order repo usecase : $e");
      throw ("un error from place order repo usecase : $e");
    }
  }

  Future<void> placeReturnRequest({
    required String orderId,
    required ReturnDetails details,
  }) async {
    try {
      final doc = firebaseFirestore.collection('orders').doc(orderId);
      await doc.update({'returnDetails': details.toMap()});
    } catch (e) {
      log('placeReturnRequest error: $e');
      throw ('return request error: $e');
    }
  }

  Future<void> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final doc = firebaseFirestore.collection('orders').doc(orderId);
      await doc.update({
        'orderStatus': OrderStatus.cancelled.name,
        'cancellationReason': reason,
      });
    } catch (e) {
      log('cancelOrder error: $e');
      throw ('cancel order error: $e');
    }
  }
}
