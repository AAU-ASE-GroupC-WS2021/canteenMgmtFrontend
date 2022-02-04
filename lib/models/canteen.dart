
class Canteen {
  final int id;
  final String name;
  final String address;
  final int numTables;

  const Canteen({
    this.id = -1,
    required this.name,
    required this.address,
    required this.numTables,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      numTables: json['numTables'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'numTables': numTables,
  };

  @override
  String toString() {
    return '$name, $address';
  }
}
