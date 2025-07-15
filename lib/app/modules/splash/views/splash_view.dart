import 'package:flutter/material.dart';
import 'widgets/background_circles.dart';
import 'widgets/animated_school_badge.dart';
import 'widgets/app_title.dart';
import 'widgets/loading_section.dart';
import 'widgets/decorative_icons.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A3C7B),
      body: Stack(
        children: const [
          BackgroundCircles(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSchoolBadge(),
                SizedBox(height: 30),
                AppTitle(),
                SizedBox(height: 50),
                LoadingSection(),
              ],
            ),
          ),
          DecorativeIcons(),
        ],
      ),
    );
  }
}