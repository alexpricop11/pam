import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.title, required this.color, required this.icon});
  final String title;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.55,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Stack(children: [
        Positioned(right: 0, top: 0, child: Icon(icon, size: 54, color: AppColors.primary)),
        Align(alignment: Alignment.bottomLeft, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)), child: Text(title, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)))),
      ]),
    ),
  );
}
