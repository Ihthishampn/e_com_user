import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_com_user/general/services/local_storage/app_preferences.dart';

@module
abstract class PreferenceModule {
  @preResolve
  Future<SharedPreferences> sharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @singleton
  AppPreferences appPreferences(SharedPreferences prefs) =>
      AppPreferences(prefs);
}