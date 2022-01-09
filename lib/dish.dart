class Dish {
  final int id;
  final String name;
  final double price;
  final String type;

  Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      type: json['type'],
    );
  }

  @override
  String toString() {
    return 'Dish{id: $id, name: $name, price: $price, type: $type}';
  }
}