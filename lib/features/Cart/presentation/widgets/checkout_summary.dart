import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const CheckoutSummary({super.key, required this.items});

  int _parsePrice(String price) =>
      int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<int>(
      0,
      (s, it) => s + _parsePrice(it['price'] as String) * (it['qty'] as int),
    );
    final delivery = 40;
    final total = subtotal + delivery;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.06), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '₹${subtotal.toString()}'),
          const SizedBox(height: 8),
          _priceRow('Delivery', '₹$delivery'),
          const Divider(height: 20),
          _priceRow('Total', '₹${total.toString()}', isTotal: true),
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
