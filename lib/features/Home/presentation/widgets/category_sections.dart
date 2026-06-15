import 'package:e_com_user/features/Category/data/model/category_model.dart';
import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 84,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final categories = provider.categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 84,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final CategoryModel category = categories[index];
                  final selected = provider.selectedIndex == index;

                  Widget avatarChild;

                  // Special handling for the synthetic "All" category.
                  if (category.id == 'all') {
                    avatarChild = CircleAvatar(
                      radius: selected ? 22 : 18,
                      backgroundColor: selected
                          ? AppColors.primaryColor
                          : Colors.white,
                      child: Icon(
                        Icons.grid_view_rounded,
                        color: selected ? Colors.white : AppColors.primaryColor,
                        size: selected ? 20 : 18,
                      ),
                    );
                  } else if (category.imageUrl.isEmpty) {
                    avatarChild = CircleAvatar(
                      radius: selected ? 22 : 18,
                      backgroundColor: Colors.white,
                      child: Text(
                        category.categoryName.isNotEmpty
                            ? category.categoryName[0]
                            : '?',
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                      ),
                    );
                  } else {
                    avatarChild = CircleAvatar(
                      radius: selected ? 22 : 18,
                      backgroundImage: NetworkImage(category.imageUrl),
                      backgroundColor: Colors.white,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () => provider.selectCategory(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            padding: selected
                                ? const EdgeInsets.all(2)
                                : const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.22),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                              gradient: selected
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.primaryColor.withValues(alpha: 0.9),
                                      ],
                                    )
                                  : null,
                              border: selected
                                  ? Border.all(
                                      color: AppColors.primaryColor,
                                      width: 1.2,
                                    )
                                  : Border.all(
                                      color: Colors.transparent,
                                      width: 0,
                                    ),
                            ),
                            child: avatarChild,
                          ),

                          const SizedBox(height: 4),

                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: selected
                                  ? AppColors.primaryColor
                                  : Colors.black87,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                            child: Text(category.categoryName),
                          ),

                          const SizedBox(height: 3),

                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: selected ? 1.0 : 0.0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
