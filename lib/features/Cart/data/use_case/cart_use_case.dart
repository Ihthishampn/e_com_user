import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartUseCase {
  final FirebaseFirestore firebaseFirestore;
  CartUseCase(this.firebaseFirestore);

  CollectionReference<Map<String, dynamic>> get _doc =>
      firebaseFirestore.collection("carts");

  Future<void> addToCart({required CartItemModel cartItem}) async {
    try {
      await _doc.doc(cartItem.productId).set(cartItem.toJson());

      log("Succes : add cart item to firebase");
    } catch (e) {
      log("error ehile addinf cart to firebase $e");
    }
  }

  Future<void> clearCart() async {
    try {
      log("started : clearing firebase cart items");
      final snapshots = await _doc.get();
      final batch = firebaseFirestore.batch();

      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      log("error ehilr cleat cart form firebase $e");
    }
  }

  Future<void> decrementQuantity({required String productId}) async {
    try {
      await _doc.doc(productId).update({"quantity": FieldValue.increment(-1)});
    } catch (e) {
      log("error while increment a product quantiy : $e");
    }
  }

  Future<List<CartItemModel>> fetchCart() async {
    try {
      final data = await _doc.get();
      return data.docs
          .map((e) => CartItemModel.fromJson(e.data(), e.id))
          .toList();
    } catch (e) {
      log("erro whilte fetch cart : $e");
      throw ("cart fetch error : $e");
    }
  }

  Future<void> increaseQuantiy({required String porductId}) async {
    try {
      await _doc.doc(porductId).update({"quantity": FieldValue.increment(1)});
    } catch (e) {
      log("error while increment a product quantiy : $e");
    }
  }

  Future<void> removeFromCart({required String productId}) async {
    try {
      await _doc.doc(productId).delete();
      log("succes delete a product in cart");
    } catch (e) {
      log("error ehile delete a procut from cart/firebase : $e");
    }
  }
}
