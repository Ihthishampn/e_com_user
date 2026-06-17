import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';

abstract class OrderRepository {
  Future<void> placeOrder({required OrderModel model});
  Future<OrderModel> getOrderById({required String orderId});
  Future<List<OrderModel>> getOrders();
}
