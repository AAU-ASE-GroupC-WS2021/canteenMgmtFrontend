import '../screens/signup_screen.dart';
import '../services/signup_service.dart';
import '../utils/auth_token.dart';
import 'package:flutter/material.dart';

class UserInfoButton extends StatefulWidget {
  const UserInfoButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserInfoButtonState();
  }
}

class _UserInfoButtonState extends State<UserInfoButton> {

  late String _username = "";
  late String _type = "";

  @override
  void initState() {
    super.initState();

    if (!AuthTokenUtils.isLoggedIn()) {
      return;
    }

    SignupService().getUserSelfInfo().then((value) => {
      super.setState(() {
        _username = value.username;
        _type = value.type;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {

    if (!AuthTokenUtils.isLoggedIn()) {
      return const Offstage(
        offstage: true,
      );
    }

    // TODO later: make the button dropdown or popup for more functions.
    return ElevatedButton(
        onPressed: () => {
          // Do some action: either show a popup or dropdown, or go to the user profile page.
        },
        child: Text(_username + ' (' + _type + ')'),
    );
  }
}
