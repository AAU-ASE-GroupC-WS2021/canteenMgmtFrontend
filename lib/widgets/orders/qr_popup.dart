import 'package:flutter/material.dart';

import 'qr_display.dart';

class QrPopup extends StatelessWidget {
  const QrPopup({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Some Order'),
      content: QrCodeDisplay(
        data: token,
        size: 200,
      ),
    );
  }
}
