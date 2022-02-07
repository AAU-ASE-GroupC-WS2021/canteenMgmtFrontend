import 'dart:convert';

import 'package:crypto/crypto.dart';

String encodePassword(String password) {
  var bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}
