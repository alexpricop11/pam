import '../entities/learning_data.dart';

abstract interface class LearningRepository {
  Future<LearningData> load();
}
