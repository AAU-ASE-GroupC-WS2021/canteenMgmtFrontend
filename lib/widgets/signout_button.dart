import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../services/signin_service.dart';
import '../utils/auth_token.dart';

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
      return const Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
      onPressed: () async {
        await signupService.logout();
        context.beamToNamed('/');
      },
      child: const Text("Log out"),
    );
  }
}
