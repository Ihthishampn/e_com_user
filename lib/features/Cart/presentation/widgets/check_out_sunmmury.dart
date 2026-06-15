import 'package:e_com_user/features/Cart/data/model/cart_item_model.dart';
import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  final List<CartItemModel> cartItems;

  const CheckoutSummary({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final subtotal = cartItems.fold<double>(
      0,
      (s, item) => s + (item.productPrice * item.quantity),
    );
    const delivery = 40;
    final total = subtotal + delivery;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: .06), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _priceRow('Delivery', '₹$delivery'),
          const Divider(height: 20),
          _priceRow('Total', '₹${total.toStringAsFixed(0)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          title,
          style: isTotal
              ? const TextStyle(fontWeight: FontWeight.w700)
              : const TextStyle(),
        ),
        const Spacer(),
        Text(
          amount,
          style: isTotal
              ? const TextStyle(fontWeight: FontWeight.w700)
              : const TextStyle(),
        ),
      ],
    );
  }
}