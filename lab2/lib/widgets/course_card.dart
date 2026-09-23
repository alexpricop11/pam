import 'package:flutter/material.dart';
import '../models/course.dart';
import '../theme/app_theme.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2,
    shadowColor: Colors.black12,
    margin: const EdgeInsets.only(bottom: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Container(width: 64, height: 64, decoration: BoxDecoration(color: Color(course.color), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.play_lesson_rounded, color: AppColors.primary)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(course.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.person_outline, size: 13, color: AppColors.muted), const SizedBox(width: 3), Expanded(child: Text(course.teacher, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.muted)))]),
          const SizedBox(height: 5),
          Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [Text('\$${course.price}', style: const TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.w700)), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFFECE9), borderRadius: BorderRadius.circular(6)), child: Text('${course.durationHours} hours', style: const TextStyle(fontSize: 10, color: Color(0xFFFF6D5E))))]),
        ])),
      ]),
    ),
  );
}
