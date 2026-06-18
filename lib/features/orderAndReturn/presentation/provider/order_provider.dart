import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/return_refund_model.dart';
import 'package:e_com_user/features/orderAndReturn/domain/order_repository.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:injectable/injectable.dart';

@injectable
class OrderProvider with ChangeNotifier {
  final OrderRepository repo;
  OrderProvider(this.repo);
  AppState orderPlaceState = AppState.inital;

  String? error;
  // Return request state
  AppState returnRequestState = AppState.inital;
  String? returnError;
  // Orders list for current user
  AppState ordersState = AppState.inital;
  List<OrderModel> orders = [];
  StreamSubscription<List<OrderModel>>? _ordersSub;

  // place order

  Future<void> placeOrder({required OrderModel order}) async {
    if (orderPlaceState == AppState.loading) return;

    orderPlaceState = AppState.loading;
    error = null;
    notifyListeners();

    try {
      const uuid = Uuid();
      final newOrder = OrderModel(
        orderId: "",
        orderNumber: "ORD-${uuid.v4().substring(0, 6).toUpperCase()}",
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
        createdAt: DateTime.now(),
      );
      await repo.placeOrder(model: newOrder);
      orderPlaceState = AppState.success;
    } catch (e) {
      log("un error from place order Provider  : $e");
      error = e.toString();
      orderPlaceState = AppState.error;
    }
    notifyListeners();
  }

  void resetOrderState() {
    orderPlaceState = AppState.inital;
    error = null;
    notifyListeners();
  }

  /// Load orders from repository and filter by [userId].
  Future<void> loadUserOrders({required String userId}) async {
    if (ordersState == AppState.loading) return;
    ordersState = AppState.loading;
    notifyListeners();

    try {
      final all = await repo.getOrders();
      orders = all.where((o) => o.userId == userId).toList();
      ordersState = AppState.success;
    } catch (e) {
      log('loadUserOrders error: $e');
      orders = [];
      ordersState = AppState.error;
      error = e.toString();
    }
    notifyListeners();
  }

  /// Refresh current user's orders (calls loadUserOrders using repo data).
  Future<void> refreshOrders({required String userId}) async {
    await loadUserOrders(userId: userId);
  }

  /// Start listening to all orders (reflect admin changes in real-time).
  void startOrdersListener() {
    _ordersSub?.cancel();
    _ordersSub = repo.streamOrders().listen(
      (list) {
        orders = list;
        notifyListeners();
      },
      onError: (e) {
        log('orders stream error: $e');
      },
    );
  }

  /// Stop listening to orders.
  void stopOrdersListener() {
    _ordersSub?.cancel();
    _ordersSub = null;
  }

  @override
  void dispose() {
    _ordersSub?.cancel();
    super.dispose();
  }

  /// Place a return request for an existing order.
  Future<void> placeReturnRequest({
    required String orderId,
    required ReturnDetails details,
  }) async {
    if (returnRequestState == AppState.loading) return;
    returnRequestState = AppState.loading;
    returnError = null;
    notifyListeners();

    try {
      await repo.placeReturnRequest(orderId: orderId, details: details);
      returnRequestState = AppState.success;
    } catch (e) {
      log('placeReturnRequest provider error: $e');
      returnError = e.toString();
      returnRequestState = AppState.error;
    }
    notifyListeners();
  }

  /// Cancel an order (allowed only if order status != delivered).
  Future<bool> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final order = orders.firstWhere((o) => o.orderId == orderId);
      // Can only cancel if not delivered, cancelled, or rejected
      if (order.orderStatus == OrderStatus.delivered ||
          order.orderStatus == OrderStatus.cancelled ||
          order.orderStatus == OrderStatus.rejected ||
          order.orderStatus == OrderStatus.returned) {
        error = 'Cannot cancel this order due to its current status';
        notifyListeners();
        return false;
      }
      await repo.cancelOrder(orderId: orderId, reason: reason);
      return true;
    } catch (e) {
      log('cancelOrder provider error: $e');
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
