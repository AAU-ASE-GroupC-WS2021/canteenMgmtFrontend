import 'dart:convert';
import 'package:canteen_mgmt_frontend/models/user.dart';

import '../models/canteen.dart';
import 'abstract_service.dart';


class OwnerUserService extends AbstractService {
  Future<List<User>> getAllUsers() async {
    return _parseUserListResponse(await get('api/owner/user'));
  }

  Future<User> createUser(User user) async {
    final response = await post('api/owner/user', jsonEncode(user));

    if (response.statusCode == 200) {
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return User.fromJson(responseJson);
    } else {
      throw Exception('Failed to create user (${response.statusCode} - ${response.body})');
    }
  }

  Future<User> updateUser(User user) async {
    final response = await put('api/owner/user/${user.id}', jsonEncode(user));

    if (response.statusCode == 200) {
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return User.fromJson(responseJson);
    } else {
      throw Exception('Failed to update user (${response.statusCode} - ${response.body})');
    }
  }

  Future<List<User>>  getAllByTypeAndCanteen(UserType type, int id) async {
    return _parseUserListResponse(await get('api/owner/user?type=${type.name}&canteenID=$id'));
  }

  Future<List<User>>  getAllByType(UserType type) async {
    return _parseUserListResponse(await get('api/owner/user?type=${type.name}'));
  }

  List<User> _parseUserListResponse(response) {
    if (response.statusCode == 200) {
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return (responseJson as List).map((p) => User.fromJson(p)).toList();
    } else {

      throw Exception('Failed to load users: ${response.body}');
    }
  }
}
