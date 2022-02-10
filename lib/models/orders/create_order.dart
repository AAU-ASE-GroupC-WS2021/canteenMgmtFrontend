import 'create_order_dish.dart';
import 'create_order_menu.dart';

class CreateOrder {
  final int canteenId;
  List<CreateOrderDish> dishes = [];
  List<CreateOrderMenu> menus = [];
  final DateTime pickupDate;
  final bool reserveTable;

  CreateOrder({
    required this.canteenId,
    required this.dishes,
    required this.menus,
    required this.pickupDate,
    required this.reserveTable,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) {
    return CreateOrder(
      canteenId: json['canteenId'],
      dishes: json['dishes'],
      menus: json['menus'],
      pickupDate: DateTime.fromMillisecondsSinceEpoch(json['pickupDate']),
      reserveTable: json['reserveTable'],
    );
  }

  Map<String, dynamic> toJson() => {
        'canteenId': canteenId,
        'dishes': dishes,
        'menus': menus,
        'pickupDate': pickupDate.millisecondsSinceEpoch,
        'reserveTable': reserveTable,
      };

  @override
  String toString() {
    return 'Order{CanteenID: $canteenId, dishes $dishes, menus $menus, PickupDate: $pickupDate, ReserveTable: $reserveTable}';
  }
}
