import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';

abstract class ProductRepo {
  Stream<List<ProductModel>> getProducts();
  Stream<List<ProductModel>> getProductsByCategory(String categoryId);
  Stream<List<ProductModel>> searchProducts(String query);
  Stream<List<ProductModel>> searchByCategory(String query, String categoryId);
  // Pagination API: fetch a single page of products. If [startAfter] is provided,
  // the page will start after that document snapshot.
  Future<QuerySnapshot<Map<String, dynamic>>> fetchProductsPage({
    int limit = 20,
    DocumentSnapshot? startAfter,
  });

  Future<QuerySnapshot<Map<String, dynamic>>> fetchProductsByCategoryPage({
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? startAfter,
  });

  Future<QuerySnapshot<Map<String, dynamic>>> searchProductsPage({
    required String query,
    int limit = 20,
    DocumentSnapshot? startAfter,
  });

  Future<QuerySnapshot<Map<String, dynamic>>> searchProductsByCategoryPage({
    required String query,
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? startAfter,
  });
}
