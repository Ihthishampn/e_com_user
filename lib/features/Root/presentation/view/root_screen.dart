import 'package:e_com_user/features/Category/presentation/view/category_screen.dart';
import 'package:e_com_user/features/Home/presentation/view/home_screen.dart';
import 'package:e_com_user/features/Address/presentation/view/address_screen.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/view/order_and_return_screen.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';

import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:provider/provider.dart';
import 'package:e_com_user/general/core/injection/injection_config.dart';
import 'package:e_com_user/general/services/local_storage/app_preferences.dart';
import 'package:e_com_user/features/orderAndReturn/presentation/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().handleFetchCart();
      context.read<FavProvider>().handleFetchFavs();
      // Load orders for the logged-in user (if available) and start listening
      final storedUserId = getIt<AppPreferences>().getUserId();
      if (storedUserId != null && storedUserId.isNotEmpty) {
        context.read<OrderProvider>().loadUserOrders(userId: storedUserId);
        context.read<OrderProvider>().startOrdersListener();
      }
    });
  }

  final pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const OrderAndReturnScreen(),
    const AddressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: selectedIndex, children: pages),

          Positioned(
            left: 16,
            right: 16,
            bottom: 25,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: GNav(
                  selectedIndex: selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },

                  gap: 8,
                  rippleColor: Colors.transparent,
                  hoverColor: Colors.transparent,

                  color: Colors.grey,
                  activeColor: Colors.white,

                  tabBackgroundColor: AppColors.primaryColor,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  tabs: const [
                    GButton(icon: Icons.home_outlined, text: ''),
                    GButton(icon: Icons.grid_view_rounded, text: ''),
                    GButton(icon: Icons.receipt_long, text: ''),
                    GButton(icon: Icons.person_outline, text: ''),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
