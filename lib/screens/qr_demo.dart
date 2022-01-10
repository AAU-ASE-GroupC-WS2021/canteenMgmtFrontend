import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class QrDemoScreen extends StatelessWidget {
  const QrDemoScreen({Key? key, this.scanValue}) : super(key: key);

  final String? scanValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () => context.beamToNamed(
                '/qr-scan',
                beamBackOnPop: true,
              ),
            ),
            if (scanValue != null) ...[
              const SizedBox(height: 20),
              const Text('Scanned Result:'),
              Text(
                scanValue!,
                style: const TextStyle(fontSize: 24, fontFamily: 'monospace'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
