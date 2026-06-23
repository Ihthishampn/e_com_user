import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:e_com_user/features/Auth/data/model/user_model.dart';
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepoImpl implements AuthRepository {
  final FirebaseFirestore firestore;

  AuthRepoImpl(this.firestore);

  final _functions = FirebaseFunctions.instance;

  final _auth = FirebaseAuth.instance;

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
  Future<String> sendOtp({required String phone}) async {
    final identifier = _formatPhone(phone);

    final callable = _functions.httpsCallable('sendOtp');

    final result = await callable.call({'phoneNumber': identifier});

    log('SEND OTP => ${result.data}');

    final data = Map<String, dynamic>.from(result.data);

    return data['reqId'];
  }

  @override
  Future<bool> verifyOtp({
    required String phone,
    required String reqId,
    required String otp,
  }) async {
    try {
      final callable = _functions.httpsCallable('verifyOtp');

      final identifier = _formatPhone(phone);

      final result = await callable.call({
        'reqId': reqId,
        'otp': otp,
        'phoneNumber': identifier,
      });

      final data = Map<String, dynamic>.from(result.data);

      final token = data['customToken'];

      await _auth.signInWithCustomToken(token);

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> retryOtp({required String reqId}) async {
    return false;
  }

  @override
  Future<void> saveUser({required UserModel user}) async {
    await firestore.collection('users').doc(user.number).set(user.toMap());
  }

  @override
  Future<bool> isUserExist({required String phone}) async {
    final doc = await firestore.collection('users').doc(phone).get();

    return doc.exists;
  }

  @override
  Future<UserModel?> getUser({required String phone}) async {
    final doc = await firestore.collection('users').doc(phone).get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromMap(doc.data()!, doc.id);
  }
}
