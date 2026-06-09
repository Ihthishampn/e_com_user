import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:e_com_user/features/Auth/data/use_case/auth_use_case.dart';

@injectable
class AuthProvider with ChangeNotifier {
  final AuthUseCase useCase;

  AuthProvider(this.useCase);

  bool isLoading = false;
  bool isVerifying = false;

  String? error;

  Future<bool> handleSendOtp(String phone) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final res = await useCase.sendOtpUse(phone);
      log("OTP SENT => $res");

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    isVerifying = true;
    error = null;
    notifyListeners();

    try {
      final ok = await useCase.verifyOtpUse(phone, otp);

      log("OTP VERIFY => $ok");

      isVerifying = false;
      notifyListeners();
      return ok;
    } catch (e) {
      isVerifying = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}