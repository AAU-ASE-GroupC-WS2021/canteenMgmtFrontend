import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_store.dart';

class SharedPrefsStore extends KeyValueStore {
  SharedPreferences? _prefs;

  SharedPrefsStore([SharedPreferences? prefs]) : _prefs = prefs {
    if (prefs == null) {
      SharedPreferences.getInstance().then((value) => _prefs = value);
    }
  }

  @override
  String? get(String key) => _prefs?.getString(key);

  @override
  void set(String key, String? value) {
    return value == null ? delete(key) : _prefs?.setString(key, value);
  }

  @override
  void delete(String key) => _prefs?.remove(key);
}
