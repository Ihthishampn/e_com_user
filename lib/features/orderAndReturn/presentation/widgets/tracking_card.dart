import 'package:e_com_user/features/orderAndReturn/presentation/widgets/timeline_tile.dart';
import 'package:flutter/material.dart';

class TrackingCard extends StatelessWidget {
  final String orderStatus;
  final List<String> statuses;

  const TrackingCard({
    super.key,
    required this.orderStatus,
    this.statuses = const [
      "Pending",
      "Accepted",
      "Packed",
      "Shipped",
      "Delivered",
    ],
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = statuses.indexWhere(
      (e) => e.toLowerCase() == orderStatus.toLowerCase(),
    );

    return Column(
      children: List.generate(statuses.length, (index) {
        final completed = index <= currentIndex;

        return TimelineTile(
          title: statuses[index],
          isCompleted: completed,
          isLast: index == statuses.length - 1,
        );
      }),
    );
  }
}
