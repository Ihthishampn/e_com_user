import 'package:dio/dio.dart';
import 'package:e_com_user/general/core/keys/keys.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://control.msg91.com/api/v5/',
        headers: {
          'authkey': authKey,
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }
}