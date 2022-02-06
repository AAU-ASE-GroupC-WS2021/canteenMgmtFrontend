library utils.authTokenUtils;

// TODO: If trying to create a native app, this has to go (somewhere else).
// It applies only to web app.
import 'dart:html' as html;

class AuthTokenUtils {
  static const authTokenKey = String.fromEnvironment(
    'AUTH_TOKEN',
    defaultValue: 'Auth-Token',
  );

  static const authTokenLength = String.fromEnvironment(
    'AUTH_TOKEN_LENGTH',
    defaultValue: '36',
  );

  static bool? _loggedIn;

  static String? getAuthToken() {
    if (!isLoggedIn()) {
      return null;
    }

    return getCookie(authTokenKey);
  }

  static void setAuthToken(String token) {
    html.window.document.cookie = "$authTokenKey=$token;";
    _loggedIn = token.length.toString() == authTokenLength;
  }

  static bool isLoggedIn() {
    if (_loggedIn == null) {
      return getCookie(authTokenKey).isNotEmpty;
    }

    return _loggedIn == true;
  }

  static String getCookie(String key) {
    String cookies = html.window.document.cookie ?? "";
    List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
    String matchVal = "";
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split("=");
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }
}
