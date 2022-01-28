import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenUtils {

  static const authTokenKey = String.fromEnvironment(
    'AUTH_TOKEN',
    defaultValue: 'Auth-Token',
  );

  static const authTokenLength = String.fromEnvironment(
    'AUTH_TOKEN_LENGTH',
    defaultValue: '36',
  );

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }

  static void setAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authTokenKey, token);
  }

}