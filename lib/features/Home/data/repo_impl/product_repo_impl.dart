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
    // TODO: implement searchByCategory
    throw UnimplementedError();
  }

  @override
  Stream<List<ProductModel>> searchProducts(String query) {
    // TODO: implement searchProducts
    throw UnimplementedError();
  }
}
