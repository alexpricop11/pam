import '../../domain/entities/learning_data.dart';
import '../../domain/failures/learning_failure.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/learning_remote_data_source.dart';
import '../models/learning_models.dart';

class LearningRepositoryImpl implements LearningRepository {
  const LearningRepositoryImpl(this.remote);
  final LearningRemoteDataSource remote;

  @override
  Future<LearningData> load() async {
    try {
      // Start both independent HTTP requests and wait for the complete result.
      final results = await Future.wait<Object>([
        remote.getHome(),
        remote.getCourse(),
      ]);
      return LearningData(
        home: (results[0] as HomeDataModel).toEntity(),
        course: (results[1] as CourseModel).toEntity(),
      );
    } on LearningFailure {
      rethrow;
    } on FormatException {
      throw const LearningFailure(
        'The server returned an unexpected data format. Please try again.',
      );
    } on TypeError {
      throw const LearningFailure(
        'The server returned incomplete learning data. Please try again.',
      );
    }
  }
}
