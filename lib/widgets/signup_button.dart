import 'package:canteen_mgmt_frontend/screens/signup_screen.dart';
import 'package:canteen_mgmt_frontend/utils/auth_token.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatefulWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpButtonState();
  }
}

class _SignUpButtonState extends State<SignUpButton> {

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen())),
        },
        child: Text("Sign up")
    );
  }
}
