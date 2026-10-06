import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/learning_data.dart';

class LearningRepository {
  LearningRepository({
    AssetBundle? bundle,
    this.assetPath = 'assets/data/lab_v4.json',
  }) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  final String assetPath;
  Future<LearningData> load() async {
    final source = await _bundle.loadString(assetPath);
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object');
    }
    return LearningData.fromJson(decoded);
  }
}
