import 'dart:convert';

import '../../models/orders/order.dart';

const orderJsonType = 'canteen-mgmt-order';

extension OrderQrCode on Order {
  /// Get a string token representing this Order.
  ///
  /// Validate and read using [OrderQrCode.decode].
  /// Make sure to check if an [OrderQrCode.tokenIsAvailable] before requesting one.
  String? get token => tokenIsAvailable
      ? json.encode({
          'type': orderJsonType,
          'id': id,
        })
      : null;

  /// Check if a token can be generated.
  ///
  /// If false, it may be necessary to reload orders from the backend.
  /// If this is true, [OrderQrCode.token] will return a non-null value.
  get tokenIsAvailable => id != null;

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
