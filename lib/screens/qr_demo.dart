import 'package:canteen_mgmt_frontend/widgets/qr_scanner.dart';
import 'package:flutter/material.dart';

class QrDemoScreen extends StatelessWidget {
  const QrDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QrScanner(),
    );
  }
}
