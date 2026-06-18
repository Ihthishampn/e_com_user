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
          // If there's an active search query, re-run the search scoped to the
          // new category; otherwise subscribe to the category feed.
          if (_searchQuery.trim().isNotEmpty) {
            search(_searchQuery);
          } else {
            _subscribeToCategory(id);
          }
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

  /// Perform a text search. If [query] is empty, fall back to the current
  /// category subscription. If a specific category is active we perform a
  /// category-scoped search; otherwise search across all products.
  void search(String query) {
    _sub?.cancel();
    _searchQuery = query;

    final catId = _currentCategoryId;
    if (query.trim().isEmpty) {
      // restore normal category subscription
      _subscribeToCategory(catId);
      return;
    }

    isLoading = true;
    notifyListeners();

    if (catId.isEmpty || catId == 'all') {
      _sub = _repo
          .searchProducts(query)
          .listen(
            (list) {
              products = list;
              isLoading = false;
              notifyListeners();
            },
            onError: (e) {
              isLoading = false;
              debugPrint('ProductProvider: search error: $e');
              notifyListeners();
            },
          );
    } else {
      _sub = _repo
          .searchByCategory(query, catId)
          .listen(
            (list) {
              products = list;
              isLoading = false;
              notifyListeners();
            },
            onError: (e) {
              isLoading = false;
              debugPrint('ProductProvider: category search error: $e');
              notifyListeners();
            },
          );
    }
  }

  String _searchQuery = '';

  void setCategory(String categoryId) {
    if (_searchQuery.trim().isNotEmpty) {
      // if user has an active search, perform category-scoped search
      _currentCategoryId = categoryId;
      search(_searchQuery);
    } else {
      _subscribeToCategory(categoryId);
    }
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
