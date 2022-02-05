import 'edit_user_button.dart';

import '../models/user.dart';
import 'package:flutter/material.dart';

class UserListview extends StatefulWidget {
  const UserListview({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  State<UserListview> createState() => _UserListviewState();
}


class _UserListviewState extends State<UserListview> {

  @override
  Widget build(BuildContext context) {
    return widget.users.isNotEmpty ?
    ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: Card(
            child:ListTile(
              title: Text(widget.users[index].username),
              subtitle: Text(widget.users[index].type.name),
              trailing: EditUserButton(widget.users[index]),
            ),
          ),
        );
      },)
        : const Center(child: Text('No users currently'),);
  }


}
