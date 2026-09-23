import 'package:flutter_test/flutter_test.dart';
import 'package:lab2/main.dart';

void main() {
  testWidgets('afişează pagina Home', (tester) async {
    await tester.pumpWidget(const LearningApp());
    expect(find.text('Hi, Kristin'), findsOneWidget);
    expect(find.text('Learning Plan'), findsOneWidget);
  });
}
