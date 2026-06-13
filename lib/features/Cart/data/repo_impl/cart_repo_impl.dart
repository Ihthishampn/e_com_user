import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/data/use_case/cart_use_case.dart';
import 'package:e_com_user/features/Cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CartRepo)
class CartRepoImpl implements CartRepo {
  final CartUseCase remote;
  CartRepoImpl(this.remote);

  @override
  Future<void> addToCart({required CartItemModel cartItem}) async {
    return await remote.addToCart(cartItem: cartItem);
  }

  @override
  Future<void> clearCart() async{
    return await remote.clearCart();
  
  }

  @override
  Future<void> decreaseQuantity({required String productId}) async{
     return await remote.decrementQuantity(productId: productId);

  }

  @override
  Future<List<CartItemModel>> fetchCart()async {
    return await remote.fetchCart();

  }

  @override
  Future<void> increaseQuantity({required String productId}) async{
       return await remote.increaseQuantiy(porductId: productId);

  }

  @override
  Future<void> removeFromCart({required String productId}) async{   
        return await remote.removeFromCart(productId: productId);

  }


}
