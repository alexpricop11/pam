import '../../core/network/api_client.dart';
import '../models/learning_models.dart';

class LearningRemoteDataSource {
  const LearningRemoteDataSource(this.api);
  final ApiClient api;
  Future<HomeDataModel> getHome() async =>
      HomeDataModel.fromJson(await api.get('feed'));
  Future<CourseModel> getCourse() async =>
      CourseModel.fromJson(await api.get('feed/details'));
}
