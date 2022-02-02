import 'package:collection/collection.dart';

import 'dish.dart';

class Order {
  final int? id;
  final int canteenId;
  final int userId;
  final Map<Dish, int> dishes;

  Order({
    this.id,
    required this.canteenId,
    required this.userId,
    required this.dishes,
  });

  double get totalPrice => dishes.entries.map((e) => e.key.price * e.value).sum;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        canteenId: json['canteenId'],
        userId: json['userId'] ?? 1,
        dishes: {
          for (var dishJson in (json['dishes'] as List))
            Dish.fromJson(dishJson): dishJson['count'],
        },
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'canteenId': canteenId,
        'dishes': dishes.entries.map(
          (dishEntry) => dishEntry.key.toJson().addAll(
            {'count': dishEntry.value},
          ),
        ),
      };
}
