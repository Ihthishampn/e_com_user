import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:e_com_user/features/Cart/presentation/view/checkout_screen.dart';
import 'package:e_com_user/features/Cart/presentation/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Wireless Headphones',
      'price': '₹999',
      'image': 'https://picsum.photos/200',
      'qty': 1,
    },
    {
      'name': 'Smart Watch',
      'price': '₹2,499',
      'image': 'https://picsum.photos/201',
      'qty': 1,
    },
    {
      'name': 'Bluetooth Speaker',
      'price': '₹1,299',
      'image': 'https://picsum.photos/202',
      'qty': 1,
    },
  ];

  int _parsePrice(String price) =>
      int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  int get _subtotal => _items.fold<int>(
    0,
    (sum, it) => sum + _parsePrice(it['price'] as String) * (it['qty'] as int),
  );

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(bottom: 90, left: 18, right: 18, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _priceRow('Subtotal', '₹${_subtotal.toString()}'),
            const SizedBox(height: 6),
            _priceRow('Delivery', '₹40'),
            const Divider(height: 20),
            _priceRow(
              'Total',
              '₹${(_subtotal + 40).toString()}',
              isTotal: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    const Color.fromARGB(255, 49, 113, 51),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(items: _items),
                    ),
                  );
                },
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final it = _items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6),
              ],
            ),
            child: CartItemWidget(
              name: it['name'] as String,
              price: it['price'] as String,
              image: it['image'] as String,
              quantity: it['qty'] as int,
            ),
          );
        },
      ),
    );
  }

  static Widget _priceRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)
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
