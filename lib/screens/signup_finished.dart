import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../utils/auth_token.dart';
import '../widgets/about_button.dart';

class SignupFinishedScreen extends StatelessWidget {
  const SignupFinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AuthTokenUtils.isLoggedIn()) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You are already logged in!",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20), // space between buttons
              ElevatedButton(
                onPressed: () => context.beamToNamed('/'),
                child: const Text('Go to the Homepage'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new profile'),
        actions: const [AboutButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Profile created successfully.",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20), // space between buttons
            ElevatedButton(
              onPressed: () => context.beamToNamed('/'),
              child: const Text('Go to the Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
