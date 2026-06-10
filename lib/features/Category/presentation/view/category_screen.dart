import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:e_com_user/features/Home/presentation/provider/product_provider.dart';
import 'package:e_com_user/features/Home/presentation/widgets/costum_prodcut_card.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final categories = provider.categories
            .where((category) => category.id != 'all')
            .toList();

        if (categories.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No Categories Found")),
          );
        }

        final currentProviderCatId = provider
            .categories[provider.selectedIndex >= provider.categories.length
                ? 0
                : provider.selectedIndex]
            .id;

        int uiSelectedIndex = categories.indexWhere(
          (c) => c.id == currentProviderCatId,
        );
        if (uiSelectedIndex == -1) {
          uiSelectedIndex = 0;
        }

        final selectedCategory = categories[uiSelectedIndex];

        final ProductProvider productProv = Provider.of<ProductProvider>(
          context,
        );
        List<ProductModel> productsForCategory = [];
        if (!productProv.isLoading) {
          productsForCategory = productProv.productsByCategory(
            selectedCategory.id,
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            title: Text(
              "Categories",
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = uiSelectedIndex == index;
                    Widget leading;
                    if (category.imageUrl.isEmpty) {
                      leading = Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.bgWhite,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category.categoryName.isNotEmpty
                              ? category.categoryName[0]
                              : '?',
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    } else {
                      leading = ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          category.imageUrl,
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 28,
                              height: 28,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.primaryColor.withOpacity(0.5),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 28,
                              height: 28,
                              color: selected
                                  ? Colors.white.withOpacity(0.15)
                                  : AppColors.bgWhite,
                              child: Icon(
                                Icons.category_outlined,
                                size: 16,
                                color: selected
                                    ? Colors.white
                                    : AppColors.primaryColor,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          final masterIndex = provider.categories.indexWhere(
                            (c) => c.id == category.id,
                          );
                          if (masterIndex != -1) {
                            provider.selectCategory(masterIndex);
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.12,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : AppColors.primaryColor.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              leading,
                              const SizedBox(width: 8),
                              Text(
                                category.categoryName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.lightBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCategory.categoryName,
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: productProv.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : productsForCategory.isEmpty
                            ? const Center(
                                child: Text('No products in this category'),
                              )
                            : GridView.builder(
                                itemCount: productsForCategory.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 270,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemBuilder: (context, idx) => ProductCard(
                                  product: productsForCategory[idx],
                                ),
                              ),
                      ),
                      const Gap(30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}