import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:flutter/material.dart';

class AddressSubmitButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final Color primaryAccent;
  final bool isLoading;

  const AddressSubmitButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    required this.primaryAccent,
    this.isLoading =  false,
  });

  @override
  
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: enabled
            ? LinearGradient(colors: [primaryAccent, const Color(0xFF6366F1)])
            : const LinearGradient(
                colors: [Color(0xFF334155), Color(0xFF334155)],
              ),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: primaryAccent.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: (enabled && !isLoading) ? onPressed : null,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),      
              )
            : Text(
                'Secure Address',
                style: AppTextStyles.titleMedium.copyWith(
                  color: enabled  ? Colors.white : Colors.white38,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
