import 'package:canteen_mgmt_frontend/screens/signin_screen.dart';
import 'package:canteen_mgmt_frontend/utils/auth_token.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatefulWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignInButtonState();
  }
}

class _SignInButtonState extends State<SignInButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (AuthTokenUtils.isLoggedIn()) {
      return Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen())),
        },
        child: Text("Log in")
    );
  }
}
