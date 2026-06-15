import 'dart:async';

import 'package:flutter/material.dart';
import 'package:e_com_user/features/Category/data/model/category_model.dart';
import 'package:e_com_user/features/Category/domain/repo/category_repo.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';
import 'package:e_com_user/features/Home/presentation/provider/product_provider.dart';

class CategoryProvider with ChangeNotifier {
  StreamSubscription<List<CategoryModel>>? _sub;

  List<CategoryModel> categories = [];
  bool isLoading = true;
  int selectedIndex = 0;
  CategoryProvider() {
    final CategoryRepo repo = getIt<CategoryRepo>();
    _sub = repo.fetchCategories().listen(
      (list) {
        final allCategory = CategoryModel(
          id: 'all',
          categoryName: 'All',
          imageUrl: '',
          searchKeywords: const [],
        );

        categories = [allCategory, ...list];
        isLoading = false;
        if (selectedIndex >= categories.length) selectedIndex = 0;
        debugPrint('CategoryProvider: loaded ${categories.length} categories');
        notifyListeners();
      },
      onError: (e) {
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void selectCategory(int index) {
    if (index < 0 || index >= categories.length) return;
    if (selectedIndex == index) return; // no-op when selecting same index
    selectedIndex = index;
    notifyListeners();
    // Notify product provider (if registered in GetIt) so it can switch
    // subscription to the selected category's stream.
    try {
      final prodProv = getIt<ProductProvider>();
      prodProv.setCategory(categories[selectedIndex].id);
    } catch (_) {
      // ignore if ProductProvider isn't registered in GetIt
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
