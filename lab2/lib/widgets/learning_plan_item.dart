import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LearningPlanItem extends StatelessWidget {
  const LearningPlanItem({super.key, required this.title, required this.completed, required this.total});
  final String title;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(value: completed / total, strokeWidth: 3, color: AppColors.primary, backgroundColor: const Color(0xFFE7E7EF))),
      const SizedBox(width: 12),
      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
      Text('$completed/$total', style: const TextStyle(color: AppColors.muted)),
    ]),
  );
}
