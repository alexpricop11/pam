import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/learning_cubit.dart';
import '../models/learning_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lesson});
  final Lesson lesson;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Lesson details'),
      actions: [FavoriteButton(id: lesson.id)],
    ),
    body: SafeArea(
      child: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SectionCard(
              color: AppColors.blueTint,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Icon(
                  lesson.locked
                      ? Icons.lock_outline
                      : Icons.play_lesson_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              lesson.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text('Duration: ${lesson.duration}'),
            const SizedBox(height: 24),
            Text(
              lesson.locked ? 'This lesson is locked in the course material.' : 'Video content is not included in this course material. You can track your learning progress below.',
            ),
            const SizedBox(height: 24),
            BlocBuilder<LearningCubit, LearningState>(
              builder: (context, state) => FilledButton.icon(
                onPressed: lesson.locked || state.isCompleted(lesson)
                    ? null
                    : () =>
                          context.read<LearningCubit>().completeLesson(lesson),
                icon: Icon(
                  state.isCompleted(lesson) ? Icons.check_circle : Icons.check,
                ),
                label: Text(
                  state.isCompleted(lesson) ? 'Completed' : 'Mark as completed',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
