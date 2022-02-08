import 'dart:convert';

import '../models/signup.dart';
import 'abstract_service.dart';
import 'auth_token.dart';
import 'util/password_encoder.dart';

class SignInService extends AbstractService {
  Future<String?> login(String username, String password) async {
    var body = json.encode(Signup(
      username: username,
      password: encodePassword(password),
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

    AuthTokenUtils.setAuthToken(null);

    return response.statusCode == 200 ? null : response.body;
  }
}
