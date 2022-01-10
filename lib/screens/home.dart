import 'package:flutter/material.dart';

import 'dish_service_demo.dart';
import 'qr_demo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canteen Management")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DishDemoPage(),
                  ),
                );
              },
              child: const Text("Dish Service Demo"),
            ),
            const SizedBox(height: 20), // space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QrDemoPage()),
                );
              },
              child: const Text("QR Scanner Demo"),
            ),
          ],
        ),
      ),
    );
  }
}
