import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../widgets/qr_scanner.dart';

class OrderQrScanScreen extends StatelessWidget {
  const OrderQrScanScreen({Key? key}) : super(key: key);

  static final orderCodePattern = RegExp(r'canteen-mgmt-order:(\d+)$');

  @override
  Widget build(BuildContext context) => QrScanner(
        ignoreEmpty: true,
        onScan: (context, scanData) {
          if (scanData == null) return;

          log(scanData);

          final match = orderCodePattern.matchAsPrefix(scanData);
          if (match == null) return;

          final orderId = match.group(1)!;
          context.beamToNamed('/order/$orderId');
        },
      );
}
