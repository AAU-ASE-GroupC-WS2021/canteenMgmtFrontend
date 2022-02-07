// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import '../key_value_store.dart';

class CookieStore extends KeyValueStore {
  @override
  String? get(String key) {
    String cookies = html.window.document.cookie ?? '';
    List<String> listValues = cookies.isNotEmpty ? cookies.split(';') : [];
    String matchVal = '';
    for (int i = 0; i < listValues.length; i++) {
      List<String> map = listValues[i].split('=');
      String _key = map[0].trim();
      String _val = map[1].trim();
      if (key == _key) {
        matchVal = _val;
        break;
      }
    }
    return matchVal;
  }

  @override
  void set(String key, String? value) {
    String cookies = html.window.document.cookie ?? '';
    List<String> listValues = cookies.isNotEmpty ? cookies.split(';') : [];
    listValues.removeWhere((cookie) => cookie.split('=').first.trim() == key);

    listValues.add('$key=${value ?? ''}');
    html.window.document.cookie = listValues.join(';') + ';';
  }

  @override
  void delete(String key) => set(key, null);

  @override
  void reset() {
    html.window.document.cookie = '';
  }
}

KeyValueStore getKeyValueStoreWeb() => CookieStore();
