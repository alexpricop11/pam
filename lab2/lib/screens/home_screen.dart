import 'package:flutter/material.dart';

import 'courses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleTap(BuildContext context, TapUpDetails details, Size size) {
    final point = details.localPosition;
    final isMyCoursesTap = point.dx > size.width * .62 &&
        point.dy > size.height * .15 &&
        point.dy < size.height * .31;

    if (isMyCoursesTap) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CoursesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) => _handleTap(context, details, constraints.biggest),
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/home-figma.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    ),
  );
}