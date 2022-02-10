import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';

import '../widgets/about_button.dart';

class PasswordFinishedScreen extends StatelessWidget {
  const PasswordFinishedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => context.popToNamed("/profile"),
              child: const Text('Go to the Homepage'),
            ),
          ],
        ),
      ),
    );
  }
}
