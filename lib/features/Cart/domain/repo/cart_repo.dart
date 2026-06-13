import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';

abstract class CartRepo {
  Future<List<CartItemModel>> fetchCart();
  Future<void> addToCart({required CartItemModel cartItem});
  Future<void> removeFromCart({required String productId});
  Future<void> increaseQuantity({required String productId});
  Future<void> decreaseQuantity({required String productId});
  Future<void> clearCart();
}