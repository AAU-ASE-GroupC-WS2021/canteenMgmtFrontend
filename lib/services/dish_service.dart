import 'dart:convert';

import '../models/dish.dart';
import 'abstract_service.dart';

class DishService extends AbstractService {
  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080/',
  );

  Future<List<Dish>> fetchDishes({String? dishDay}) async {
    final response = await get(
      'dish',
      queryParams: dishDay != null ? {'dishDay': dishDay} : null,
    );
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

  Future<Dish> createDish(Dish dish) async {
    final response = await post('dish', jsonEncode(dish));

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

  Future<String> updateDish(Dish dish) async {
    final response = await put('dish', jsonEncode(dish));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final stringData = response.body;
      return stringData.toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update dish');
    }
  }

  Future<String> deleteDish(String dishName) async {
    final response = await delete('dish', dishName);

    if (response.statusCode == 200) {
      //   // If the server did return a 200 OK response,
      //   // then parse the JSON.
      final stringData = response.body;
      return stringData.toString();
    } else {
      //    // If the server did not return a 200 OK response,
      //    // then throw an exception.
      final stringData = response.body;
      throw Exception(stringData.toString());
    }
  }
}
