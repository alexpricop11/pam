import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/learning_cubit.dart';
import '../models/learning_data.dart';
import '../screens/lesson_detail_screen.dart';
import '../theme/app_theme.dart';
import 'common.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    final completed = context.select(
      (LearningCubit cubit) => cubit.state.isCompleted(lesson),
    );
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Icon(
          lesson.locked
              ? Icons.lock_outline
              : completed
              ? Icons.check_circle_outline
              : Icons.play_circle_outline,
          color: lesson.locked ? AppColors.muted : AppColors.orange,
          size: 36,
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${lesson.duration} · ${lesson.locked
              ? 'Locked'
              : completed
              ? 'Completed'
              : 'Available'}',
        ),
        trailing: FavoriteButton(id: lesson.id),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LessonDetailScreen(lesson: lesson),
          ),
        ),
      ),
    );
  }
}
