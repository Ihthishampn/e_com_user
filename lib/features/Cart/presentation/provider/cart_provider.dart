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

  String selectedPaymentMethod = 'Cash on Delivery';

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

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

  Future<void> increaseQuantity({required String productId}) async {
    try {
      await repo.increaseQuantity(productId: productId);
      final index = cartList.indexWhere(
        (index) => index.productId == productId,
      );

      if (index != -1) {
        cartList[index] = cartList[index].copyWith(
          quantity: cartList[index].quantity + 1,
        );
        log("local list updated quantity");
      }

      notifyListeners();
    } catch (e) {
      log("error in provider while increase quantirty from cart $e");
    }
  }

  Future<void> decreaseQuantity({required String productId}) async {
    try {
      await repo.decreaseQuantity(productId: productId);

      final index = cartList.indexWhere(
        (element) => element.productId == productId,
      );

      if (index != -1 && cartList[index].quantity > 1) {
        cartList[index] = cartList[index].copyWith(
          quantity: cartList[index].quantity - 1,
        );
      } else {
       await removeFromCart(productId: productId);
      }
    } catch (e) {
      log("error in provider while decrease quantity from cart $e");
    }
    notifyListeners();
  }

  Future<void> removeFromCart({required String productId}) async {
    try {
      await repo.removeFromCart(productId: productId);
      cartList.removeWhere((element) => element.productId == productId);
    } catch (e) {
      log("error in provider while remove from cart $e");
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    try {
      await repo.clearCart();
      cartList.clear();
    } catch (e) {
      log("error in provider while clear  cart $e");
    }
    notifyListeners();
  }
}
