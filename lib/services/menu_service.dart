import 'dart:convert';

import '../models/dish.dart';
import 'abstract_service.dart';

class MenuService extends AbstractService {
  Future<List<Dish>> fetchMenus([String menuDay= ' ']) async {

    final response = await get('menu',menuDay);

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

  // Future<Dish> createDish() async {
  //   final menuDay = "MONDAY";
  //   final response = await get('menu', menuDay);
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     final stringData = response.body;
  //     var responseJson = json.decode(stringData);
  //
  //     return Dish.fromJson(responseJson);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to add dish');
  //   }
  // }
}
