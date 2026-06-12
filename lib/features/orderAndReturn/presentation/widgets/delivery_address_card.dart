import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class DeliveryAddressCard extends StatelessWidget {
  final String recipientName;
  final String address;
  final String? title;

  const DeliveryAddressCard({
    super.key,
    required this.recipientName,
    required this.address,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title ?? "Delivery Address",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          recipientName,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          address,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
