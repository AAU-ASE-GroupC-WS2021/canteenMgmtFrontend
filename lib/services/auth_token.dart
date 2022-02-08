import 'package:get_it/get_it.dart';

import 'key_value_store.dart';

class AuthTokenUtils {
  AuthTokenUtils._(); // singleton (private constructor)

  static final _store = GetIt.I.get<KeyValueStore>();

  static const authTokenKey = String.fromEnvironment(
    'AUTH_TOKEN',
    defaultValue: 'Auth-Token',
  );

  static const authTokenLength = String.fromEnvironment(
    'AUTH_TOKEN_LENGTH',
    defaultValue: '36',
  );

  static bool? _loggedIn;

  static String? getAuthToken() => _store.get(authTokenKey);

  static void setAuthToken(String? token) {
    _store.set(authTokenKey, token);
    _loggedIn = token != null && token.length.toString() == authTokenLength;
  }

  static bool isLoggedIn() {
    if (_loggedIn == null) {
      return _store.get(authTokenKey)?.isNotEmpty ?? false;
    }

    return _loggedIn ?? false;
  }
}
