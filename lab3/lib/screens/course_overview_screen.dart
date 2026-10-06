import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/learning_cubit.dart';
import '../models/learning_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/lesson_tile.dart';

class CourseOverviewScreen extends StatefulWidget {
  const CourseOverviewScreen({super.key});
  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  late final TextEditingController _search;
  bool _description = false;
  @override
  void initState() {
    super.initState();
    _search = TextEditingController(
      text: context.read<LearningCubit>().state.query,
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    context.read<LearningCubit>().resetFilters();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<LearningCubit, LearningState>(
    builder: (context, state) {
      final course = state.data?.course;
      final cubit = context.read<LearningCubit>();
      return Scaffold(
        appBar: AppBar(title: const Text('Course Overview'), centerTitle: true),
        body: SafeArea(
          child: LoadGate(
            state: state,
            child: course == null
                ? const SizedBox.shrink()
                : ContentWidth(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        CourseHero(course: course),
                        const SizedBox(height: 20),
                        Text(
                          course.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _Meta(icon: Icons.schedule, text: course.duration),
                            _Meta(
                              icon: Icons.menu_book_outlined,
                              text: '${course.lessonCount} lessons',
                            ),
                            _Meta(icon: Icons.star, text: '${course.rating}'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: false, label: Text('Lessons')),
                            ButtonSegment(
                              value: true,
                              label: Text('Description'),
                            ),
                          ],
                          selected: {_description},
                          onSelectionChanged: (value) =>
                              setState(() => _description = value.first),
                        ),
                        const SizedBox(height: 20),
                        if (_description)
                          SectionCard(
                            child: Text(
                              course.description.trim().isEmpty
                                  ? 'No description has been provided for this course.'
                                  : course.description,
                            ),
                          )
                        else ...[
                          TextField(
                            controller: _search,
                            onChanged: cubit.search,
                            decoration: InputDecoration(
                              labelText: 'Search lessons',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: state.query.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Clear search',
                                      onPressed: () {
                                        _search.clear();
                                        cubit.search('');
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              for (final filter in LessonFilter.values)
                                ChoiceChip(
                                  label: Text(switch (filter) {
                                    LessonFilter.all => 'All',
                                    LessonFilter.available => 'Available',
                                    LessonFilter.locked => 'Locked',
                                    LessonFilter.completed => 'Completed',
                                  }),
                                  selected: state.filter == filter,
                                  onSelected: (_) => cubit.setFilter(filter),
                                ),
                              FilterChip(
                                label: const Text('Favorites'),
                                avatar: const Icon(
                                  Icons.bookmark_border,
                                  size: 18,
                                ),
                                selected: state.favoritesOnly,
                                onSelected: cubit.showFavorites,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<LessonSort>(
                            isExpanded: true,
                            key: ValueKey(state.sort),
                            initialValue: state.sort,
                            decoration: const InputDecoration(
                              labelText: 'Sort lessons',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: LessonSort.original,
                                child: Text('Course order'),
                              ),
                              DropdownMenuItem(
                                value: LessonSort.title,
                                child: Text('Title A–Z'),
                              ),
                              DropdownMenuItem(
                                value: LessonSort.shortest,
                                child: Text('Shortest first'),
                              ),
                              DropdownMenuItem(
                                value: LessonSort.longest,
                                child: Text('Longest first'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) cubit.setSort(value);
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${state.visibleLessons.length} of ${course.lessons.length} provided lessons',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (state.status == LoadStatus.empty)
                            StatusMessage(
                              title: 'No lessons found',
                              message: course.lessons.isEmpty
                                  ? 'There are no lessons in this course yet.'
                                  : 'Try another search or change your filters.',
                              icon: Icons.search_off,
                              action: 'Reset filters',
                              onAction: course.lessons.isEmpty ? null : _reset,
                            )
                          else
                            for (final lesson in state.visibleLessons)
                              LessonTile(lesson: lesson),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ),
        bottomNavigationBar:
            course == null ||
                state.status == LoadStatus.loading ||
                state.status == LoadStatus.error
            ? null
            : SafeArea(
                top: false,
                child: ContentWidth(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.price,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: !course.enrollEnabled || state.enrolled
                              ? null
                              : cubit.enroll,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(150, 52),
                          ),
                          child: Text(
                            state.enrolled ? 'Enrolled' : course.enrollLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    },
  );
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 18,
        color: icon == Icons.star ? AppColors.orange : AppColors.muted,
      ),
      const SizedBox(width: 6),
      Text(text),
    ],
  );
}

class CourseHero extends StatelessWidget {
  const CourseHero({super.key, required this.course});
  final Course course;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            course.imageUrl,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            errorBuilder: (_, error, stackTrace) => const ColoredBox(
              color: AppColors.blueTint,
              child: Center(
                child: Icon(
                  Icons.menu_book,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black12, Colors.black87],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  course.heroLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${course.videoCount} videos · ${course.classCount} classes',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
