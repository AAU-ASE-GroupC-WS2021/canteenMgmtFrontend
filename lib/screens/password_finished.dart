import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/utils/auth_token.dart';
import 'package:flutter/material.dart';

import '../widgets/about_button.dart';
import 'home.dart';

class PasswordFinishedScreen extends StatelessWidget {
  const PasswordFinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!AuthTokenUtils.isLoggedIn()) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You are not logged in!",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20), // space between buttons
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen())),
                child: const Text('Go to the Homepage'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update password'),
        actions: const [AboutButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Password updated successfully.",
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20), // space between buttons
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen())),
              child: const Text('Go to the Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
