import 'package:beamer/beamer.dart';
import 'package:canteen_mgmt_frontend/widgets/about_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Management'),
        actions: const [AboutButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.beamToNamed('/dish'),
              child: const Text('Dish Service Demo'),
            ),
            const SizedBox(height: 20), // space between buttons
            ElevatedButton(
              onPressed: () => context.beamToNamed('/qr-demo'),
              child: const Text('QR Scanner Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
