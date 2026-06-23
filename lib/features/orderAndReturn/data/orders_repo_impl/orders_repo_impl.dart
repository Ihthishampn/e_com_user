import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/model/return_details_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/order_use_case.dart/order_use_case.dart';
import 'package:e_com_user/features/orderAndReturn/domain/order_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrdersRepoImpl implements OrderRepository {
  final OrderUseCase useCase;
  OrdersRepoImpl(this.useCase);
 

  @override
  Future<List<OrderModel>> getOrders() async {
    return await useCase.getOrders();
  }

  @override
  Stream<List<OrderModel>> streamOrders() {
    return useCase.streamOrders();
  }

  @override
  Future<void> placeOrder({required OrderModel model}) async {
    return await useCase.placeOrder(model: model);
  }

  @override
  Future<void> placeReturnRequest({
    required String orderId,
    required ReturnDetails details,
  }) async {
    return await useCase.placeReturnRequest(orderId: orderId, details: details);
  }

  @override
  Future<void> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    return await useCase.cancelOrder(orderId: orderId, reason: reason);
  }
}
