class Avatar {
  final String username;
  final String avatar;

  Avatar({
    required this.username,
    required this.avatar,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      username: json['username'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'avatar': avatar,
  };

  @override
  String toString() {
    return 'Avatar { username: $username, avatar: $avatar }';
  }
}
