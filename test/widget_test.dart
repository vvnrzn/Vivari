// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test
//
// You are not required to write more of these, but a project with a few real
// tests reads very differently from one with none.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';
import 'package:final_project/models/care_record.dart';
import 'package:final_project/screens/care_screen.dart';

void main() {
  testWidgets('home dashboard starts with empty states', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Vivari'), findsOneWidget);
    expect(find.text('TOTAL AQUARIUMS'), findsOneWidget);

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

  testWidgets('care add button offers activity and task flows', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CareScreen()));

    await tester.tap(find.byTooltip('Add Task'));
    await tester.pumpAndSettle();

    expect(find.text('What would you like to add?'), findsOneWidget);
    expect(find.text('Log activity'), findsOneWidget);
    expect(find.text('Add task'), findsOneWidget);
    expect(
      find.text(
        'Choose whether you are recording something done or planning ahead.',
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Add task'));
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    expect(find.text('Task Details'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Recurring Task'), findsOneWidget);
    expect(find.text('Date & Time'), findsOneWidget);
    expect(find.text('Create Task'), findsOneWidget);

    await tester.tap(find.text('Recurring Task'));
    await tester.pumpAndSettle();
    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Custom Interval'), findsOneWidget);
    expect(find.text('Specific Weekdays'), findsOneWidget);
    expect(find.text('Specific Month Days'), findsOneWidget);

    await tester.ensureVisible(find.text('Custom Interval'));
    await tester.tap(find.text('Custom Interval'));
    await tester.pumpAndSettle();
    expect(find.text('Every'), findsOneWidget);
    expect(find.text('days'), findsOneWidget);
    expect(find.text('weeks'), findsOneWidget);
    expect(find.text('months'), findsOneWidget);
    expect(find.textContaining('Schedule Summary:'), findsOneWidget);
  });

  test('recurring tasks match their configured schedule', () {
    final task = CareTask(
      title: 'Feed Fish',
      category: 'Feed Fish',
      aquariumName: 'Community Tank',
      dueAt: DateTime(2026, 9, 30),
      recurrence: TaskRecurrence.customInterval,
      recurrenceUnit: 'Days',
      recurrenceInterval: 2,
    );

    expect(task.isDueOn(DateTime(2026, 9, 30)), isTrue);
    expect(task.isDueOn(DateTime(2026, 10, 2)), isTrue);
    expect(task.isDueOn(DateTime(2026, 10, 1)), isFalse);
    expect(task.isDueOn(DateTime(2026, 9, 29)), isFalse);
  });

  testWidgets('creating a task updates Home dashboard due today', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add Task'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add task'));
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Feed Fish'));
    await tester.tap(find.text('Feed Fish'));
    await tester.pump();
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Feed Fish'), findsOneWidget);
  });

  testWidgets('logging water change updates dashboard status', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add Task'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Log activity'));
    await tester.tap(find.text('Log activity'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Changed water'));
    await tester.pump();
    await tester.tap(find.text('Save activity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('LAST WATER CHANGE'), findsOneWidget);
    expect(find.text('No records yet'), findsOneWidget);
  });
}
