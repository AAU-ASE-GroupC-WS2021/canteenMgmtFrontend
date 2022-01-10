import 'package:flutter/material.dart';

import '../widgets/qr_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: QrScanner(
          ignoreEmpty: true,
          popOnScanResult: true,
        ),
      );
}
