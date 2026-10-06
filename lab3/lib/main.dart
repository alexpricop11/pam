import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/learning_cubit.dart';
import 'repositories/learning_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const LearningApp());

class LearningApp extends StatelessWidget {
  const LearningApp({super.key, this.repository});
  final LearningRepository? repository;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LearningCubit(repository ?? LearningRepository())..load(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning • Lab 3',
      theme: appTheme(),
      home: const HomeScreen(),
    ),
  );
}
