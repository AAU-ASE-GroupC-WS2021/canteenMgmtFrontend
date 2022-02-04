class Signup {
  final int id;
  final String username;
  final String password;
  final String type;

  Signup({
    this.id = -1,
    required this.username,
    this.password = '',
    this.type = "GUEST",
  });

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      username: json['username'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };

  @override
  String toString() {
    return 'Signup { username: $username, password: $password }';
  }
}
