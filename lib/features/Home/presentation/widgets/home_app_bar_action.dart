import 'package:flutter/material.dart';

class HomeAppBarActions extends StatelessWidget {
  final bool isCollapsed;

  const HomeAppBarActions({
    super.key,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.notifications_outlined,
          color: isCollapsed ? Colors.white : Colors.black,
        ),
        const SizedBox(width: 10),
        Icon(
          Icons.shopping_cart_outlined,
          color: isCollapsed ? Colors.white : Colors.black,
        ),
      ],
    );
  }
}