import 'package:e_com_user/features/Auth/data/model/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart';

@lazySingleton
class AuthUseCase {
  final AuthRepository repo;

  AuthUseCase(this.repo);

  /// Sends OTP and returns the reqId needed for verification.
  Future<String> sendOtpUse(String phone) {
    return repo.sendOtp(phone: phone);
  }

  /// Verifies OTP using the reqId returned by sendOtpUse.
  Future<void> verifyOtpUse({required String reqId, required String otp}) {
    return repo.verifyOtp(reqId: reqId, otp: otp);
  }

  Future<void> retryOtpUse({required String reqId}) {
    return repo.retryOtp(reqId: reqId);
  }

  Future<void> saveUser({required UserModel user}) {
    return repo.saveUser(user: user);
  }

  Future<bool> isUserExist({required String phone}) {
    return repo.isUserExist(phone: phone);
  }

  Future<UserModel?> getUser({required String phone}) {
    return repo.getUser(phone: phone);
  }
}
