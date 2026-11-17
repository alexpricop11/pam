class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.durationSeconds,
    required this.completed,
    required this.locked,
  });
  final String id, title, duration;
  final int durationSeconds;
  final bool completed, locked;
}

class LearningPlan {
  const LearningPlan({
    required this.title,
    required this.completed,
    required this.total,
  });
  final String title;
  final int completed, total;
  double get progress => total == 0 ? 0 : (completed / total).clamp(0, 1);
}

class HomeData {
  HomeData({
    required this.greeting,
    required this.subtitle,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.prompt,
    required this.promptAction,
    required this.meetupTitle,
    required this.meetupSubtitle,
    required List<LearningPlan> plans,
  }) : plans = List.unmodifiable(plans);
  final String greeting,
      subtitle,
      prompt,
      promptAction,
      meetupTitle,
      meetupSubtitle;
  final int learnedMinutes, goalMinutes;
  final List<LearningPlan> plans;
  double get progress =>
      goalMinutes == 0 ? 0 : (learnedMinutes / goalMinutes).clamp(0, 1);
}

class Course {
  Course({
    required this.id,
    required this.title,
    required this.duration,
    required this.lessonCount,
    required this.rating,
    required this.heroLabel,
    required this.imageUrl,
    required this.videoCount,
    required this.classCount,
    required this.description,
    required this.price,
    required this.enrollLabel,
    required this.enrollEnabled,
    required List<Lesson> lessons,
  }) : lessons = List.unmodifiable(lessons);
  final String id,
      title,
      duration,
      heroLabel,
      imageUrl,
      description,
      price,
      enrollLabel;
  final int lessonCount, videoCount, classCount;
  final double rating;
  final bool enrollEnabled;
  final List<Lesson> lessons;
}

class LearningData {
  const LearningData({required this.home, required this.course});
  final HomeData home;
  final Course course;
}
