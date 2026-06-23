import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/return_details_model.dart';

abstract class OrderRepository {
  Future<void> placeOrder({required OrderModel model});
  Future<List<OrderModel>> getOrders();
  Stream<List<OrderModel>> streamOrders();
  Future<void> placeReturnRequest({
    required String orderId,
    required ReturnDetails details,
  });
  Future<void> cancelOrder({required String orderId, required String reason});
}
