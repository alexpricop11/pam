import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'data/datasources/learning_remote_data_source.dart';
import 'data/repositories/learning_repository_impl.dart';
import 'domain/repositories/learning_repository.dart';
import 'domain/usecases/get_learning_data.dart';
import 'presentation/cubit/learning_cubit.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() => runApp(const LearningApp());

class LearningApp extends StatefulWidget {
  const LearningApp({super.key, this.repository});
  final LearningRepository? repository;
  @override
  State<LearningApp> createState() => _LearningAppState();
}

class _LearningAppState extends State<LearningApp> {
  http.Client? _client;
  late final LearningRepository _repository;
  @override
  void initState() {
    super.initState();
    _repository =
        widget.repository ??
        LearningRepositoryImpl(
          LearningRemoteDataSource(ApiClient(_client = http.Client())),
        );
  }

  @override
  void dispose() {
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LearningCubit(GetLearningData(_repository))..load(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning • Lab 4',
      theme: appTheme(),
      home: const HomeScreen(),
    ),
  );
}
