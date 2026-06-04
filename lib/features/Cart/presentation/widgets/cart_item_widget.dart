import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final int quantity;

  const CartItemWidget({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(image, width: 56, height: 56, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(price, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),

        // Compact quantity badge (read-only)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            'Qty: $quantity',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
