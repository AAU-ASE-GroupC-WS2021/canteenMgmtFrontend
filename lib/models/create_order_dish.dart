class CreateOrderDish {
  final int id;
  final int count;

  CreateOrderDish({
    required this.id,
    required this.count,
  });

  factory CreateOrderDish.fromJson(Map<String, dynamic> json) {
    return CreateOrderDish(
      id: json['id'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'count': count,
      };

  @override
  String toString() {
    return 'Dish{id: $id, count: $count}';
  }
}
