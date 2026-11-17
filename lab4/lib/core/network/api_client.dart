import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/failures/learning_failure.dart';

class ApiClient {
  ApiClient(this.client, {this.timeout = const Duration(seconds: 60)});
  static final baseUri = Uri.parse(
    'https://test-api-jlbn.onrender.com/lab2026/v4/',
  );
  final http.Client client;
  final Duration timeout;

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await client
          .get(baseUri.resolve(path), headers: {'Accept': 'application/json'})
          .timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw LearningFailure(
          'Server returned HTTP ${response.statusCode}. Please try again.',
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return decoded;
    } on TimeoutException {
      throw const LearningFailure(
        'The server took too long to respond. Please try again.',
      );
    } on http.ClientException {
      throw const LearningFailure(
        'Cannot connect to the server. Check your internet connection and try again.',
      );
    } on FormatException {
      throw const LearningFailure(
        'The server returned invalid JSON. Please try again.',
      );
    }
  }
}
