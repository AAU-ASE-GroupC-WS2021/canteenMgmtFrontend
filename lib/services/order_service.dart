import 'dart:convert';

import '../models/create_order.dart';
import '../models/order.dart';
import 'abstract_service.dart';

class OrderService extends AbstractService {
  Future<dynamic> createOrder(CreateOrder createOrder) async {
    var body = json.encode(createOrder.toJson());
    final response = await post('create-order', body);

    if (response.statusCode == 200) {
      final stringData = response.body;
      // TODO: ORDER-MODEL creation
      var responseJson = json.decode(stringData);
      return Order.fromJson(responseJson);
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

  Future<Order> getOrderById(int orderId) async {
    final response = await get('order-by-id?orderId=$orderId');

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return Order.fromJson(responseJson);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load order');
    }
  }
}
