import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../utils/auth_token.dart';

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
      return const Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
      onPressed: () => context.beamToNamed('/signin'),
      child: const Text("Log in"),
    );
  }
}
