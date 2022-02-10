import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../services/util/order_qr_code.dart';
import '../../widgets/orders/qr_scanner.dart';

class OrderQrScanScreen extends StatelessWidget {
  const OrderQrScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => QrScanner(
        ignoreEmpty: true,
        onScan: (context, String? scanData) {
          if (scanData == null) return;
          final orderId = OrderQrCode.decode(scanData);
          if (orderId == null) return;

          context.beamToNamed('/order/$orderId');
        },
      );
}
