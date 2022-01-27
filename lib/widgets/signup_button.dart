import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => { context.beamToNamed('/signup') },
        child: Text("Sign up")
    );
  }
}
