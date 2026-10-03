// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test
//
// You are not required to write more of these, but a project with a few real
// tests reads very differently from one with none.

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/main.dart';
import 'package:final_project/models/aquarium.dart';
import 'package:final_project/models/care_record.dart';
import 'package:final_project/screens/care_screen.dart';
import 'package:final_project/screens/home_dashboard.dart';

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

  testWidgets('home aquarium names are ellipsized on one line', (tester) async {
    const name = 'An Extremely Long Aquarium Name That Cannot Fit';
    final aquarium = Aquarium(
      name: name,
      type: AquariumType.freshwater,
      volume: 40,
      volumeUnit: 'L',
      createdAt: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HomeDashboard(
          onSelectTab: (_) {},
          aquariums: [aquarium],
          tasks: const [],
          activities: const [],
          onAquariumAdded: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text(name));
    expect(label.maxLines, 1);
    expect(label.overflow, TextOverflow.ellipsis);
  });

  testWidgets('care switches between four empty view modes', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CareScreen()));

    expect(find.text('SCHEDULE'), findsOneWidget);
    expect(find.text('Care'), findsOneWidget);
    expect(find.text('All Tanks'), findsOneWidget);
    expect(find.text('OVERDUE (0)'), findsNothing);
    expect(find.text('DUE TODAY (0)'), findsOneWidget);
    expect(find.text('UPCOMING — NEXT 7 DAYS (0)'), findsOneWidget);

    await tester.tap(find.text('Week'));
    await tester.pump();
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('-'), findsNothing);

    await tester.tap(find.text('Month'));
    await tester.pump();
    expect(find.text('Su'), findsOneWidget);
    expect(find.text('Sa'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pump();
    expect(find.text('No history yet'), findsOneWidget);
  });

  testWidgets('Care filters aquariums and shows calendar task overflow', (
    tester,
  ) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final aquariums = [
      Aquarium(
        name: 'Tank A',
        type: AquariumType.freshwater,
        volume: 40,
        volumeUnit: 'L',
        createdAt: today,
      ),
      Aquarium(
        name: 'Tank B',
        type: AquariumType.saltwater,
        volume: 80,
        volumeUnit: 'L',
        createdAt: today,
      ),
    ];
    CareTask task(String title, String tank, DateTime date) => CareTask(
      title: title,
      category: title,
      aquariumName: tank,
      dueAt: date,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CareScreen(
          aquariums: aquariums,
          tasks: [
            for (var index = 0; index < 4; index++)
              task('Today $index', 'Tank A', today),
            task('Other tank today', 'Tank B', today),
            task('Tomorrow', 'Tank A', today.add(const Duration(days: 1))),
            task(
              'Outside horizon',
              'Tank A',
              today.add(const Duration(days: 8)),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tank A'), findsWidgets);
    expect(find.text('Tank B'), findsWidgets);
    await tester.tap(find.text('Tank A').first);
    await tester.pumpAndSettle();
    expect(find.text('DUE TODAY (4)'), findsOneWidget);
    expect(find.text('UPCOMING — NEXT 7 DAYS (1)'), findsOneWidget);

    await tester.tap(find.text('Month'));
    await tester.pumpAndSettle();
    expect(find.text('+1'), findsOneWidget);
  });

  testWidgets('aquarium filter scrolls horizontally through all tanks', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final today = DateUtils.dateOnly(DateTime.now());
    final aquariums = [
      for (var index = 1; index <= 6; index++)
        Aquarium(
          name: 'Display Tank $index',
          type: AquariumType.freshwater,
          volume: 40,
          volumeUnit: 'L',
          createdAt: today,
        ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: CareScreen(aquariums: aquariums)),
    );
    await tester.pumpAndSettle();

    final filterScrollView = find.byKey(
      const ValueKey('aquarium-filter-scroll-view'),
    );
    expect(filterScrollView, findsOneWidget);
    final filterScrollable = find.descendant(
      of: filterScrollView,
      matching: find.byType(Scrollable),
    );
    expect(
      tester.state<ScrollableState>(filterScrollable).position.maxScrollExtent,
      greaterThan(0),
    );

    await tester.drag(
      filterScrollView,
      const Offset(-2000, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(
      tester.state<ScrollableState>(filterScrollable).position.pixels,
      greaterThan(0),
    );
    final lastPill = tester.getRect(find.text('Display Tank 6'));
    final filterViewport = tester.getRect(filterScrollView);
    expect(lastPill.left, greaterThanOrEqualTo(filterViewport.left));
    expect(lastPill.right, lessThanOrEqualTo(filterViewport.right));
    expect(lastPill.top, greaterThanOrEqualTo(filterViewport.top));
    expect(lastPill.bottom, lessThanOrEqualTo(filterViewport.bottom));
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

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Feed Fish'), findsNothing);

    await tester.tap(find.text('Care'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mark task complete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Feed Fish'), findsOneWidget);
  });

  testWidgets('logging a preset activity updates Care history', (tester) async {
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
    expect(find.text('Category'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Cleaned filter'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Cleaned filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save activity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Changed water'), findsOneWidget);
    expect(find.text('Cleaned filter'), findsOneWidget);
  });
}
