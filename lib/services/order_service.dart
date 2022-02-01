import 'dart:convert';
import 'dart:developer';

import 'package:canteen_mgmt_frontend/models/order.dart';

import '../models/create_order.dart';
import 'abstract_service.dart';

class OrderService extends AbstractService {
  Future<dynamic> createOrder(CreateOrder createOrder) async {
    var body = json.encode(createOrder.toJson());
    final response = await post('create-order', body);

    if (response.statusCode == 200) {
      final stringData = response.body;
      // TODO: ORDER-MODEL creation
      var responseJson = json.decode(stringData);
      return responseJson;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to create order');
    }
  }

  Future<List<Order>> getOrders() async {
    // TODO get user
    int userId = 1;
    final response = await get('order?userId=$userId');

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      log(response.body);
      log(responseJson.toString());

      if (responseJson is! List) {
        throw const FormatException('Result from order is not a list');
      }

      return (responseJson).map((p) => Order.fromJson(p)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load orders');
    }
  }
}
