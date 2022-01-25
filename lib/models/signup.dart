class Signup {
  final int id;
  final String username;
  final String password;

  Signup({
    this.id = -1,
    required this.username,
    required this.password,
  });

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      id: json['id'],
      username: json['username'],
      password: json['password'],
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
