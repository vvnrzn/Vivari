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

  testWidgets('care switches between four empty view modes', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CareScreen()));

    expect(find.text('SCHEDULE'), findsOneWidget);
    expect(find.text('Care'), findsOneWidget);
    expect(find.text('All Tanks'), findsOneWidget);
    expect(find.text('OVERDUE (0)'), findsOneWidget);
    expect(find.text('DUE TODAY (0)'), findsOneWidget);
    expect(find.text('UPCOMING — NEXT 7 DAYS (0)'), findsOneWidget);

    await tester.tap(find.text('Week'));
    await tester.pump();
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('-'), findsNWidgets(7));

    await tester.tap(find.text('Month'));
    await tester.pump();
    expect(find.text('Su'), findsOneWidget);
    expect(find.text('Sa'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pump();
    expect(find.text('No completed tasks'), findsOneWidget);
  });

  testWidgets('care add task button opens the placeholder screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CareScreen()));

    await tester.tap(find.byTooltip('Add Task'));
    await tester.pumpAndSettle();

    expect(find.text('Add Task is ready to be built.'), findsOneWidget);
  });
}
