import 'dart:convert';

import '../models/order.dart';

const orderJsonType = 'canteen-mgmt-order';

extension OrderQrCode on Order {
  /// Get a string token representing this Order.
  ///
  /// Validate and read using [OrderQrCode.decode].
  String get token => json.encode({
        'type': orderJsonType,
        'id': id,
      });

  /// Validate a token representing an Order and retrieve its [Order.id].
  ///
  /// Returns `null` if the token is invalid.
  /// Generate tokens with [OrderQrCode.token].
  static int? decode(String token) {
    final j = json.decode(token);
    if (j is! Map || j['type'] != orderJsonType) return null;

    return j['id'];
  }
}
