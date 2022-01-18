import 'dart:convert';

import '../models/dish.dart';
import 'abstract_service.dart';


class DishService extends AbstractService {
  Future<List<Dish>> fetchDishes() async {
    final response = await get('dish');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return (responseJson as List).map((p) => Dish.fromJson(p)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load dishes');
    }
  }

  Future<Dish> createDish() async {
    var body = json.encode(Dish(name: "Test", price: 9.99, type: "STARTER").toJson());
    final response = await post('dish', body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final stringData = response.body;
      var responseJson = json.decode(stringData);

      return Dish.fromJson(responseJson);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add dish');
    }
  }
}
