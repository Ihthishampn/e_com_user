import 'package:e_com_user/features/Home/presentation/widgets/category_sections.dart';
import 'package:e_com_user/features/Home/presentation/widgets/custum_prodcut_card.dart';
import 'package:e_com_user/features/Home/data/model/product_model.dart';
import 'package:e_com_user/features/Home/presentation/provider/product_provider.dart';
import 'package:e_com_user/features/Category/presentation/provider/category_provider.dart';
import 'package:e_com_user/features/Home/presentation/provider/home_provider.dart'; // Make sure to import your new provider file
import 'package:provider/provider.dart';
import 'package:e_com_user/features/Home/presentation/widgets/custom_search_app_bar.dart';
import 'package:e_com_user/features/Home/presentation/widgets/home_app_bar_action.dart';

import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProv = Provider.of<CategoryProvider>(context);
    final productProv = Provider.of<ProductProvider>(context);

    List<ProductModel> productsToShow = [];
    if (!productProv.isLoading && productProv.products.isNotEmpty) {
      if (categoryProv.categories.isNotEmpty &&
          categoryProv.selectedIndex < categoryProv.categories.length) {
        final selected = categoryProv.categories[categoryProv.selectedIndex];
        if (selected.id == 'all') {
          productsToShow = productProv.products;
        } else {
          productsToShow = productProv.productsByCategory(selected.id);
        }
      } else {
        productsToShow = productProv.products;
      }
    }

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (sn) {
          if (sn.metrics.pixels >= sn.metrics.maxScrollExtent - 400) {
            productProv.loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            Consumer<HomeProvider>(
              builder: (context, homeProv, child) {
                return SliverAppBar(
                  pinned: true,
                  expandedHeight: 180,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: homeProv.isCollapsed
                      ? AppColors.primaryColor
                      : AppColors.white,

                  title: Row(
                    children: [
                      Expanded(
                        child: AppSearchBar(isCollapsed: homeProv.isCollapsed),
                      ),
                      const SizedBox(width: 10),
                      HomeAppBarActions(isCollapsed: homeProv.isCollapsed),
                    ],
                  ),

                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final topPadding = MediaQuery.of(context).padding.top;
                      final collapsed =
                          constraints.biggest.height <=
                          kToolbarHeight + topPadding;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<HomeProvider>().setCollapsed(collapsed);
                      });

                      return FlexibleSpaceBar(
                        background: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 60,
                              left: 12,
                              right: 12,
                            ),
                            child: CategorySection(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            SliverPersistentHeader(pinned: true, delegate: BestDealsHeader()),
            const SliverToBoxAdapter(child: Gap(10)),

            if (productProv.isLoading)
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (productsToShow.isEmpty)
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 120,
                  child: Center(child: Text('No products found')),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        ProductCard(product: productsToShow[index]),
                    childCount: productsToShow.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 270,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            if (productProv.isFetchingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class BestDealsHeader extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        "Best Deals",
        style: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
