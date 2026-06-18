import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart';
import 'package:e_com_user/general/widgets/custom_otp_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String phoneN;
  final String name;

  const OtpScreen({
    super.key,
    required this.phoneN,
    required this.name,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpValue = "";

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
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),

              Text(
                "We have sent OTP to\n+ $maskedNumber",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const Gap(40),

              CustomOtpTextField(
                onChanged: (value) {
                  otpValue = value;
                },
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
                              final otp = otpValue.trim();

                              if (otp.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("OTP is required"),
                                  ),
                                );
                                return;
                              }

                              if (otp.length != 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Enter your 4 digit OTP",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final apiOk = await provider.verifyOtp(otp);

                              final allow = apiOk;

                              if (!allow) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invalid OTP"),
                                  ),
                                );
                                return;
                              }

                              await provider.handleCreateUser(
                                phone: widget.phoneN,
                                name: widget.name,
                              );

                              if (!context.mounted) return;

                              context.go("/root");
                            },
                      child: provider.isVerifying
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Verify OTP",
                              style: TextStyle(
                                color: Colors.white,
                              ),
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