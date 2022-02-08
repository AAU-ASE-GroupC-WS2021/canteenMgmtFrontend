import 'create_order_dish.dart';

class CreateOrder {
  final int canteenId;
  List<CreateOrderDish> dishes = [];
  final DateTime pickupDate;
  final bool reserveTable;

  CreateOrder({
    required this.canteenId,
    required this.dishes,
    required this.pickupDate,
    required this.reserveTable,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) {
    return CreateOrder(
      canteenId: json['canteenId'],
      dishes: json['dishes'],
      pickupDate: DateTime.fromMillisecondsSinceEpoch(json['pickupDate']),
      reserveTable: json['reserveTable'],
    );
  }

  Map<String, dynamic> toJson() => {
        'canteenId': canteenId,
        'dishes': dishes,
        'pickupDate': pickupDate.millisecondsSinceEpoch,
        'reserveTable': reserveTable,
      };

  @override
  String toString() {
    return 'Order{CanteenID: $canteenId, dishes $dishes, PickupDate: $pickupDate, ReserveTable: $reserveTable}';
  }
}
