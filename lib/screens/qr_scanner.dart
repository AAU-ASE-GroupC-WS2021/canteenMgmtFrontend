import 'package:flutter/material.dart';

import '../widgets/qr_scanner.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  static const route = 'qr';

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: QrScanner(
          ignoreEmpty: true,
          popScreenOnScanResult: true,
        ),
      );
}
