class OrderDish {
  final int id;
  final String name;
  final double price;
  int count;

  OrderDish({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
  });

  factory OrderDish.fromJson(Map<String, dynamic> json) {
    return OrderDish(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'count': count,
      };

  @override
  String toString() {
    return 'Dish{id: $id, name: $name, price: $price,  count: $count}';
  }
}
