import 'package:injectable/injectable.dart';
import 'package:e_com_user/features/Auth/domain/repository/auth_repository.dart';

@lazySingleton
class AuthUseCase {
  final AuthRepository repo;

  AuthUseCase(this.repo);

  Future<Map<String, dynamic>> sendOtpUse(String phone) {
    return repo.sendOtp(phone: phone);
  }

  Future<bool> verifyOtpUse(String phone, String otp) {
    return repo.verifyOtp(phone: phone, otp: otp);
  }
}