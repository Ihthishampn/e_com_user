import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final bool isCollapsed;

  const AppSearchBar({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: SearchBar(
        hintText: "Search for products",

        leading: Icon(
          Icons.search_outlined,
          color: isCollapsed ? Colors.white : Colors.grey,
        ),

        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            color: isCollapsed ? Colors.white : Colors.grey,
            fontSize: 14,
          ),
        ),

        elevation: const WidgetStatePropertyAll(0),

        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),

        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isCollapsed ? Colors.white : AppColors.textFieldBorder,
            ),
          ),
        ),
      ),
    );
  }
}
