import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';
import 'package:e_com_user/features/Home/data/use_case/product_use_case.dart';
import 'package:e_com_user/features/Home/domain/product_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductRepo)
class ProductRepoImpl implements ProductRepo {
  final ProductUseCase useCase;
  ProductRepoImpl(this.useCase);

  @override
  Stream<List<ProductModel>> getProducts() {
    return useCase.getProducts();
  }

  @override
  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {
    return useCase.getProductsByCategory(categoryId);
  }

  @override
  Stream<List<ProductModel>> searchByCategory(String query, String categoryId) {
    return useCase.searchProductsByCategory(query, categoryId);
  }

  @override
  Stream<List<ProductModel>> searchProducts(String query) {
    return useCase.searchProducts(query);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchProductsPage({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    return useCase.fetchProductsPage(limit: limit, startAfter: startAfter);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchProductsByCategoryPage({
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    return useCase.fetchProductsByCategoryPage(
      categoryId: categoryId,
      limit: limit,
      startAfter: startAfter,
    );
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> searchProductsPage({
    required String query,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    return useCase.searchProductsPage(
      query: query,
      limit: limit,
      startAfter: startAfter,
    );
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> searchProductsByCategoryPage({
    required String query,
    required String categoryId,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    return useCase.searchProductsByCategoryPage(
      query: query,
      categoryId: categoryId,
      limit: limit,
      startAfter: startAfter,
    );
  }
}
