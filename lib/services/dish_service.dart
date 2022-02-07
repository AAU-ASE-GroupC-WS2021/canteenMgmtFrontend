import 'dart:convert';

import '../models/dish.dart';
import 'abstract_service.dart';
import 'package:http/http.dart' as http;

class DishService extends AbstractService {
  static const backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:8080/',
  );

  final _client = http.Client();

  Uri _getUri(String path) {
    String uriString = backendUrl + path;

    return Uri.parse(uriString);
  }
  Future<http.Response> get(path, [dishDay]) {
    if (dishDay != null)
    {
      var pathnew = Uri.parse(backendUrl + path).replace(queryParameters: {
        'dishDay': dishDay,
      });
      return _client.get(pathnew, headers: getHeaders());
    }
    else
    {
      return _client.get(_getUri(path), headers: getHeaders());
    }

  }

  Future<List<Dish>> fetchDishes([dishDay]) async {
    // final response = dishDay != null ? await get('dish', dishDay = dishDay) : await get('dish');
    final response = await get('dish', dishDay);
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

  Future<String> deleteDish(Dish dish) async {
    final response = await delete('dish', jsonEncode(dish));

     if (response.statusCode == 200) {
     //   // If the server did return a 200 OK response,
     //   // then parse the JSON.
        final stringData = response.body;
        return stringData.toString();
      }
      else {
     //    // If the server did not return a 200 OK response,
     //    // then throw an exception.
       final stringData = response.body;
       throw Exception(stringData.toString());
    }
  }
}
