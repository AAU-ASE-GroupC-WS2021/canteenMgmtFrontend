import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);

  final bool loggedIn = false;

  @override
  Widget build(BuildContext context) {

    if (loggedIn) {
      return Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
        onPressed: () => { context.beamToNamed('/signin') },
        child: Text("Log in")
    );
  }
}
