import 'dart:convert';

import '../models/menu.dart';
import 'abstract_service.dart';

class MenuService extends AbstractService {
  Future<List<Menu>> fetchMenus({String menuDay = ''}) async {
    final response = await get('menu?menuDay=$menuDay');
    // log(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final stringData = response.body;
      var responseJson = json.decode(stringData);
      // log(responseJson.toString());
      return (responseJson as List).map((p) => Menu.fromJson(p)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Menus');
    }
  }

  Future<String> createMenu(Menu menu) async {
    final response = await post('menu', jsonEncode(menu));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add dish');
    }
  }

  Future<String> updateMenu(Menu menu) async {
    final response = await put('menu', jsonEncode(menu));

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

  Future<String> deleteMenu(Menu menu) async {
    final response = await delete('menu', jsonEncode(menu));

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
