import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/learned_today_card.dart';
import '../widgets/learning_banner.dart';
import '../widgets/learning_plan_item.dart';
import '../widgets/meetup_card.dart';
import 'courses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void _openCourses(BuildContext context) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CoursesScreen()));

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      final gutter = constraints.maxWidth < 360 ? 16.0 : constraints.maxWidth * .055;
      return Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(child: Column(children: [
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(gutter, 18, gutter, 44),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hi, Kristin', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)), SizedBox(height: 4), Text("Let's start learning", style: TextStyle(color: Colors.white70))])),
              const CircleAvatar(radius: 23, backgroundColor: Color(0xFFFFD5CC), child: Icon(Icons.person, color: AppColors.ink)),
            ]),
          ),
          Transform.translate(offset: const Offset(0, -28), child: Padding(padding: EdgeInsets.symmetric(horizontal: gutter), child: LearnedTodayCard(onCourses: () => _openCourses(context)))),
          Padding(padding: EdgeInsets.symmetric(horizontal: gutter), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LayoutBuilder(builder: (_, box) => SizedBox(height: 126, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: 3, separatorBuilder: (_, _) => const SizedBox(width: 12), itemBuilder: (_, _) => LearningBanner(width: box.maxWidth * .72)))),
            const SizedBox(height: AppSpace.lg),
            const Text('Learning Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpace.sm),
            Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4), child: Column(children: [LearningPlanItem(title: 'Packaging Design', completed: 40, total: 48), LearningPlanItem(title: 'Product Design', completed: 6, total: 24)]))),
            const SizedBox(height: AppSpace.md),
            const MeetupCard(),
            const SizedBox(height: AppSpace.lg),
          ])),
        ])),
      ));
    })),
  );
}
