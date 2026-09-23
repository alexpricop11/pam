import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LearningBanner extends StatelessWidget {
  const LearningBanner({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.all(AppSpace.md),
    decoration: BoxDecoration(color: AppColors.blueTint, borderRadius: BorderRadius.circular(16)),
    child: Stack(children: [
      const Positioned(right: 0, bottom: 0, child: Icon(Icons.school_rounded, size: 90, color: AppColors.primary)),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('What do you want\nto learn today?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const Spacer(),
        FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: AppColors.orange, minimumSize: const Size(92, 42)), child: const Text('Get Started')),
      ]),
    ]),
  );
}
