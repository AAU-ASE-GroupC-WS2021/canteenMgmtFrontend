class OrderDish {
  final int id;
  final String name;
  final double price;
  final String type;
  int count;

  OrderDish({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.count,
  });

  factory OrderDish.fromJson(Map<String, dynamic> json) {
    return OrderDish(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      type: json['type'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'type': type,
        'count': count,
      };

  @override
  String toString() {
    return 'Dish{id: $id, name: $name, price: $price, type: $type, count: $count}';
  }
}
