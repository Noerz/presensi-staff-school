import 'package:flutter/material.dart';

class BackgroundCircles extends StatelessWidget {
  const BackgroundCircles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5F4B8B).withOpacity(0.2),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5F4B8B).withOpacity(0.15),
            ),
          ),
        ),
      ],
    );
  }
}
