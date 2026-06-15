import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';

import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:e_com_user/features/Home/presentation/provider/product_provider.dart';
import 'package:e_com_user/features/Home/presentation/widgets/custum_prodcut_card.dart';
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
              // 1. Reduced height drastically from 96 to 54 to match the micro-chip style
              SizedBox(
                height: 54,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = uiSelectedIndex == index;

                    // 2. Dynamic Image Size: Made it much smaller by default (24), and even smaller when selected (20)
                    double imageSize = selected ? 20.0 : 24.0;

                    Widget leading;
                    if (category.imageUrl.isEmpty) {
                      leading = Container(
                        width: imageSize,
                        height: imageSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppColors.bgWhite,
                          shape: BoxShape.circle,
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
                            fontSize: selected ? 11 : 13,
                          ),
                        ),
                      );
                    } else {
                      leading = ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          category.imageUrl,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.primaryColor.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: imageSize,
                              height: imageSize,
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : AppColors.bgWhite,
                              child: Icon(
                                Icons.category_outlined,
                                size: selected ? 12 : 14,
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
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Circular capsule look
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          // 3. Dynamic Padding: Reduces horizontal padding when selected to make the chip tighter
                          padding: EdgeInsets.symmetric(
                            horizontal: selected ? 10 : 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryColor
                                : AppColors.bgWhite,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : AppColors.lightBlack.withValues(
                                      alpha: 0.05,
                                    ),
                            ),
                          ),
                          // 4. Changed back to a horizontal Row for clean layout spacing
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              leading,
                              const SizedBox(width: 6),
                              Text(
                                category.categoryName,
                                style: TextStyle(
                                  // 5. Dynamic Text Size: Shrunk text to 11 when selected
                                  fontSize: selected ? 11 : 12,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
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
                                padding: const EdgeInsets.only(bottom: 70),
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
