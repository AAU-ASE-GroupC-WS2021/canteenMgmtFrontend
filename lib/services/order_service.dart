import 'dart:convert';

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
}
