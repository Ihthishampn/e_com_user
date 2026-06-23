import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';
import 'package:e_com_user/features/Home/domain/product_repo.dart';
import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';

class ProductProvider with ChangeNotifier {
  String _currentCategoryId = 'all';

  final ProductRepo _repo = getIt<ProductRepo>();

  List<ProductModel> products = [];
  bool isLoading = true;

  DocumentSnapshot? _lastDoc;
  bool hasMore = true;
  bool isFetchingMore = false;
  final int pageSize = 20;

  ProductProvider() {
    debugPrint('ProductProvider: constructed');
    try {
      final CategoryProvider catProv = getIt<CategoryProvider>();

      final initialCat = _categoryIdFromProvider(catProv);
      debugPrint(
        'ProductProvider: initial category from CategoryProvider -> $initialCat',
      );
      _fetchInitialForCategory(initialCat);

      catProv.addListener(() {
        try {
          final id = _categoryIdFromProvider(catProv);
          debugPrint('ProductProvider: CategoryProvider changed -> $id');
      
          if (_searchQuery.trim().isNotEmpty) {
            _resetPagination();
            search(_searchQuery);
          } else {
            _resetPagination();
            _fetchInitialForCategory(id);
          }
        } catch (e, st) {
          debugPrint('ProductProvider: error reading category change: $e\n$st');
        }
      });
    } catch (e, st) {
      debugPrint(
        'ProductProvider: error during init, falling back to all -> $e\n$st',
      );
      _fetchInitialForCategory('all');
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

  void _fetchInitialForCategory(String categoryId) async {
    _currentCategoryId = categoryId;
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot<Map<String, dynamic>> snap;
      if (_searchQuery.trim().isNotEmpty) {
        if (categoryId.isEmpty || categoryId == 'all') {
          snap = await _repo.searchProductsPage(
            query: _searchQuery,
            limit: pageSize,
          );
        } else {
          snap = await _repo.searchProductsByCategoryPage(
            query: _searchQuery,
            categoryId: categoryId,
            limit: pageSize,
          );
        }
      } else {
        if (categoryId.isEmpty || categoryId == 'all') {
          snap = await _repo.fetchProductsPage(limit: pageSize);
        } else {
          snap = await _repo.fetchProductsByCategoryPage(
            categoryId: categoryId,
            limit: pageSize,
          );
        }
      }

      products = snap.docs
          .map((d) => ProductModel.fromMap(d.data(), d.id))
          .toList();
      _lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
      hasMore = snap.docs.length == pageSize;
      isLoading = false;
      notifyListeners();
    } catch (e, st) {
      debugPrint('ProductProvider: fetchInitial error: $e\n$st');
      products = [];
      isLoading = false;
      hasMore = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.trim();
    _resetPagination();
    if (_searchQuery.isEmpty) {
      _fetchInitialForCategory(_currentCategoryId);
    } else {
      _fetchInitialForCategory(_currentCategoryId);
    }
  }

  String _searchQuery = '';

  void setCategory(String categoryId) {
    if (_searchQuery.trim().isNotEmpty) {
      _currentCategoryId = categoryId;
      _resetPagination();
      search(_searchQuery);
    } else {
      _resetPagination();
      _fetchInitialForCategory(categoryId);
    }
  }

  void _resetPagination() {
    _lastDoc = null;
    hasMore = true;
    isFetchingMore = false;
    products = [];
  }

  Future<void> loadMore() async {
    if (!hasMore || isFetchingMore) return;
    isFetchingMore = true;
    notifyListeners();

    try {
      QuerySnapshot<Map<String, dynamic>> snap;
      final catId = _currentCategoryId;
      if (_searchQuery.isNotEmpty) {
        if (catId.isEmpty || catId == 'all') {
          snap = await _repo.searchProductsPage(
            query: _searchQuery,
            limit: pageSize,
            startAfter: _lastDoc,
          );
        } else {
          snap = await _repo.searchProductsByCategoryPage(
            query: _searchQuery,
            categoryId: catId,
            limit: pageSize,
            startAfter: _lastDoc,
          );
        }
      } else {
        if (catId.isEmpty || catId == 'all') {
          snap = await _repo.fetchProductsPage(
            limit: pageSize,
            startAfter: _lastDoc,
          );
        } else {
          snap = await _repo.fetchProductsByCategoryPage(
            categoryId: catId,
            limit: pageSize,
            startAfter: _lastDoc,
          );
        }
      }

      final fetched = snap.docs
          .map((d) => ProductModel.fromMap(d.data(), d.id))
          .toList();
      products.addAll(fetched);
      _lastDoc = snap.docs.isNotEmpty ? snap.docs.last : _lastDoc;
      hasMore = fetched.length == pageSize;
    } catch (e, st) {
      debugPrint('ProductProvider: loadMore error: $e\n$st');
      hasMore = false;
    }

    isFetchingMore = false;
    notifyListeners();
  }

  List<ProductModel> productsByCategory(String categoryId) {
    if (categoryId.isEmpty || categoryId == 'all') return products;
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  @override
  void dispose() {
    // no subscriptions to cancel (pagination-based fetching)
    super.dispose();
  }
}
