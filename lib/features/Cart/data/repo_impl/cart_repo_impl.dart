import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/data/use_case/cart_use_case.dart';
import 'package:e_com_user/features/Cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepo)
class CartRepoImpl implements CartRepo {
  final CartUseCase remote;
  CartRepoImpl(this.remote);
  @override
  Future<CartItemModel> addToCart() {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<void> decrementQuantity() {
    // TODO: implement decrementQuantity
    throw UnimplementedError();
  }

  @override
  Future<List<CartItemModel>> fetchCart() {
    // TODO: implement fetchCart
    throw UnimplementedError();
  }

  @override
  Future<void> increaseQuantiy() {
    // TODO: implement increaseQuantiy
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromCart() {
    // TODO: implement removeFromCart
    throw UnimplementedError();
  }
}
