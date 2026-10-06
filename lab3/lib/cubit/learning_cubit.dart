import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/learning_data.dart';
import '../repositories/learning_repository.dart';

enum LoadStatus { loading, success, empty, error }

enum LessonFilter { all, available, locked, completed }

enum LessonSort { original, title, shortest, longest }

class LearningState {
  LearningState({
    this.status = LoadStatus.loading,
    this.data,
    this.query = '',
    this.filter = LessonFilter.all,
    this.sort = LessonSort.original,
    this.favoritesOnly = false,
    Set<String> favorites = const {},
    Set<String> completed = const {},
    this.enrolled = false,
    this.error,
  }) : favorites = Set.unmodifiable(favorites),
       completed = Set.unmodifiable(completed);
  final LoadStatus status;
  final LearningData? data;
  final String query;
  final LessonFilter filter;
  final LessonSort sort;
  final bool favoritesOnly, enrolled;
  final Set<String> favorites, completed;
  final String? error;
  bool isCompleted(Lesson lesson) =>
      lesson.completed || completed.contains(lesson.id);
  List<Lesson> get visibleLessons {
    final result = (data?.course.lessons ?? <Lesson>[]).where((lesson) {
      final matchesFilter = switch (filter) {
        LessonFilter.all => true,
        LessonFilter.available => !lesson.locked,
        LessonFilter.locked => lesson.locked,
        LessonFilter.completed => isCompleted(lesson),
      };
      return matchesFilter &&
          lesson.title.toLowerCase().contains(query.trim().toLowerCase()) &&
          (!favoritesOnly || favorites.contains(lesson.id));
    }).toList();
    switch (sort) {
      case LessonSort.original:
        break;
      case LessonSort.title:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case LessonSort.shortest:
        result.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
      case LessonSort.longest:
        result.sort((a, b) => b.durationSeconds.compareTo(a.durationSeconds));
    }
    return List.unmodifiable(result);
  }

  LearningState copyWith({
    LoadStatus? status,
    LearningData? data,
    String? query,
    LessonFilter? filter,
    LessonSort? sort,
    bool? favoritesOnly,
    Set<String>? favorites,
    Set<String>? completed,
    bool? enrolled,
    String? error,
  }) => LearningState(
    status: status ?? this.status,
    data: data ?? this.data,
    query: query ?? this.query,
    filter: filter ?? this.filter,
    sort: sort ?? this.sort,
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    favorites: favorites ?? this.favorites,
    completed: completed ?? this.completed,
    enrolled: enrolled ?? this.enrolled,
    error: error,
  );
}

class LearningCubit extends Cubit<LearningState> {
  LearningCubit(this.repository) : super(LearningState());
  final LearningRepository repository;
  int _request = 0;
  Future<void> load() async {
    final request = ++_request;
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final data = await repository.load();
      if (isClosed || request != _request) return;
      _publish(state.copyWith(data: data, status: LoadStatus.success));
    } catch (_) {
      if (isClosed || request != _request) return;
      emit(
        state.copyWith(
          status: LoadStatus.error,
          error: 'Unable to load the learning data. Please try again.',
        ),
      );
    }
  }

  void _publish(LearningState next) => emit(
    next.copyWith(
      status: next.visibleLessons.isEmpty
          ? LoadStatus.empty
          : LoadStatus.success,
    ),
  );
  void search(String query) => _publish(state.copyWith(query: query));
  void setFilter(LessonFilter filter) =>
      _publish(state.copyWith(filter: filter));
  void setSort(LessonSort sort) => _publish(state.copyWith(sort: sort));
  void showFavorites(bool value) =>
      _publish(state.copyWith(favoritesOnly: value));
  void resetFilters() => _publish(
    state.copyWith(
      query: '',
      filter: LessonFilter.all,
      sort: LessonSort.original,
      favoritesOnly: false,
    ),
  );
  void toggleFavorite(String id) {
    if (!(state.data?.course.lessons.any((l) => l.id == id) ?? false)) return;
    final favorites = {...state.favorites};
    if (!favorites.add(id)) favorites.remove(id);
    _publish(state.copyWith(favorites: favorites));
  }

  void completeLesson(Lesson lesson) {
    if (lesson.locked) return;
    _publish(state.copyWith(completed: {...state.completed, lesson.id}));
  }

  void enroll() {
    if (state.data?.course.enrollEnabled ?? false) {
      _publish(state.copyWith(enrolled: true));
    }
  }
}
