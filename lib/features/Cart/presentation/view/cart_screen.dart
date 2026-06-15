import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:e_com_user/features/Cart/presentation/provider/cart_provider.dart';
import 'package:e_com_user/features/Cart/presentation/view/checkout_screen.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/cart_item_widget.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double _calculateSubtotal(List<CartItemModel> items) {
    return items.fold(
      0,
      (sum, item) => sum + (item.productPrice * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartList = cartProvider.cartList;

    final subtotal = _calculateSubtotal(cartList);

    return Scaffold(
      backgroundColor: AppColors.containerGrey,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 30,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [Icon(Icons.shopping_cart_outlined), Gap(20)],
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(
          bottom: 90,
          left: 18,
          right: 18,
          top: 8,
        ),
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _priceRow(
              'Subtotal',
              '₹${subtotal.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 6),
            _priceRow('Delivery', '₹40'),
            const Divider(height: 20),
            _priceRow(
              'Total',
              '₹${(subtotal + 40).toStringAsFixed(0)}',
              isTotal: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 49, 113, 51),
                  ),
                ),
                onPressed: cartList.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              cartItems: cartList,
                            ),
                          ),
                        );
                      },
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: cartList.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final item = cartList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .03),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: CartItemWidget(
                    isCartScreen: true,
                    onDecrement: () {
                      context.read<CartProvider>().decreaseQuantity(
                            productId: item.productId,
                          );
                    },
                    onIncrement: () {
                      context.read<CartProvider>().increaseQuantity(
                            productId: item.productId,
                          );
                    },
                    name: item.productName,
                    price: '₹${item.productPrice}',
                    image: item.imageUrl,
                    quantity: item.quantity,
                  ),
                );
              },
            ),
    );
  }

  static Widget _priceRow(
    String title,
    String amount, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                )
              : AppTextStyles.bodyMedium,
        ),
        const Spacer(),
        Text(
          amount,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                )
              : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}