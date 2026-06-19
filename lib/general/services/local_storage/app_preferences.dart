import 'package:e_com_user/general/services/local_storage/preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences preferences;
  AppPreferences(this.preferences);

  Future<void> setLoggedIn(bool value) async {
    await preferences.setBool(PreferenceKeys.isLoggedIn, value);
  }

  Future<void> setUserId(String id) async {
    await preferences.setString(PreferenceKeys.userId, id);
  }

  String? getUserId() {
    return preferences.getString(PreferenceKeys.userId);
  }

  bool isLoggedin() {
    return preferences.getBool(PreferenceKeys.isLoggedIn) ?? false;
  }

  Future<void> clear() async {
    await preferences.clear();
  }
}
