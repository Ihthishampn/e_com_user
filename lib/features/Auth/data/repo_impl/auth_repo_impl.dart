import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart';
import 'package:e_com_user/general/core/keys/keys.dart';

@LazySingleton(as: AuthRepository)
class AuthRepoImpl implements AuthRepository {
  final Dio _dio;
  final FirebaseFirestore firebaseFirestore;

  AuthRepoImpl(this._dio, this.firebaseFirestore);

  String _formatPhone(String phone) {
    phone = phone.trim();
    if (phone.startsWith('+91')) return phone;
    if (phone.startsWith('91')) return '+$phone';
    return '+91$phone';
  }

  @override
  Future<Map<String, dynamic>> sendOtp({required String phone}) async {
    final payload = {"template_id": templateId, "mobile": _formatPhone(phone)};

    log("SEND OTP => $payload");

    final res = await _dio.post('otp', data: payload);

    log("SEND OTP RESPONSE => ${res.data}");

    return Map<String, dynamic>.from(res.data);
  }

  @override
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    final payload = {"otp": otp, "mobile": _formatPhone(phone)};

    log("VERIFY OTP => $payload");

    final res = await _dio.post('otp/verify', data: payload);

    log("VERIFY RESPONSE => ${res.data}");

    final data = res.data;

    if (data is Map && data['type'] == 'success') {
      return true;
    }

    return false;
  }

  @override
  Future<void> sendUserTofirebase({
    required String phone,
    required String name,
  }) async {
    try {
      final formatedPhone = _formatPhone(phone);
      await firebaseFirestore.collection("users").doc(formatedPhone).set({
        "name": name,
        "phone": phone,
        "createAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log("error while assing user to firebase");
    }
  }
}
