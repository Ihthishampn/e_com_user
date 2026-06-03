import 'package:e_com_user/features/Auth/presentation/widgets/otp_verify_button.dart';

import 'package:e_com_user/general/widgets/custom_otp_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String maskedNumber = "91 99xxxx987";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),

              const Text(
                "Verify your number",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const Gap(10),

              Text(
                "We have sent a 6-digit OTP to\n+ $maskedNumber",
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
              ),

              const Gap(40),
// otp circle field
            CustomOtpTextField(),

              const Gap(12),

              Center(
                child: TextButton(
                  onPressed: () {
                    debugPrint("Resend OTP");
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Color.fromARGB(255, 15, 73, 121),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(),
//button otp verify
              OtpVerifyButton(),

              const Gap(60),
            ],
          ),
        ),
      ),
    );
  }
}
