import 'package:flutter/material.dart';
import 'package:herkese_sor/screens/category_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:herkese_sor/firebase_options.dart';

Widget createCategoryScreen() => const MaterialApp(
      home: CategoryScreen(),
    );

void main() {
  testWidgets('Category Clicks smoke test', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await tester.pumpWidget(createCategoryScreen());
    await tester.tap(find.text('Date Night'));
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));
    expect(find.byIcon(Icons.send_rounded), findsOneWidget);

    // await tester.enterText(
    //     find.widgetWithText(TextFormField, 'Username'), 'kemale');
    // await tester.enterText(
    //     find.widgetWithText(TextFormField, 'Email Address'), 'bus@gmail.com');
    // await tester.enterText(
    //     find.widgetWithText(TextFormField, 'Password'), '123457');

    // await tester.tap(find.byType(ElevatedButton));
    // await tester.pump();

    // await tester.pump(const Duration(seconds: 2));

    // expect(find.byIcon(Icons.exit_to_app_rounded), findsOneWidget);
  });
}
