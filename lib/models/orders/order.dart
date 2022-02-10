import 'package:collection/collection.dart';

import '../dish.dart';
import '../menu.dart';

class Order {
  final int? id;
  final int canteenId;
  final int userId;
  final Map<Dish, int> dishes;
  final Map<Menu, int> menus;
  final DateTime pickupDate;
  final bool reserveTable;

  const Order({
    this.id,
    required this.canteenId,
    required this.userId,
    required this.dishes,
    required this.menus,
    required this.pickupDate,
    required this.reserveTable,
  });

  double get totalPrice =>
      dishes.entries.map((e) => e.key.price * e.value).sum +
      menus.entries.map((e) => e.key.price * e.value).sum;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        canteenId: json['canteenId'],
        userId: json['userId'] ?? 1,
        dishes: {
          for (var dishJson in (json['dishes'] as List))
            Dish.fromJson(dishJson): dishJson['count'],
        },
        menus: {
          for (var menuJson in (json['menus'] as List))
            Menu.fromJson(menuJson): menuJson['count'],
        },
        pickupDate: DateTime.fromMillisecondsSinceEpoch(json['pickupDate']),
        reserveTable: json['reserveTable'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'canteenId': canteenId,
        'dishes': dishes.entries.map(
          (dishEntry) => dishEntry.key.toJson().addAll(
            {'count': dishEntry.value},
          ),
        ),
        'menus': menus.entries.map(
          (menuEntry) => menuEntry.key.toJson().addAll(
            {'count': menuEntry.value},
          ),
        ),
        'pickupDate': pickupDate.millisecondsSinceEpoch,
        'reserveTable': reserveTable,
      };
}
