import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pam/main.dart';
import 'package:pam/salary_calculator.dart';

void main() {
  test('Cote fictive și validare', () {
    expect(SalaryCalculator.calculate(10000, TaxType.standard).net, 8800);
    expect(SalaryCalculator.calculate(10000, TaxType.reduced).net, 9400);
    expect(SalaryCalculator.calculate(10000, TaxType.exempt).tax, 0);
    expect(SalaryCalculator.calculate(0, TaxType.standard).net, 0);
    expect(SalaryCalculator.parseSalary(' 1234,56 '), 1234.56);
    for (final input in ['', '-1', 'abc']) {
      expect(SalaryCalculator.parseSalary(input), isNull, reason: input);
    }
  });

  testWidgets('Calcul, schimbarea cotei și erori', (tester) async {
    await tester.pumpWidget(const SalaryApp());
    await tester.tap(find.text('Calculează'));
    await tester.pump();
    expect(find.textContaining('Introdu o sumă'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '10000');
    await tester.tap(find.text('Calculează'));
    await tester.pump();
    expect(find.text('8800,00 lei'), findsOneWidget);
    expect(find.text('Impozite: 1200,00 lei'), findsOneWidget);
    await tester.tap(find.text('Standard · 12%'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scutit · 0%').last);
    await tester.pumpAndSettle();
    expect(find.text('8800,00 lei'), findsNothing);
    await tester.tap(find.text('Calculează'));
    await tester.pump();
    expect(find.text('10000,00 lei'), findsOneWidget);
    expect(find.text('Impozite: 0,00 lei'), findsOneWidget);
  });

  testWidgets('Ecran îngust și text mărit', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const SalaryApp());
    await tester.enterText(find.byType(TextField), '12345,67');
    await tester.ensureVisible(find.text('Calculează'));
    await tester.tap(find.text('Calculează'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
