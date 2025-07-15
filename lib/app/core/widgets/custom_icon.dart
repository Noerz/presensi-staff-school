import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String? assetIconPath; // Path untuk ikon dari asset
  final IconData? flutterIcon; // Ikon bawaan Flutter
  final double size;
  final String label;
  final bool isLabelAbove; // Label di atas atau di bawah ikon
  final VoidCallback? onPressed;

  const CustomIconButton({
    Key? key,
    this.assetIconPath,
    this.flutterIcon,
    required this.size,
    required this.label,
    this.isLabelAbove = false,
    this.onPressed,
  })  : assert(assetIconPath != null || flutterIcon != null,
            "Either 'assetIconPath' or 'flutterIcon' must be provided"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: isLabelAbove
            ? [
                Text(
                  label,
                  style: TextStyle(fontSize: size * 0.3), // Ukuran teks sesuai ikon
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size * 0.1),
                _buildIcon(),
              ]
            : [
                _buildIcon(),
                SizedBox(height: size * 0.1),
                Text(
                  label,
                  style: TextStyle(fontSize: size * 0.3), // Ukuran teks sesuai ikon
                  textAlign: TextAlign.center,
                ),
              ],
      ),
    );
  }

  Widget _buildIcon() {
    if (assetIconPath != null) {
      return Image.asset(
        assetIconPath!,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else if (flutterIcon != null) {
      return Icon(
        flutterIcon,
        size: size,
      );
    }
    return const SizedBox.shrink();
  }
}
