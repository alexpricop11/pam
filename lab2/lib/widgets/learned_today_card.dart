import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LearnedTodayCard extends StatelessWidget {
  const LearnedTodayCard({super.key, required this.onCourses});
  final VoidCallback onCourses;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 5,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Learned today', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const Spacer(),
          TextButton(onPressed: onCourses, child: const Text('My courses')),
        ]),
        const Text('46min', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        const Text('/ 60min', style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: AppSpace.sm),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: const LinearProgressIndicator(value: 46 / 60, minHeight: 6, color: AppColors.orange, backgroundColor: Color(0xFFF0F0F5))),
      ]),
    ),
  );
}
