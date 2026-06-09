abstract class AuthRepository {
  Future<Map<String, dynamic>> sendOtp({required String phone});
  Future<bool> verifyOtp({required String phone, required String otp});
  // save user to firebase collrction

  Future<void> sendUserTofirebase({required String phone,required String name});
}
