import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart';
import 'package:e_com_user/features/Auth/presentation/widgets/otp_verify_button.dart';
import 'package:e_com_user/features/Root/presentation/view/root_screen.dart';
import 'package:e_com_user/general/widgets/custom_otp_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String phoneN;
  const OtpScreen({super.key, required this.phoneN});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  String get maskedNumber {
    final p = widget.phoneN;
    if (p.length < 4) return p;
    return "${p.substring(0, 2)} xxxx ${p.substring(p.length - 3)}";
  }

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const Gap(40),

              CustomOtpTextField(controller: otpController),

              const Gap(12),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Consumer<AuthProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: provider.isVerifying
                          ? null
                          : () async {
                              final otp = otpController.text.trim();

                              final apiOk = await provider.verifyOtp(
                                widget.phoneN,
                                otp,
                              );

                              // RULE: API success OR manual bypass 2244
                              if (apiOk || otp == "2244") {
                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RootScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invalid OTP"),
                                  ),
                                );
                              }
                            },
                      child: provider.isVerifying
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Verify OTP",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  );
                },
              ),

              const Gap(60),
            ],
          ),
        ),
      ),
    );
  }
}