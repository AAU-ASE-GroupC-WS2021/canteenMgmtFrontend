import '../models/user.dart';
import 'package:flutter/material.dart';

class UserListview extends StatelessWidget {
  const UserListview({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return users.isNotEmpty ?
    ListView(
      padding: const EdgeInsets.all(8),
      children: _items(),
    )
        : const Text('No users currently');
  }

  List<Widget> _items() {
    List<Widget> items = [];
    for (var user in users) {
      items.add(Card(child:ListTile(
        title: Text(user.username),
        trailing: Icon(Icons.star),)));
    }
    return items;
  }
}
