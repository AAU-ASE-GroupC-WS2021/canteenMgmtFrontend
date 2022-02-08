import 'dart:convert';

import '../models/user.dart';
import 'abstract_service.dart';
import 'util/password_encoder.dart';

class OwnerUserService extends AbstractService {
  Future<List<User>> getAllUsers() async {
    return _parseUserListResponse(await get('api/owner/user'));
  }

  Future<User> createUser(User user) async {
    final response = await post(
      'api/owner/user',
      jsonEncode(getUserWithEncodedPassword(user)),
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return User.fromJson(responseJson);
    } else {
      throw Exception(
        'Failed to create user (${response.statusCode} - ${response.body})',
      );
    }
  }

  Future<User> updateUser(User user) async {
    final response = await put(
      'api/owner/user/${user.id}',
      jsonEncode(getUserWithEncodedPassword(user)),
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return User.fromJson(responseJson);
    } else {
      throw Exception(
        'Failed to update user (${response.statusCode} - ${response.body})',
      );
    }
  }

  Future<List<User>> getAllByTypeAndCanteen(UserType type, int id) async {
    return _parseUserListResponse(
      await get('api/owner/user?type=${type.name}&canteenID=$id'),
    );
  }

  Future<List<User>> getAllByCanteen(int id) async {
    return _parseUserListResponse(await get('api/owner/user?canteenID=$id'));
  }

  Future<List<User>> getAllByType(UserType type) async {
    return _parseUserListResponse(
      await get('api/owner/user?type=${type.name}'),
    );
  }

  List<User> _parseUserListResponse(response) {
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return (responseJson as List).map((p) => User.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  User getUserWithEncodedPassword(User user) {
    return User(
      username: user.username,
      password: user.password != null ? encodePassword(user.password!) : null,
      type: user.type,
      canteenID: user.canteenID,
    );
  }
}
