import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lab4/core/network/api_client.dart';
import 'package:lab4/data/datasources/learning_remote_data_source.dart';
import 'package:lab4/data/repositories/learning_repository_impl.dart';

Future<void> main() async {
  final client = http.Client();
  try {
    final data = await LearningRepositoryImpl(
      LearningRemoteDataSource(ApiClient(client)),
    ).load();
    if (data.home.greeting.isEmpty || data.course.lessons.isEmpty) {
      throw StateError('Live API returned no learning content');
    }
    stdout.writeln(
      'Live API OK: ${data.home.greeting}; ${data.course.title}; ${data.course.lessons.length} lessons',
    );
  } finally {
    client.close();
  }
}
