import 'package:flutter/material.dart';

class DecorativeIcons extends StatelessWidget {
  const DecorativeIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildDecorElement(Icons.school, 24, top: 60, left: 30),
        _buildDecorElement(Icons.access_time, 20, top: 100, right: 40),
        _buildDecorElement(Icons.calendar_today, 22, bottom: 120, left: 40),
        _buildDecorElement(Icons.person, 26, bottom: 80, right: 50),
      ],
    );
  }

  Widget _buildDecorElement(IconData icon, double size,
      {double? top, double? left, double? right, double? bottom}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Transform.rotate(
        angle: -0.2,
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.1),
          size: size,
        ),
      ),
    );
  }
}
