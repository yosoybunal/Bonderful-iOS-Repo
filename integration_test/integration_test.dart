import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herkese_sor/screens/auth_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:herkese_sor/screens/tabs_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:herkese_sor/firebase_options.dart';
import 'package:herkese_sor/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test App Integration', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await tester.pumpWidget(const app.MyApp());

    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create an account'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byIcon(FontAwesomeIcons.circleUser), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'), 'kemalete');
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'), 'buk@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '123457');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(TabsScreen), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Date Night'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star_border_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_sharp));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.stars_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(TabsScreen), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
