import 'dart:convert';
import 'dart:math';

import 'package:canteen_mgmt_frontend/models/signup.dart';

import '../models/dish.dart';
import 'abstract_service.dart';

class SignupService extends AbstractService {
  Future<List<Signup>> fetchDishes() async {
    final response = await get('user');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return (responseJson as List).map((p) => Signup.fromJson(p)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load profiles!');
    }
  }

  Future<bool> createProfile(String username, String password) async {
    var body = json.encode(Signup(
      username: username,
      password: password,
    ).toJson());

    final response = await post('user', body);

    if (response.statusCode == 200)
    {
      return true;
    }
    else
    {
      return false;
      // throw Exception('Failed to create a profile!\n\n: ' + response.body);
    }
  }
}
