class Dish {
  final int id;
  final String name;
  final double price;
  final String type;
  final String dishDay;

  Dish({
    this.id = -1,
    required this.name,
    required this.price,
    required this.type,
    this.dishDay = "NOMENUDAY",
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      type: json['type'],
      dishDay: json['dishDay'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'type': type,
        'dishDay':dishDay,
      };

  @override
  String toString() {
    return 'Dish{id: $id, name: $name, price: $price, type: $type, dishDay: $dishDay}';
  }
}
