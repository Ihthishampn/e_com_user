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

  /// Stored after sendOtp succeeds — used by verifyOtp.
  String? _reqId;

  /// Sends OTP to [phone] and stores the reqId for later verification.
  /// Returns true on success.
  Future<bool> handleSendOtp(String phone) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final reqId = await useCase.sendOtpUse(phone);
      _reqId = reqId;
      log("OTP SENT => reqId: $reqId");

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

  /// Verifies the OTP using the reqId stored from [handleSendOtp].
  /// Returns true on success, false on failure.
  Future<bool> verifyOtp(String otp) async {
    if (_reqId == null) {
      error = "Session expired. Please request OTP again.";
      notifyListeners();
      return false;
    }

    isVerifying = true;
    error = null;
    notifyListeners();

    try {
      await useCase.verifyOtpUse(reqId: _reqId!, otp: otp);
      log("OTP VERIFIED");

      isVerifying = false;
      notifyListeners();
      return true;
    } catch (e) {
      isVerifying = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Retries OTP delivery using the stored reqId.
  Future<void> retryOtp() async {
    if (_reqId == null) return;
    try {
      await useCase.retryOtpUse(reqId: _reqId!);
      log("OTP RETRY requested");
    } catch (e) {
      log("OTP RETRY error: $e");
    }
  }

  /// Creates the user in Firestore and marks as logged in.
  Future<void> handleCreateUser({
    required String phone,
    required String name,
  }) async {
    try {
      final user = UserModel(id: phone, name: name, number: phone);
      await useCase.saveUser(user: user);
      log("User saved to Firestore: $phone");
      try {
        await prefs.setLoggedIn(true);
        // store the user id/phone locally so other flows can access it
        try {
          await prefs.setUserId(phone);
        } catch (_) {}
      } catch (_) {}
    } catch (e) {
      log("Error creating user: $e");
    }
  }

  bool get isLoggedIn => prefs.isLoggedin();

  Future<void> setLoggedIn(bool v) async {
    await prefs.setLoggedIn(v);
    notifyListeners();
  }
}
