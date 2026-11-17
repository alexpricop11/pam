import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4/presentation/theme/app_theme.dart';
import 'package:lab4/presentation/widgets/common.dart';

void main() {
  for (final scenario in [
    (size: const Size(320, 640), scale: 1.0),
    (size: const Size(568, 320), scale: 2.0),
    (size: const Size(320, 568), scale: 3.0),
  ]) {
    testWidgets(
      'retry is reachable at ${scenario.size}, scale ${scenario.scale}',
      (tester) async {
        tester.view.physicalSize = scenario.size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var retries = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: appTheme(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scenario.scale)),
              child: child!,
            ),
            home: Scaffold(
              body: StatusMessage(
                title: 'Something went wrong',
                message:
                    'Cannot connect to the server. Check your internet '
                    'connection and try again.',
                icon: Icons.cloud_off_outlined,
                action: 'Try again',
                onAction: () => retries++,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Try again'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Try again'));
        expect(retries, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('empty state also fits inside a scrolling lesson list', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: const [
              StatusMessage(
                title: 'No lessons found',
                message: 'There are no lessons in this course yet.',
                icon: Icons.search_off,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No lessons found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
