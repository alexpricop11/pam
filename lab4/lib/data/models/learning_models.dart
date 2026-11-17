import 'dart:convert';

import '../../domain/entities/learning_data.dart' as domain;

class LessonModel {
  LessonModel.fromJson(Map<String, dynamic> json)
    : _json = jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
      id = json['id'] as String,
      title = json['title'] as String,
      duration = json['duration'] as String,
      durationSeconds = json['durationSeconds'] as int,
      completed = json['completed'] as bool,
      locked = json['locked'] as bool;
  final String id, title, duration;
  final int durationSeconds;
  final bool completed, locked;
  final Map<String, dynamic> _json;
  Map<String, dynamic> toJson() =>
      jsonDecode(jsonEncode(_json)) as Map<String, dynamic>;
  domain.Lesson toEntity() => domain.Lesson(
    id: id,
    title: title,
    duration: duration,
    durationSeconds: durationSeconds,
    completed: completed,
    locked: locked,
  );
}

class LearningPlanModel {
  LearningPlanModel.fromJson(Map<String, dynamic> json)
    : _json = jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
      title = json['title'] as String,
      completed = json['completed'] as int,
      total = json['total'] as int;
  final String title;
  final int completed, total;
  double get progress => total == 0 ? 0 : (completed / total).clamp(0, 1);
  final Map<String, dynamic> _json;
  Map<String, dynamic> toJson() =>
      jsonDecode(jsonEncode(_json)) as Map<String, dynamic>;
  domain.LearningPlan toEntity() =>
      domain.LearningPlan(title: title, completed: completed, total: total);
}

class HomeDataModel {
  HomeDataModel.fromJson(Map<String, dynamic> json)
    : _json = jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
      greeting = json['header']['greeting'] as String,
      subtitle = json['header']['subtitle'] as String,
      learnedMinutes = json['learnedToday']['learnedMinutes'] as int,
      goalMinutes = json['learnedToday']['goalMinutes'] as int,
      prompt = json['learningPrompt']['title'] as String,
      promptAction = json['learningPrompt']['actionLabel'] as String,
      meetupTitle = json['meetup']['title'] as String,
      meetupSubtitle = json['meetup']['subtitle'] as String,
      plans = List.unmodifiable(
        (json['learningPlan']['items'] as List).map(
          (item) => LearningPlanModel.fromJson(item as Map<String, dynamic>),
        ),
      );
  final String greeting,
      subtitle,
      prompt,
      promptAction,
      meetupTitle,
      meetupSubtitle;
  final int learnedMinutes, goalMinutes;
  final List<LearningPlanModel> plans;
  double get progress =>
      goalMinutes == 0 ? 0 : (learnedMinutes / goalMinutes).clamp(0, 1);
  final Map<String, dynamic> _json;
  Map<String, dynamic> toJson() =>
      jsonDecode(jsonEncode(_json)) as Map<String, dynamic>;
  domain.HomeData toEntity() => domain.HomeData(
    greeting: greeting,
    subtitle: subtitle,
    learnedMinutes: learnedMinutes,
    goalMinutes: goalMinutes,
    prompt: prompt,
    promptAction: promptAction,
    meetupTitle: meetupTitle,
    meetupSubtitle: meetupSubtitle,
    plans: plans.map((p) => p.toEntity()).toList(),
  );
}

class CourseModel {
  CourseModel.fromJson(Map<String, dynamic> page)
    : _json = jsonDecode(jsonEncode(page)) as Map<String, dynamic>,
      id = page['course']['id'] as String,
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
          (item) => LessonModel.fromJson(item as Map<String, dynamic>),
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
  final List<LessonModel> lessons;
  final Map<String, dynamic> _json;
  Map<String, dynamic> toJson() =>
      jsonDecode(jsonEncode(_json)) as Map<String, dynamic>;
  domain.Course toEntity() => domain.Course(
    id: id,
    title: title,
    duration: duration,
    lessonCount: lessonCount,
    rating: rating,
    heroLabel: heroLabel,
    imageUrl: imageUrl,
    videoCount: videoCount,
    classCount: classCount,
    description: description,
    price: price,
    enrollLabel: enrollLabel,
    enrollEnabled: enrollEnabled,
    lessons: lessons.map((l) => l.toEntity()).toList(),
  );
}
