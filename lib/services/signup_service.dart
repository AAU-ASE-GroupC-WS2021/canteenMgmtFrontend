import 'dart:convert';
import 'package:canteen_mgmt_frontend/models/passwordChange.dart';
import 'package:crypto/crypto.dart';

import '../models/signup.dart';
import 'abstract_service.dart';

class SignupService extends AbstractService {

  Future<String?> createProfile(String username, String password) async {
    var bytes = utf8.encode(password);
    var hash = sha256.convert(bytes).toString();

    var body = json.encode(Signup(
      username: username,
      password: hash,
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

  Future<String?> updatePassword(String username, String oldPassword, String newPassword) async {

    var bytesOld = utf8.encode(oldPassword);
    var hashOld = sha256.convert(bytesOld).toString();

    var bytesNew = utf8.encode(newPassword);
    var hashNew = sha256.convert(bytesNew).toString();

    var body = json.encode(PasswordChange(
      username: username,
      passwordOld: hashOld,
      passwordNew: hashNew,
    ).toJson());

    final response = await post('api/password', body);

    return response.statusCode == 200 ? null : response.body.toString();
  }

}
