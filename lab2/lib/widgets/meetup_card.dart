import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MeetupCard extends StatelessWidget {
  const MeetupCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpace.md),
    decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Meetup', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF5B168B))),
        Text('Off-line exchange of learning experience', style: TextStyle(fontSize: 11, color: Color(0xFF5B168B))),
      ])),
      const Icon(Icons.groups_rounded, size: 56, color: AppColors.primary),
    ]),
  );
}
