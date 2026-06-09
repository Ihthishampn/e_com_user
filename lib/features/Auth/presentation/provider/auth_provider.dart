import 'dart:developer';
import 'package:e_com_user/features/Auth/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:e_com_user/features/Auth/data/use_case/auth_use_case.dart';
import 'package:e_com_user/general/services/local_storage/app_preferences.dart';

@injectable
class AuthProvider with ChangeNotifier {
  final AuthUseCase useCase;
  final AppPreferences prefs;

  AuthProvider(this.useCase, this.prefs);

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

  Future<void> handleCreateUser({
    required String phone,
    required String name,
  }) async {
    try {
      final user = UserModel(id: phone, name: name, number: phone);
      await useCase.createUserToFirebase(user: user);
      log("Success : user cerated firebase");
      // mark as logged in
      try {
        await prefs.setLoggedIn(true);
      } catch (_) {}
    } catch (e) {
      log("error : create user provider :e");
    }
  }

  bool get isLoggedIn => prefs.isLoggedin();

  Future<void> setLoggedIn(bool v) async {
    await prefs.setLoggedIn(v);
    notifyListeners();
  }
}
