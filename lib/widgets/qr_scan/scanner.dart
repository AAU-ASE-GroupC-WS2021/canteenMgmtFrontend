import 'dart:developer';
import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

part 'flash_button.dart';
part 'flip_camera_button.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({
    Key? key,
    this.qrKey,
    this.onScan,
    this.ignoreEmpty = true,
    this.popOnScanResult = false,
  }) : super(key: key);

  final Key? qrKey;
  final Function(BuildContext, String?)? onScan;
  final bool ignoreEmpty;
  final bool popOnScanResult;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? result;
  QRViewController? controller;
  late Key qrKey;

  @override
  void initState() {
    super.initState();
    qrKey = widget.qrKey ?? GlobalKey(debugLabel: 'QR');
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: kIsWeb ? const [] : [
          _QrScannerFlashButton(controller: controller),
          _QrScannerFacingButton(controller: controller),
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    Stream<Barcode> stream = controller.scannedDataStream;
    if (widget.ignoreEmpty) {
      stream = stream.where((item) => item.code != null && item.code != '');
    }

    stream.listen((scanData) {
      if (widget.onScan != null) {
        widget.onScan!(context, scanData.code);
      }

      if (widget.popOnScanResult) {
        context.beamBack(data: scanData.code);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
