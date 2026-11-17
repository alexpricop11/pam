import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/learning_cubit.dart';
import '../widgets/common.dart';
import '../theme/app_theme.dart';
import 'course_overview_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void _openCourse(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const CourseOverviewScreen()));
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: BlocBuilder<LearningCubit, LearningState>(
        builder: (context, state) {
          final home = state.data?.home;
          final course = state.data?.course;
          return LoadGate(
            state: state,
            child: home == null || course == null
                ? const SizedBox.shrink()
                : ContentWidth(
                    child: RefreshIndicator(
                      onRefresh: context.read<LearningCubit>().load,
                      child: ListView(
                        padding: const EdgeInsets.all(24),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        home.greeting,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        home.subtitle,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const CircleAvatar(
                                  backgroundColor: Colors.white24,
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Learned today'),
                                    ),
                                    TextButton(
                                      onPressed: () => _openCourse(context),
                                      child: const Text('My courses'),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${home.learnedMinutes}min / ${home.goalMinutes}min',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: home.progress,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.orange,
                                ),
                              ],
                            ),
                          ),
                          SectionCard(
                            color: AppColors.blueTint,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.school_outlined,
                                  color: AppColors.primary,
                                  size: 44,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  home.prompt,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: () => _openCourse(context),
                                  child: Text(home.promptAction),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Learning Plan',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SectionCard(
                            child: Column(
                              children: [
                                for (final plan in home.plans)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator(
                                            value: plan.progress,
                                            strokeWidth: 3,
                                            backgroundColor: AppColors.lavender,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(child: Text(plan.title)),
                                        Text('${plan.completed}/${plan.total}'),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SectionCard(
                            color: AppColors.lavender,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        home.meetupTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(home.meetupSubtitle),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.groups_outlined,
                                  size: 52,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Continue learning',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const Icon(
                                Icons.play_lesson_outlined,
                                color: AppColors.primary,
                              ),
                              title: Text(course.title),
                              subtitle: Text(
                                '${course.duration} · ${course.rating} ★',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _openCourse(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    ),
  );
}
