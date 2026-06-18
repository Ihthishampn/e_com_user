import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String name;
  final String price;
  final String status;
  final String image;
  final Color statusColor;
  final VoidCallback onReturnPressed;
  final VoidCallback? onTrackPressed;
  final VoidCallback? onCancelPressed;
  final bool canCancel;

  const OrderCard({
    super.key,
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.statusColor,
    required this.onReturnPressed,
    this.onTrackPressed,
    this.onCancelPressed,
    this.canCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 50, 43, 150);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image.startsWith('http')
                    ? Image.network(
                        image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: const Color(0xFFF1F5F9),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 24,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onTrackPressed,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Track Order',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (status == 'Delivered') ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReturnPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor.withValues(alpha: 0.08),
                      foregroundColor: primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.keyboard_return_rounded, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Return',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (canCancel) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(
                        color: Color(0xFFDC2626),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onCancelPressed,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close_rounded, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
