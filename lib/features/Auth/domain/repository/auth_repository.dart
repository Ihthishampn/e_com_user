import 'package:e_com_user/features/Auth/data/model/user_model.dart';

abstract class AuthRepository {
  Future<String> sendOtp({required String phone});

  Future<bool> verifyOtp({
    required String phone,
    required String reqId,
    required String otp,
  });

  Future<void> retryOtp({required String reqId});

  Future<void> saveUser({required UserModel user});

  Future<bool> isUserExist({required String phone});

  Future<UserModel?> getUser({required String phone});
}
