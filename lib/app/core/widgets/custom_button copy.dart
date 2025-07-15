import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width; // Lebar tombol
  final double height; // Tinggi tombol
  final String text; // Teks pada tombol
  final Color color; // Warna tombol
  final Color textColor; // Warna teks
  final double fontSize; // Ukuran font
  final FontWeight fontWeight; // Ketebalan teks
  final VoidCallback onPressed; // Fungsi ketika tombol ditekan

  const CustomButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    this.color = const Color(0xff433878), // Default warna tombol
    this.textColor = Colors.white, // Default warna teks
    this.fontSize = 16.0, // Default ukuran teks
    this.fontWeight = FontWeight.bold, // Default ketebalan teks
    required this.onPressed, // Navigasi atau aksi yang dilakukan
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Fungsi yang dijalankan ketika tombol ditekan
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12), // Sudut membulat
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
