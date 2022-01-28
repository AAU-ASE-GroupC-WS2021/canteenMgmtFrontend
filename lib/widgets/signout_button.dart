import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  final bool loggedIn = true;

  @override
  Widget build(BuildContext context) {
    
    if (!loggedIn) {
      return Offstage(
        offstage: true,
      );
    }

    return ElevatedButton(
        onPressed: () => { context.beamToNamed('/signout') },
        child: Text("Log out")
    );
  }
}
