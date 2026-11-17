import '../entities/learning_data.dart';
import '../repositories/learning_repository.dart';

class GetLearningData {
  const GetLearningData(this.repository);
  final LearningRepository repository;
  Future<LearningData> call() => repository.load();
}
