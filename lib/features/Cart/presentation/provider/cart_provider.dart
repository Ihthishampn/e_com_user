import 'dart:developer';

import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/domain/repo/cart_repo.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class CartProvider with ChangeNotifier {
  final CartRepo repo;
  CartProvider(this.repo);
  AppState fetchcartState = AppState.inital;
  AppState addCartState = AppState.inital;

  String? error;

  List<CartItemModel> cartList = [];

  Future<void> handleFetchCart() async {
    if (fetchcartState == AppState.loading) return;
    error = null;
    fetchcartState = AppState.loading;
    notifyListeners();
    try {
      final carts = await repo.fetchCart();
      fetchcartState = AppState.success;

      cartList = carts;
    } catch (e) {
      log("error p carts $e");
      fetchcartState = AppState.error;
    }
    notifyListeners();
  }

  Future<void> addToCart({required CartItemModel cartItem}) async {
    if (addCartState == AppState.loading) return;
    addCartState = AppState.loading;
    notifyListeners();
    try {
      await repo.addToCart(cartItem: cartItem);
      addCartState = AppState.success;
      cartList.add(cartItem);
    } catch (e) {
      log("error p carts $e");
      addCartState = AppState.error;
    }
    notifyListeners();
  }
}






// import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';

// abstract class CartRepo {
//   Future<List<CartItemModel>> fetchCart();
//   Future<void> addToCart({required CartItemModel cartItem});
//   Future<void> removeFromCart({required String productId});
//   Future<void> increaseQuantity({required String productId});
//   Future<void> decreaseQuantity({required String productId});
//   Future<void> clearCart();
// }
