class PasswordChange {
  final String username;
  final String passwordOld;
  final String passwordNew;

  PasswordChange({
    required this.username,
    required this.passwordOld,
    required this.passwordNew,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'passwordOld': passwordOld,
        'passwordNew': passwordNew,
      };

  @override
  String toString() {
    return 'PasswordChange { username: $username, passwordOld: $passwordOld, passwordNew: $passwordNew }';
  }
}
