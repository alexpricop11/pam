class Lesson {
  Lesson.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      title = json['title'] as String,
      duration = json['duration'] as String,
      durationSeconds = json['durationSeconds'] as int,
      completed = json['completed'] as bool,
      locked = json['locked'] as bool;
  final String id, title, duration;
  final int durationSeconds;
  final bool completed, locked;
}

class LearningPlan {
  LearningPlan.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String,
      completed = json['completed'] as int,
      total = json['total'] as int;
  final String title;
  final int completed, total;
  double get progress => total == 0 ? 0 : (completed / total).clamp(0, 1);
}

class HomeData {
  HomeData.fromJson(Map<String, dynamic> json)
    : greeting = json['header']['greeting'] as String,
      subtitle = json['header']['subtitle'] as String,
      learnedMinutes = json['learnedToday']['learnedMinutes'] as int,
      goalMinutes = json['learnedToday']['goalMinutes'] as int,
      prompt = json['learningPrompt']['title'] as String,
      promptAction = json['learningPrompt']['actionLabel'] as String,
      meetupTitle = json['meetup']['title'] as String,
      meetupSubtitle = json['meetup']['subtitle'] as String,
      plans = List.unmodifiable(
        (json['learningPlan']['items'] as List).map(
          (item) => LearningPlan.fromJson(item as Map<String, dynamic>),
        ),
      );
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
  Course.fromJson(Map<String, dynamic> page)
    : id = page['course']['id'] as String,
      title = page['course']['title'] as String,
      duration = page['course']['duration'] as String,
      lessonCount = page['course']['lessonCount'] as int,
      rating = (page['course']['rating'] as num).toDouble(),
      heroLabel = page['course']['hero']['label'] as String,
      imageUrl = page['course']['hero']['imageUrl'] as String,
      videoCount = page['course']['hero']['videoCount'] as int,
      classCount = page['course']['hero']['classCount'] as int,
      description = page['course']['description']['text'] as String,
      price = page['actions']['price']['label'] as String,
      enrollLabel = page['actions']['enroll']['label'] as String,
      enrollEnabled = page['actions']['enroll']['enabled'] as bool,
      lessons = List.unmodifiable(
        (page['course']['lessons'] as List).map(
          (item) => Lesson.fromJson(item as Map<String, dynamic>),
        ),
      );
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
  LearningData.fromJson(Map<String, dynamic> json)
    : home = HomeData.fromJson(json['homePage'] as Map<String, dynamic>),
      course = Course.fromJson(
        json['courseOverviewPage'] as Map<String, dynamic>,
      );
  final HomeData home;
  final Course course;
}
