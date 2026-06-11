import 'package:e_com_user/features/favourite/presentation/provider/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeAppBarActions extends StatelessWidget {
  final bool isCollapsed;

  const HomeAppBarActions({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    final Color badgeBgColor = isCollapsed ? Colors.black : Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                context.push("fav");
              },
              icon: Icon(
                Icons.favorite,
                color: isCollapsed ? Colors.red : Colors.redAccent,
                size: 26,
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Consumer<FavProvider>(
                    builder: (context, favs, child) {
                      return Text(
                        "${favs.favsList.length}",
                        style: TextStyle(
                          color: isCollapsed ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          height: 1.0,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () {
            context.push("cart");
          },
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.red, size: 26),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
