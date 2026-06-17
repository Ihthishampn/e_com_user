import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderUseCase {
  final FirebaseFirestore firebaseFirestore;
  OrderUseCase(this.firebaseFirestore);

  Future<OrderModel> getOrderById({required String orderId}) {
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  Future<List<OrderModel>> getOrders() {
    // TODO: implement getOrders
    throw UnimplementedError();
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
      );

      await doc.set(order.toMap());
    } catch (e) {
      log("un error from place order repo usecase : $e");
      throw ("un error from place order repo usecase : $e");
    }
  }
}
