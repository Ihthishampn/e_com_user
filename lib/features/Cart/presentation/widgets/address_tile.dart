
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AddressTile extends StatelessWidget {
  final String title;
  final String address;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;

  const AddressTile({
    super.key,
    required this.title,
    required this.address,
    this.selected = false,
    this.onTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHome = title.toLowerCase() == 'home';
    final iconData = isHome ? Icons.home_rounded : Icons.work_rounded;
    final primaryColor = AppColors.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? primaryColor.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? primaryColor : const Color(0xFFEDF2F7),
            width: selected ? 2.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? primaryColor.withValues(alpha: 0.04)
                  : const Color(0xFF0F172A).withValues(alpha: 0.02),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Radio Circle
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? primaryColor : const Color(0xFFCBD5E1),
                    width: selected ? 6 : 2,
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            
            // Icon Bubble
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? primaryColor.withValues(alpha: 0.08)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                size: 18,
                color: selected ? primaryColor : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 12),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: selected ? primaryColor : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            
            // Edit Button Icon
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onEditTap,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: selected ? primaryColor : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
