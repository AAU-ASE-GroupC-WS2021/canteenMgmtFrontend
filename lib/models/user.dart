class User {
  final int id;
  final String username;
  final UserType type;
  final int? canteenID;

  User({
    this.id = -1,
    required this.username,
    required this.type,
    this.canteenID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      type: UserType.values.firstWhere((e) => e.name == json['type']),
      canteenID: json['canteenID'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'type': type.name,
    'canteenID': canteenID,
  };

  @override
  String toString() {
    return username;
  }
}

enum UserType {
  USER,
  ADMIN,
  OWNER,
}
