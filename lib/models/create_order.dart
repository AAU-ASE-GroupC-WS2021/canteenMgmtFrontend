import 'create_order_dish.dart';

class CreateOrder {
  final int userId;
  final int canteenId;
  List<CreateOrderDish> dishes = [];
  final DateTime pickupDate;
  final bool reserveTable;

  CreateOrder({
    required this.userId,
    required this.canteenId,
    required this.dishes,
    required this.pickupDate,
    required this.reserveTable,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) {
    return CreateOrder(
      userId: json['userId'],
      canteenId: json['canteenId'],
      dishes: json['dishes'],
      pickupDate: DateTime.fromMillisecondsSinceEpoch(json['pickupDate']),
      reserveTable: json['reserveTable'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'canteenId': canteenId,
        'dishes': dishes,
        'pickupDate': pickupDate.millisecondsSinceEpoch,
        'reserveTable': reserveTable,
      };

  @override
  String toString() {
    return 'Order{User-ID: $userId, CanteenID: $canteenId, dishes $dishes, PickupDate: $pickupDate, ReserveTable: $reserveTable}';
  }
}
