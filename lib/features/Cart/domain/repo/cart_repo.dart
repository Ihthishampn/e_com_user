import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';

abstract class CartRepo {

  Future<List<CartItemModel>> fetchCart();
  Future<CartItemModel> addToCart();
  Future<void> removeFromCart();
  Future<void> increaseQuantiy();
  Future<void> decrementQuantity();
  Future<void> clearCart();

}
