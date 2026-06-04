import 'package:e_com_user/features/Home/presentation/widgets/category_sections.dart';
import 'package:e_com_user/features/Home/presentation/widgets/costum_prodcut_card.dart';
import 'package:e_com_user/features/Home/presentation/widgets/custom_search_app_bar.dart';
import 'package:e_com_user/features/Home/presentation/widgets/home_app_bar_action.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ================= APP BAR =================
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: isCollapsed
                ? AppColors.primaryColor
                : AppColors.white,

            title: Row(
              children: [
                Expanded(child: AppSearchBar(isCollapsed: isCollapsed)),
                const SizedBox(width: 10),
                HomeAppBarActions(isCollapsed: isCollapsed),
              ],
            ),

            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final topPadding = MediaQuery.of(context).padding.top;
                final collapsed =
                    constraints.biggest.height <= kToolbarHeight + topPadding;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (collapsed != isCollapsed) {
                    setState(() => isCollapsed = collapsed);
                  }
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
          ),

          SliverPersistentHeader(pinned: true, delegate: BestDealsHeader()),
          SliverToBoxAdapter(child: Gap(10)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(index: index),
                childCount: 20,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
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
