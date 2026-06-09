import 'package:e_com_user/features/Home/data/model/product_model.dart';

abstract class ProductRepo {
  Stream<List<ProductModel>> getProducts();
  Stream<List<ProductModel>> getProductsByCategory(String categoryId);
  Stream<List<ProductModel>> searchProducts(String query);
  Stream<List<ProductModel>> searchByCategory(String query, String categoryId);
}
  