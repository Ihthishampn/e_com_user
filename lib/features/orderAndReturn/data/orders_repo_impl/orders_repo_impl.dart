import 'package:e_com_user/features/orderAndReturn/data/model/order_model.dart';
import 'package:e_com_user/features/orderAndReturn/data/order_use_case.dart/order_use_case.dart';
import 'package:e_com_user/features/orderAndReturn/domain/order_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrdersRepoImpl implements OrderRepository {
  final OrderUseCase useCase;
  OrdersRepoImpl(this.useCase);
  @override
  Future<OrderModel> getOrderById({required String orderId}) async{
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  @override
  Future<List<OrderModel>> getOrders() async{
    // TODO: implement getOrders
    throw UnimplementedError();
  }

  @override
  Future<void> placeOrder({required OrderModel model})async {
    return await useCase.placeOrder(model: model);
  }
}
