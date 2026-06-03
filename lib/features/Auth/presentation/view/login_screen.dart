import 'package:e_com_user/features/Auth/presentation/widgets/get_otp_button.dart';
import 'package:e_com_user/features/Auth/presentation/widgets/header_image_login.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:e_com_user/general/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(30),

                // image
                HeaderImageLogin(),

                const Gap(40),

                
                Text(
                  "Shop smarter,\nstart with your number",
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),

                const Gap(17),

                Text(
                  "We’ll send you a secure OTP to continue",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const Gap(42),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mobile Number",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      const Gap(26),
//tf
                    CustomTextField(controller: phoneController),
                    ],
                  ),
                ),

                const Gap(52),
//otp
              GetOtpButton(),

                const Gap(18),

                Center(
                  child: Text(
                    "By continuing you agree to our Terms & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),

                const Gap(70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
