import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herkese_sor/screens/auth_screen.dart';
import 'package:herkese_sor/screens/tabs_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:herkese_sor/firebase_options.dart';
import 'package:herkese_sor/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Scroll App Integration', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await tester.pumpWidget(const app.MyApp());

    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'), 'bu@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '123457');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(TabsScreen), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.stars_rounded));
    await tester.pumpAndSettle();

    final listFinder = find.byType(ListView);

    await binding.traceAction(() async {
      await tester.fling(listFinder, const Offset(0, -500), 10000);
      await tester.pumpAndSettle();

      await tester.fling(listFinder, const Offset(0, 500), 10000);
      await tester.pumpAndSettle();
    }, reportKey: 'scrolling_summary');
  });
}
