// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quiz_admin_app/di/injection_container.dart';
import 'package:quiz_admin_app/main.dart';

void main() {
  testWidgets('Quiz app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(providers: InjectionContainer.providers, child: const QuizAdminApp()));

    // Verify that our app shows quiz list page
    expect(find.text('Квизы'), findsOneWidget);
    expect(find.text('Нет созданных квизов'), findsOneWidget);
  });
}
