import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      content: SizedBox(
        width: 200,
        child: QrImage(data: token),
      ),
    );
  }
}
