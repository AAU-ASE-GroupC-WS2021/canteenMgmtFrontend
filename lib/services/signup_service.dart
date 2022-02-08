import 'dart:convert';

import '../models/signup.dart';
import 'abstract_service.dart';
import 'util/password_encoder.dart';

class SignupService extends AbstractService {
  Future<String?> createProfile(String username, String password) async {
    var body = json.encode(Signup(
      username: username,
      password: encodePassword(password),
    ).toJson());

    final response = await post('api/register', body);

    return response.statusCode == 200 ? null : response.body;
  }

  Future<Signup> getUserSelfInfo() async {
    final response = await get('api/register');

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Signup.fromJson(json);
    } else {
      throw Exception('Failed to load user info!');
    }
  }
}
