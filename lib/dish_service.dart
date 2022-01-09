import 'package:canteen_mgmt_frontend/abstract_service.dart';

import 'dish.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DishService extends AbstractService {

  Future<List<Dish>> fetchDishes() async {
    var client = http.Client();
    final response = await client.get(getUri('dish'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final stringData = response.body;
      var responseJson = json.decode(stringData);
      return (responseJson as List)
          .map((p) => Dish.fromJson(p))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load dishes');
    }
  }
}