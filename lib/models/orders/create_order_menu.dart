class CreateOrderMenu {
  final int id;
  final int count;

  CreateOrderMenu({
    required this.id,
    required this.count,
  });

  factory CreateOrderMenu.fromJson(Map<String, dynamic> json) {
    return CreateOrderMenu(
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
    return 'Menu{id: $id, count: $count}';
  }
}
