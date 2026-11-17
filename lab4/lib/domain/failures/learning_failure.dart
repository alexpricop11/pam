class LearningFailure implements Exception {
  const LearningFailure(this.message);
  final String message;
  @override
  String toString() => message;
}
