class OrderMenu {
  final int id;
  final String name;
  final double price;
  int count;

  OrderMenu({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
  });

  factory OrderMenu.fromJson(Map<String, dynamic> json) {
    return OrderMenu(
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
    return 'Menu{id: $id, name: $name, price: $price,  count: $count}';
  }
}
