import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/features/Auth/data/model/user_model.dart';
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

@LazySingleton(as: AuthRepository)
class AuthRepoImpl implements AuthRepository {
  final FirebaseFirestore firestore;

  AuthRepoImpl(this.firestore);

  String _formatPhone(String phone) {
    String identifier = phone.trim().replaceAll(' ', '');

    if (identifier.startsWith('+')) {
      identifier = identifier.substring(1);
    }

    if (identifier.length == 10) {
      identifier = '91$identifier';
    }

    return identifier;
  }

  @override
  Future<String> sendOtp({
    required String phone,
  }) async {
    final identifier = _formatPhone(phone);

    final response = await OTPWidget.sendOTP({
      'identifier': identifier,
    });

    log("OTP SEND RESPONSE => $response");

    final data = response as Map?;

    if (data != null && data['type'] == 'success') {
      return data['message'] ?? 'OTP Sent';
    }

    throw Exception('Failed to send OTP');
  }

  @override
  Future<bool> verifyOtp({
    required String reqId,
    required String otp,
  }) async {
    final response = await OTPWidget.verifyOTP({
      'reqId': reqId,
      'otp': otp,
    });

    log("OTP VERIFY RESPONSE => $response");

    final data = response as Map?;

    return data != null && data['type'] == 'success';
  }

  @override
  Future<bool> retryOtp({
    required String reqId,
  }) async {
    final response = await OTPWidget.retryOTP({
      'reqId': reqId,
      'retryChannel': 11,
    });

    log("OTP RETRY RESPONSE => $response");

    final data = response as Map?;

    return data != null && data['type'] == 'success';
  }

  @override
  Future<void> saveUser({
    required UserModel user,
  }) async {
    await firestore
        .collection('users')
        .doc(user.number)
        .set(user.toMap());

    log("USER SAVED => ${user.number}");
  }

  @override
  Future<bool> isUserExist({
    required String phone,
  }) async {
    final doc = await firestore
        .collection('users')
        .doc(phone)
        .get();

    return doc.exists;
  }

  @override
  Future<UserModel?> getUser({
    required String phone,
  }) async {
    final doc = await firestore
        .collection('users')
        .doc(phone)
        .get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!,doc.id);
  }
}