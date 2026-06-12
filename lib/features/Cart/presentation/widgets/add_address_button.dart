import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AddAddressButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddAddressButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColor;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: onTap ?? () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Add Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'This is a demo UI. Add address flow goes here.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt_outlined, size: 18),
            SizedBox(width: 8),
            Text(
              'Add New Address',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
