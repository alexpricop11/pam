import 'package:flutter/material.dart';
import '../models/course.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/course_card.dart';
import '../widgets/search_course_field.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  CourseFilter _filter = CourseFilter.all;
  String _query = '';
  List<Course> get _visible => courses.where((course) => (_filter == CourseFilter.all || course.category == _filter) && course.title.toLowerCase().contains(_query.toLowerCase())).toList();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: AppColors.canvas, elevation: 0, title: const Text('Course', style: TextStyle(fontWeight: FontWeight.w700)), actions: const [Padding(padding: EdgeInsets.only(right: 18), child: CircleAvatar(backgroundColor: Color(0xFFFFD5CC), child: Icon(Icons.person, color: AppColors.ink)))], automaticallyImplyLeading: true),
    body: SafeArea(top: false, child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600), child: LayoutBuilder(builder: (context, constraints) {
      final gutter = constraints.maxWidth < 360 ? 16.0 : constraints.maxWidth * .055;
      return ListView(padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 24), children: [
        SearchCourseField(onChanged: (value) => setState(() => _query = value)),
        const SizedBox(height: 20),
        Row(children: const [Expanded(child: CategoryCard(title: 'Language', color: Color(0xFFD0EEFF), icon: Icons.language_rounded)), SizedBox(width: 12), Expanded(child: CategoryCard(title: 'Painting', color: Color(0xFFF0DEFF), icon: Icons.brush_rounded))]),
        const SizedBox(height: 24),
        const Text('Choice your course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(spacing: 10, children: [
          _FilterChip(label: 'All', selected: _filter == CourseFilter.all, onTap: () => setState(() => _filter = CourseFilter.all)),
          _FilterChip(label: 'Popular', selected: _filter == CourseFilter.popular, onTap: () => setState(() => _filter = CourseFilter.popular)),
          _FilterChip(label: 'New', selected: _filter == CourseFilter.newCourse, onTap: () => setState(() => _filter = CourseFilter.newCourse)),
        ]),
        const SizedBox(height: 18),
        if (_visible.isEmpty) const Padding(padding: EdgeInsets.all(28), child: Center(child: Text('Nu am găsit niciun curs.'))),
        ..._visible.map((course) => CourseCard(course: course)),
      ]);
    })))),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(button: true, selected: selected, label: 'Filtru $label', child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap(), selectedColor: AppColors.primary, labelStyle: TextStyle(color: selected ? Colors.white : AppColors.muted, fontWeight: FontWeight.w600), side: BorderSide.none));
}
