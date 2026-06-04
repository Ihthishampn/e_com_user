import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selectedIndex = 0;

  final List<String> categories = [
    "Electronics",
    "Fashion",
    "Shoes",
    "Beauty",
    "Grocery",
    "Watches",
    "Furniture",
    "Sports",
  ];

  final Map<String, List<Map<String, dynamic>>> subCategories = {
    "Electronics": [
      {"icon": Icons.phone_android, "name": "Mobiles"},
      {"icon": Icons.laptop, "name": "Laptops"},
      {"icon": Icons.headphones, "name": "Headphones"},
      {"icon": Icons.watch, "name": "Smart Watch"},
      {"icon": Icons.camera_alt, "name": "Camera"},
      {"icon": Icons.tv, "name": "TV"},
    ],
    "Fashion": [
      {"icon": Icons.checkroom, "name": "Men"},
      {"icon": Icons.checkroom, "name": "Women"},
      {"icon": Icons.shopping_bag, "name": "Bags"},
      {"icon": Icons.diamond, "name": "Jewellery"},
    ],
    "Shoes": [
      {"icon": Icons.run_circle, "name": "Running"},
      {"icon": Icons.sports_basketball, "name": "Sports"},
      {"icon": Icons.hiking, "name": "Casual"},
    ],
    "Beauty": [
      {"icon": Icons.face, "name": "Skincare"},
      {"icon": Icons.brush, "name": "Makeup"},
      {"icon": Icons.spa, "name": "Wellness"},
    ],
    "Grocery": [
      {"icon": Icons.apple, "name": "Fruits"},
      {"icon": Icons.egg, "name": "Dairy"},
      {"icon": Icons.local_drink, "name": "Beverages"},
    ],
    "Watches": [
      {"icon": Icons.watch, "name": "Analog"},
      {"icon": Icons.watch, "name": "Digital"},
      {"icon": Icons.watch, "name": "Luxury"},
    ],
    "Furniture": [
      {"icon": Icons.chair, "name": "Chair"},
      {"icon": Icons.bed, "name": "Bed"},
      {"icon": Icons.table_restaurant, "name": "Table"},
    ],
    "Sports": [
      {"icon": Icons.sports_soccer, "name": "Football"},
      {"icon": Icons.sports_cricket, "name": "Cricket"},
      {"icon": Icons.sports_basketball, "name": "Basketball"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentCategory = categories[selectedIndex];
    final currentItems = subCategories[currentCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Categories",
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 120,
            color: AppColors.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final selected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            child: Text(
                              categories[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.primaryColor
                                    : Colors
                                          .white, 
                              ),
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

          // RIGHT SIDE
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentCategory,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${currentItems.length} Categories",
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),

                  const SizedBox(height: 18),

                  Expanded(
                    child: GridView.builder(
                      itemCount: currentItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 115,
                          ),
                      itemBuilder: (context, index) {
                        final item = currentItems[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.lightGreyColor,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.primaryColor
                                    .withValues(alpha: .12),
                                child: Icon(
                                  item["icon"],
                                  color: AppColors.primaryColor,
                                  size: 24,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  item["name"],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
