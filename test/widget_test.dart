// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test
//
// You are not required to write more of these, but a project with a few real
// tests reads very differently from one with none.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';
import 'package:final_project/screens/care_screen.dart';

void main() {
  testWidgets('home dashboard starts with empty states', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Vivari'), findsOneWidget);
    expect(find.text('Total Aquariums'), findsOneWidget);

    await tester.drag(find.byType(Scrollable), const Offset(0, -500));
    await tester.pump();

    expect(find.text('No aquariums yet'), findsOneWidget);
    expect(find.text('No tasks for today'), findsOneWidget);
  });

  testWidgets('care shows empty sections and opens separate view screens', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CareScreen()));

    expect(find.text('SCHEDULE'), findsOneWidget);
    expect(find.text('Care'), findsOneWidget);
    expect(find.text('Aquarium Filter'), findsOneWidget);
    expect(find.text('Task Sections'), findsOneWidget);
    expect(find.text('Clean Algae Scraper'), findsNothing);

    await tester.tap(find.text('List'));
    await tester.pumpAndSettle();

    expect(find.text('No tasks scheduled'), findsOneWidget);
  });

  testWidgets('care add task button opens the placeholder screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CareScreen()));

    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    expect(find.text('Add Task is ready to be built.'), findsOneWidget);
  });
}
