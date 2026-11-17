import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab4/core/network/api_client.dart';
import 'package:lab4/data/datasources/learning_remote_data_source.dart';
import 'package:lab4/data/models/learning_models.dart';
import 'package:lab4/data/repositories/learning_repository_impl.dart';
import 'package:lab4/domain/entities/learning_data.dart';
import 'package:lab4/domain/repositories/learning_repository.dart';
import 'package:lab4/domain/usecases/get_learning_data.dart';
import 'package:lab4/presentation/cubit/learning_cubit.dart';

String fixture() => File('test/fixtures/learning.json').readAsStringSync();
LearningData fixtureData() {
  final json = jsonDecode(fixture()) as Map<String, dynamic>;
  return LearningData(
    home: HomeDataModel.fromJson(json['homePage']).toEntity(),
    course: CourseModel.fromJson(json['courseOverviewPage']).toEntity(),
  );
}

LearningCubit createCubit(LearningRepository repository) =>
    LearningCubit(GetLearningData(repository));
LearningRepository repositoryFor(String source) {
  final client = MockClient((request) async {
    try {
      final decoded = jsonDecode(source);
      final body = decoded is Map<String, dynamic>
          ? decoded[request.url.path.endsWith('/details')
                    ? 'courseOverviewPage'
                    : 'homePage'] ??
                decoded
          : decoded;
      return http.Response(
        jsonEncode(body),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    } on FormatException {
      return http.Response(source, 200);
    }
  });
  addTearDown(client.close);
  return LearningRepositoryImpl(LearningRemoteDataSource(ApiClient(client)));
}

class ControlledRepository implements LearningRepository {
  final requests = <Completer<LearningData>>[];
  @override
  Future<LearningData> load() {
    final request = Completer<LearningData>();
    requests.add(request);
    return request.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LearningCubit cubit;
  setUp(() => cubit = createCubit(repositoryFor(fixture())));
  tearDown(() => cubit.close());

  test(
    'loads variant 4 HTTP responses and typed lessons asynchronously',
    () async {
      expect(cubit.state.status, LoadStatus.loading);
      await cubit.load();
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.data!.home.learnedMinutes, 46);
      expect(cubit.state.data!.course.lessonCount, 7);
      expect(cubit.state.visibleLessons.length, 4);
    },
  );
  test(
    'search is trimmed and case insensitive; empty resets to success',
    () async {
      await cubit.load();
      cubit.search('  INTRODUCTION ');
      expect(cubit.state.visibleLessons.single.id, 'lesson-1');
      cubit.search('no matches');
      expect(cubit.state.status, LoadStatus.empty);
      cubit.resetFilters();
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.visibleLessons.length, 4);
    },
  );
  test('filter and favorites combine, removal updates empty state', () async {
    await cubit.load();
    cubit.toggleFavorite('lesson-4');
    cubit.setFilter(LessonFilter.available);
    cubit.showFavorites(true);
    expect(cubit.state.status, LoadStatus.empty);
    cubit.setFilter(LessonFilter.locked);
    expect(cubit.state.visibleLessons.single.id, 'lesson-4');
    cubit.toggleFavorite('lesson-4');
    expect(cubit.state.status, LoadStatus.empty);
  });
  test('sort uses numeric duration and preserves source order', () async {
    await cubit.load();
    cubit.setSort(LessonSort.longest);
    expect(cubit.state.visibleLessons.first.id, 'lesson-3');
    cubit.setSort(LessonSort.shortest);
    expect(cubit.state.visibleLessons.first.id, 'lesson-1');
    cubit.setSort(LessonSort.title);
    expect(cubit.state.visibleLessons.first.title, 'Build React');
    cubit.setSort(LessonSort.original);
    expect(cubit.state.visibleLessons.map((l) => l.id), [
      'lesson-1',
      'lesson-2',
      'lesson-3',
      'lesson-4',
    ]);
  });
  test(
    'completed filter updates; locked lessons cannot be completed',
    () async {
      await cubit.load();
      final lessons = cubit.state.data!.course.lessons;
      cubit.completeLesson(lessons.last);
      expect(cubit.state.completed, isEmpty);
      cubit.completeLesson(lessons.first);
      cubit.setFilter(LessonFilter.completed);
      expect(cubit.state.visibleLessons.single.id, 'lesson-1');
      cubit.enroll();
      expect(cubit.state.enrolled, isTrue);
    },
  );
  test('malformed JSON and schema produce recoverable error state', () async {
    for (final input in ['bad json', '{}', '[]']) {
      final invalid = createCubit(repositoryFor(input));
      await invalid.load();
      expect(invalid.state.status, LoadStatus.error);
      expect(invalid.state.error, isNotEmpty);
      await invalid.close();
    }
  });
  test('empty JSON lesson list is an Empty state', () async {
    final json = jsonDecode(fixture()) as Map<String, dynamic>;
    json['courseOverviewPage']['course']['lessons'] = [];
    final empty = createCubit(repositoryFor(jsonEncode(json)));
    await empty.load();
    expect(empty.state.status, LoadStatus.empty);
    await empty.close();
  });
  test('retry recovers after read failure', () async {
    final repository = ControlledRepository();
    final retry = createCubit(repository);
    final first = retry.load();
    repository.requests.first.completeError(StateError('read failed'));
    await first;
    expect(retry.state.status, LoadStatus.error);
    final second = retry.load();
    expect(retry.state.status, LoadStatus.loading);
    repository.requests.last.complete(fixtureData());
    await second;
    expect(retry.state.status, LoadStatus.success);
    await retry.close();
  });
  test(
    'stale request cannot overwrite newer result and close is safe',
    () async {
      final repository = ControlledRepository();
      final concurrent = createCubit(repository);
      final first = concurrent.load();
      final second = concurrent.load();
      repository.requests.last.complete(fixtureData());
      await second;
      repository.requests.first.completeError(StateError('old error'));
      await first;
      expect(concurrent.state.status, LoadStatus.success);
      final pending = concurrent.load();
      await concurrent.close();
      repository.requests.last.completeError(StateError('closed'));
      await pending;
    },
  );
}
