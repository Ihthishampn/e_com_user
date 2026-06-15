
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/enums/order_status.dart';
import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusTimeline({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      "Pending",
      "Accepted",
      "Packed",
      "Shipped",
      "Delivered",
    ];

    int currentIndex = switch (status) {
      OrderStatus.pending => 0,
      OrderStatus.accepted => 1,
      OrderStatus.packed => 2,
      OrderStatus.shipped => 3,
      OrderStatus.delivered => 4,
      _ => 0,
    };

    return Column(
      children: List.generate(
        statuses.length,
        (index) {
          final completed = index <= currentIndex;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: completed
                        ? AppColors.primaryColor
                        : Colors.grey.shade300,
                    child: completed
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  if (index != statuses.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: completed
                          ? AppColors.primaryColor
                          : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(statuses[index]),
              ),
            ],
          );
        },
      ),
    );
  }
}