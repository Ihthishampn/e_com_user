import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomOtpTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomOtpTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        controller: controller,
        keyboardType: TextInputType.number,
        animationType: AnimationType.fade,
        cursorColor: AppColors.primaryColor,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 55,
          fieldWidth: 45,
          activeColor: AppColors.primaryColor,
          selectedColor: Colors.grey,
          inactiveColor: Colors.grey.shade300,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.grey.shade100,
          selectedFillColor: Colors.white,
        ),
        enableActiveFill: true,
        onChanged: (value) {},
        onCompleted: (value) {
          debugPrint("OTP Entered: $value");
        },
      ),
    );
  }
}