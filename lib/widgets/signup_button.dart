import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../utils/auth_token.dart';

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
      return const Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
      onPressed: () => context.beamToNamed('/signup'),
      child: const Text("Sign up"),
    );
  }
}
