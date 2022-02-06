import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/signup.dart';
import 'auth_token.dart';
import 'abstract_service.dart';

class SignInService extends AbstractService {
  Future<String?> login(String username, String password) async {
    var bytes = utf8.encode(password);
    var hash = sha256.convert(bytes).toString();

    var body = json.encode(Signup(
      username: username,
      password: hash,
    ).toJson());

    final response = await post('api/auth', body);

    if (response.statusCode != 200) {
      return response.body;
    }

    if (response.body.length.toString() != AuthTokenUtils.authTokenLength) {
      return response.body;
    }

    AuthTokenUtils.setAuthToken(response.body);
    return null;
  }

  Future<String?> logout() async {
    String token = AuthTokenUtils.getAuthToken() ?? "";

    final response = await delete('api/auth', token);

    AuthTokenUtils.setAuthToken("");

    return response.statusCode == 200 ? null : response.body;
  }
}
