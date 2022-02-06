import 'package:flutter/foundation.dart';

import 'key_value_store.dart';
import 'web/key_value_store_web_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'web/key_value_store_web.dart'
    show getKeyValueStoreWeb;

class AuthTokenUtils {
  AuthTokenUtils._(); // singleton (private constructor)

  static final _store = kIsWeb ? getKeyValueStoreWeb() : KeyValueStore();

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

    return _store.get(authTokenKey);
  }

  static void setAuthToken(String token) {
    _store.set(authTokenKey, token);
    _loggedIn = token.length.toString() == authTokenLength;
  }

  static bool isLoggedIn() {
    if (_loggedIn == null) {
      return _store.get(authTokenKey)?.isNotEmpty ?? false;
    }

    return _loggedIn == true;
  }
}
