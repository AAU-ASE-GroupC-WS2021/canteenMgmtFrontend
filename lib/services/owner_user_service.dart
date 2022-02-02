import 'dart:convert';
import 'package:canteen_mgmt_frontend/models/user.dart';

import '../models/canteen.dart';
import 'abstract_service.dart';


class OwnerUserService extends AbstractService {
  Future<List<User>> getAllUsers() async {
    final response = await get('api/owner/user');

    if (response.statusCode == 200) {
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return (responseJson as List).map((p) => User.fromJson(p)).toList();
    } else {

      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<User> createUser(User canteen) async {
    final response = await post('api/owner/user', jsonEncode(canteen));

    if (response.statusCode == 200) {
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return User.fromJson(responseJson);
    } else {
      throw Exception('Failed to create user');
    }
  }
}
