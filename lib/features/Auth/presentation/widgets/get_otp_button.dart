import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_com_user/features/Auth/presentation/provider/auth_provider.dart';

class GetOtpButton extends StatelessWidget {
  final TextEditingController phoneController;
  final Function(String phone) onSuccess;

  const GetOtpButton({
    super.key,
    required this.phoneController,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, prov, _) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: prov.isLoading
                ? null
                : () async {
                    final phone = phoneController.text.trim();
                    if (phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Number is required")),
                      );
                      return;
                    }
                    if (phone.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter a 10-digit phone number.",
                          ),
                        ),
                      );
                      return;
                    }

                    final ok = await prov.handleSendOtp(phone);

                    if (ok) {
                      onSuccess(phone);
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(prov.error ?? "OTP failed")),
                      );
                    }
                  },
            child: prov.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Get OTP",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
