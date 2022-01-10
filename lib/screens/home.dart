import 'package:flutter/material.dart';

import 'dish_service_demo.dart';
import 'qr_demo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canteen Management")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(DishDemoScreen.route),
              child: const Text("Dish Service Demo"),
            ),
            const SizedBox(height: 20), // space between buttons
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(QrDemoScreen.route),
              child: const Text("QR Scanner Demo"),
            ),
          ],
        ),
      ),
    );
  }
}
