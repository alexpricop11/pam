import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF3D5CFF);
  static const ink = Color(0xFF1F1F39);
  static const muted = Color(0xFF858597);
  static const canvas = Color(0xFFF8F8FC);
  static const lavender = Color(0xFFF0E4FF);
  static const blueTint = Color(0xFFD0EEFF);
  static const orange = Color(0xFFFF7A00);
}

abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: AppColors.canvas,
  fontFamily: 'Arial',
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.ink),
    bodySmall: TextStyle(fontSize: 12, color: AppColors.muted),
  ),
);
