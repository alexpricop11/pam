class Course {
  const Course({
    required this.title,
    required this.teacher,
    required this.price,
    required this.durationHours,
    required this.category,
    required this.color,
  });

  final String title;
  final String teacher;
  final int price;
  final int durationHours;
  final CourseFilter category;
  final int color;
}

enum CourseFilter { all, popular, newCourse }

const courses = [
  Course(title: 'Product Design v1.0', teacher: 'Robertson Connie', price: 190, durationHours: 16, category: CourseFilter.popular, color: 0xFFD7D7D7),
  Course(title: 'Java Development', teacher: 'Nguyen Shane', price: 190, durationHours: 16, category: CourseFilter.newCourse, color: 0xFFCFE4FF),
  Course(title: 'Visual Design', teacher: 'Bert Pullman', price: 250, durationHours: 14, category: CourseFilter.popular, color: 0xFFE6D5FF),
];
