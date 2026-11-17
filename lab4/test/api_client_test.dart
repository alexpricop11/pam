import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab4/core/network/api_client.dart';
import 'package:lab4/data/datasources/learning_remote_data_source.dart';
import 'package:lab4/data/models/learning_models.dart';
import 'package:lab4/data/repositories/learning_repository_impl.dart';
import 'package:lab4/domain/failures/learning_failure.dart';

import 'learning_cubit_test.dart' show fixture;

void main() {
  final json = jsonDecode(fixture()) as Map<String, dynamic>;
  test('requests both v4 resources using GET and maps their JSON', () async {
    final paths = <String>[];
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.host, 'test-api-jlbn.onrender.com');
      expect(request.headers['Accept'], 'application/json');
      paths.add(request.url.path);
      return http.Response(
        jsonEncode(
          request.url.path.endsWith('/details')
              ? json['courseOverviewPage']
              : json['homePage'],
        ),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    addTearDown(client.close);
    final data = await LearningRepositoryImpl(
      LearningRemoteDataSource(ApiClient(client)),
    ).load();
    expect(paths.toSet(), {'/lab2026/v4/feed', '/lab2026/v4/feed/details'});
    expect(data.home.greeting, 'Hi, Kristin');
    expect(data.course.lessons.first.title, 'Introduction to React');
  });
  test('models serialize and deserialize both endpoint payloads', () {
    final home = HomeDataModel.fromJson(json['homePage']);
    final course = CourseModel.fromJson(json['courseOverviewPage']);
    expect(jsonDecode(jsonEncode(home.toJson())), json['homePage']);
    expect(jsonDecode(jsonEncode(course.toJson())), json['courseOverviewPage']);
    expect(HomeDataModel.fromJson(home.toJson()).toEntity().learnedMinutes, 46);
    expect(CourseModel.fromJson(course.toJson()).toEntity().lessons.length, 4);
    final copy = course.toJson();
    copy['course']['title'] = 'Changed';
    expect(course.toJson()['course']['title'], 'React Front To back');
  });
  for (final status in [404, 500, 503]) {
    test('HTTP $status becomes a readable failure', () async {
      final client = MockClient((_) async => http.Response('error', status));
      addTearDown(client.close);
      expect(
        ApiClient(client).get('feed'),
        throwsA(
          isA<LearningFailure>().having(
            (e) => e.message,
            'message',
            contains('$status'),
          ),
        ),
      );
    });
  }
  for (final body in ['not JSON', '[]', 'null']) {
    test('invalid response $body is rejected', () async {
      final client = MockClient((_) async => http.Response(body, 200));
      addTearDown(client.close);
      expect(ApiClient(client).get('feed'), throwsA(isA<LearningFailure>()));
    });
  }
  test('network errors become a readable failure', () async {
    final client = MockClient(
      (_) async => throw http.ClientException('offline'),
    );
    addTearDown(client.close);
    expect(
      ApiClient(client).get('feed'),
      throwsA(
        isA<LearningFailure>().having(
          (e) => e.message,
          'message',
          contains('internet'),
        ),
      ),
    );
  });
  test('timeout becomes a readable failure', () async {
    final response = Completer<http.Response>();
    final client = MockClient((_) => response.future);
    addTearDown(client.close);
    await expectLater(
      ApiClient(client, timeout: const Duration(milliseconds: 10)).get('feed'),
      throwsA(
        isA<LearningFailure>().having(
          (e) => e.message,
          'message',
          contains('too long'),
        ),
      ),
    );
    response.complete(http.Response('{}', 200));
  });
  test('failure on either endpoint does not publish partial data', () async {
    final client = MockClient(
      (request) async => request.url.path.endsWith('/details')
          ? http.Response('unavailable', 503)
          : http.Response(
              jsonEncode(json['homePage']),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            ),
    );
    addTearDown(client.close);
    expect(
      LearningRepositoryImpl(LearningRemoteDataSource(ApiClient(client)))
          .load(),
      throwsA(
        isA<LearningFailure>().having(
          (e) => e.message,
          'message',
          contains('503'),
        ),
      ),
    );
  });
}
