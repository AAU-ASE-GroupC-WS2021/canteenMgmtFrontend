import 'package:canteen_mgmt_frontend/screens/home.dart';
import 'package:canteen_mgmt_frontend/services/signin_service.dart';
import 'package:canteen_mgmt_frontend/utils/auth_token.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatefulWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignOutButtonState();
  }
}

class _SignOutButtonState extends State<SignOutButton> {
  final SignInService signupService = SignInService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (!AuthTokenUtils.isLoggedIn()) {
      return Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
        onPressed: () => {
          signupService.logout().
          then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()))),
        },
        child: Text("Log out"),
    );
  }
}
