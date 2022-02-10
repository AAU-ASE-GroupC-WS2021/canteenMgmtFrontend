import 'dart:convert';

import '../models/users/avatar.dart';

import 'abstract_service.dart';

class AvatarService extends AbstractService {
  Future<bool> updateAvatar(String username, String avatar) async {
    var body = json.encode(Avatar(
      username: username,
      avatar: avatar,
    ).toJson());

    final response = await post('api/avatar', body);

    return response.statusCode == 200;
  }

  Future<bool> deleteAvatar(String username) async {
    final response = await delete('api/avatar', username);

    return response.statusCode == 200;
  }

  Future<Avatar?> getAvatar(String username) async {
    final response = await get('api/avatar?username=' + username);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Avatar.fromJson(json);
    } else {
      return null;
    }
  }
}
