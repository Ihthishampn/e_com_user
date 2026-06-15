import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool isCartScreen;

  const CartItemWidget({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.isCartScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image.startsWith('http')
              ? Image.network(
                  image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 24,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
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
//  + and - 
        if (isCartScreen)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQtyButton(icon: Icons.remove, onTap: onDecrement),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '$quantity',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              _buildQtyButton(icon: Icons.add, onTap: onIncrement),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              'Qty: $quantity',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),
      ],
    );
  }

   Widget _buildQtyButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 14, color: Colors.grey.shade700),
      ),
    );
  }
}