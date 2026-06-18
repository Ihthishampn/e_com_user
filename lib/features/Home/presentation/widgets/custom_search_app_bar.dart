import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_user/features/Home/presentation/provider/product_provider.dart';

class AppSearchBar extends StatelessWidget {
  final bool isCollapsed;

  const AppSearchBar({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: SearchBar(
        hintText: "Search for products",
        onChanged: (value) {
          try {
            final prov = Provider.of<ProductProvider>(context, listen: false);
            prov.search(value);
          } catch (_) {
            // ignore if provider not available
          }
        },

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
