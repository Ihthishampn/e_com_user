import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final int? maxDigits;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const AddressTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.maxDigits,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: AppColors.primaryColor,
          inputFormatters: _buildInputFormatters(),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 22),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.all(18),
            alignLabelWithHint: true,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    final List<TextInputFormatter> list = [];
    if (inputFormatters != null && inputFormatters!.isNotEmpty) {
      list.addAll(inputFormatters!);
    }

    // If maxDigits is provided, restrict to digits only and limit length.
    if (maxDigits != null && maxDigits! > 0) {
      list.add(FilteringTextInputFormatter.digitsOnly);
      list.add(LengthLimitingTextInputFormatter(maxDigits));
    }

    return list.isEmpty ? null : list;
  }
}
