abstract class AuthRepository {
  Future<Map<String, dynamic>> sendOtp({required String phone});
  Future<bool> verifyOtp({required String phone, required String otp});
}