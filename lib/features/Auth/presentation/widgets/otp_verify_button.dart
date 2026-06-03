
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtpVerifyButton extends StatelessWidget {
  const OtpVerifyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox( 
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          context.go("/home");
          debugPrint("Verify OTP");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          "Verify OTP",
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
