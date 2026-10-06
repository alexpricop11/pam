import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/main.dart';
import 'package:lab3/repositories/learning_repository.dart';

import 'learning_cubit_test.dart'
    show fixture, StringBundle, ControlledRepository;

void main() {
  testWidgets(
    'home navigates to overview, searches, favorites, and lesson details',
    (tester) async {
      await tester.pumpWidget(
        LearningApp(
          repository: LearningRepository(bundle: StringBundle(fixture())),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hi, Kristin'), findsOneWidget);
      await tester.tap(find.text('My courses'));
      await tester.pumpAndSettle();
      expect(find.text('Course Overview'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'missing');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Reset filters'),
        220,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Reset filters'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Introduction to React'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Introduction to React'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Introduction to React'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson details'), findsOneWidget);
      await tester.tap(find.byTooltip('Add to favorites'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
      await tester.tap(find.text('Mark as completed'));
      await tester.pumpAndSettle();
      expect(find.text('Completed'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    },
  );
  testWidgets('loading and error display retry', (tester) async {
    final repository = ControlledRepository();
    await tester.pumpWidget(LearningApp(repository: repository));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.requests.first.completeError(StateError('missing'));
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(repository.requests.length, 2);
    repository.requests.last.completeError(StateError('missing again'));
    await tester.pumpAndSettle();
  });
  for (final width in [320.0, 768.0, 1440.0]) {
    testWidgets('home and overview fit width $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        LearningApp(
          repository: LearningRepository(bundle: StringBundle(fixture())),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('My courses'));
      await tester.pumpAndSettle();
      expect(find.text('Course Overview'), findsOneWidget);

      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();
      expect(
        find.text('No description has been provided for this course.'),
        findsOneWidget,
      );
    });
  }
}
