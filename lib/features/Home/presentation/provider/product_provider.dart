import 'dart:async';

import 'package:flutter/material.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';
import 'package:e_com_user/features/Home/domain/product_repo.dart';
import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';

class ProductProvider with ChangeNotifier {
  StreamSubscription<List<ProductModel>>? _sub;
  String _currentCategoryId = 'all';

  final ProductRepo _repo = getIt<ProductRepo>();

  List<ProductModel> products = [];
  bool isLoading = true;

  ProductProvider() {
    debugPrint('ProductProvider: constructed');
    try {
      final CategoryProvider catProv = getIt<CategoryProvider>();

      final initialCat = _categoryIdFromProvider(catProv);
      debugPrint(
        'ProductProvider: initial category from CategoryProvider -> $initialCat',
      );
      _subscribeToCategory(initialCat);

      catProv.addListener(() {
        try {
          final id = _categoryIdFromProvider(catProv);
          debugPrint('ProductProvider: CategoryProvider changed -> $id');
          _subscribeToCategory(id);
        } catch (e, st) {
          debugPrint('ProductProvider: error reading category change: $e\n$st');
        }
      });
    } catch (e, st) {
      debugPrint(
        'ProductProvider: error during init, falling back to all -> $e\n$st',
      );
      _subscribeToCategory('all');
    }
  }

  String _categoryIdFromProvider(CategoryProvider prov) {
    if (prov.isLoading) return 'all';
    if (prov.categories.isEmpty) return 'all';
    final idx = prov.selectedIndex >= prov.categories.length
        ? 0
        : prov.selectedIndex;
    return prov.categories[idx].id;
  }

  void _subscribeToCategory(String categoryId) {
  
    if (_currentCategoryId == categoryId && _sub != null) return;
    _currentCategoryId = categoryId;
    _sub?.cancel();
    isLoading = true;
    notifyListeners();

    if (categoryId.isEmpty || categoryId == 'all') {
      debugPrint('ProductProvider: subscribing to all products');
      _sub = _repo.getProducts().listen(
        (list) {
          products = list;
          isLoading = false;
          debugPrint(
            'ProductProvider: received ${products.length} products (all)',
          );
          notifyListeners();
        },
        onError: (e) {
          isLoading = false;
          debugPrint('ProductProvider: error subscribing to all products: $e');
          notifyListeners();
        },
      );
    } else {
      debugPrint('ProductProvider: subscribing to category $categoryId');
      _sub = _repo
          .getProductsByCategory(categoryId)
          .listen(
            (list) {
              products = list;
              isLoading = false;
              debugPrint(
                'ProductProvider: received ${products.length} products for category $categoryId',
              );
              notifyListeners();
            },
            onError: (e) {
              isLoading = false;
              debugPrint(
                'ProductProvider: error subscribing to category $categoryId: $e',
              );
              notifyListeners();
            },
          );
    }
  }

  void setCategory(String categoryId) {
    _subscribeToCategory(categoryId);
  }

  List<ProductModel> productsByCategory(String categoryId) {
    if (categoryId.isEmpty || categoryId == 'all') return products;
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
