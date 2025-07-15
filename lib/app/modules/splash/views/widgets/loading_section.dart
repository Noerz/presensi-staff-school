import 'package:flutter/material.dart';
import 'custom_progress_indicator.dart';

class LoadingSection extends StatelessWidget {
  const LoadingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomProgressIndicator(),
        const SizedBox(height: 15),
        const Text(
          'Initializing Application',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'For School Staff',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
