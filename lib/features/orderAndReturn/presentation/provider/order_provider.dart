import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/domain/order_repository.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrderProvider with ChangeNotifier {
  final OrderRepository repo;
  OrderProvider(this.repo);
  AppState orderPlaceState = AppState.inital;

  String? error;

  // place order

  Future<void> placeOrder({required OrderModel order}) async {
    try {
      const uuid = Uuid();
      final newOrder = OrderModel(
        orderId: "",
        orderNumber: "ORD-${uuid.v4().substring(0,6).toUpperCase()}",
        userId: order.userId,
        userName: order.userName,
        userPhone: order.userPhone,
        date: order.date,
        paymentMethod: order.paymentMethod,
        paymentStatus: order.paymentStatus,
        orderStatus: order.orderStatus,
        amount: order.amount,
        items: order.items,
        shippingAddress: order.shippingAddress,
      );
      await repo.placeOrder(model: newOrder);
      orderPlaceState = AppState.success;
    } catch (e) {
      log("un error from place order Provider  : $e");
      orderPlaceState = AppState.error;
    }
  }
}
