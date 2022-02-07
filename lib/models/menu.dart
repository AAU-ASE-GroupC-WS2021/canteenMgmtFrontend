

class Menu {
  final int id;
  final String name;
  final double price;
  final String menuDay;
  final List<String> menuDishNames;

  const Menu({
    this.id = -1,
    required this.name,
    required this.price,
    required this.menuDishNames,
    this.menuDay = "NOMENUDAY",
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      menuDishNames: List<String>.from(json['menuDishNames']),
      menuDay: json['menuDay'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'menuDishNames': menuDishNames,
        'menuDay':menuDay,
      };

  @override
  String toString() {
    return 'Dish{id: $id, name: $name, price: $price, menuDishNames: $menuDishNames, menuDay: $menuDay}';
  }
}
