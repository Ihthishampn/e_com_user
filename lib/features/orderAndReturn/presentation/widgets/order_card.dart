import 'package:e_com_user/features/orderAndReturn/presentation/view/track_order_screen.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String name;
  final String price;
  final String status;
  final String image;
  final Color statusColor;
  final VoidCallback onReturnPressed;

  const OrderCard({
    super.key,
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.statusColor,
    required this.onReturnPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 50, 43, 150);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(.06), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TrackOrderScreen(
                          orderId: '',
                          productName: name,
                          orderStatus: 'pending',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Track Order',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              if (status == 'Delivered') ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReturnPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Return',
                      style: TextStyle(color: Colors.white, fontSize: 13),
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
