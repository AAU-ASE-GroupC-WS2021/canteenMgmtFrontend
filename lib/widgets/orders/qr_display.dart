import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplay extends StatelessWidget {
  const QrCodeDisplay({Key? key, required this.data, this.size})
      : super(key: key);

  final double? size;
  final String data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: QrImage(data: data),
    );
  }
}
