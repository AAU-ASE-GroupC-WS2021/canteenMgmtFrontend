import 'create_order_dish.dart';

class CreateOrder {
  final int userId;
  final int canteenId;
  List<CreateOrderDish> dishes = [];

  CreateOrder({
    required this.userId,
    required this.canteenId,
    required this.dishes,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) {
    return CreateOrder(
      userId: json['userId'],
      canteenId: json['canteenId'],
      dishes: json['dishes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'canteenId': canteenId,
        'dishes': dishes,
      };

  @override
  String toString() {
    return 'Order{User-ID: $userId, CanteenID: $canteenId, dishes $dishes}';
  }
}
