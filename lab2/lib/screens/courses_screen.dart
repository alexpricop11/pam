import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SizedBox.expand(
      child: Image.asset(
        'assets/images/courses-figma.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    ),
  );
}