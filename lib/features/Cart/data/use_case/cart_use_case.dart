import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class CartUseCase {
  final FirebaseFirestore firebaseFirestore;
  CartUseCase(this.firebaseFirestore);

  Future<CartItemModel> addToCart() {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  
  Future<void> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  Future<void> decrementQuantity() {
    // TODO: implement decrementQuantity
    throw UnimplementedError();
  }

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
