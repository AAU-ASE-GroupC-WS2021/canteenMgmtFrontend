part of 'scanner.dart';

class _QrScannerFacingButton extends StatelessWidget {
  const _QrScannerFacingButton({
    Key? key,
    this.controller,
  }) : super(key: key);

  final QRViewController? controller;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.flip_camera_ios),
        onPressed: controller?.flipCamera,
      );
}
