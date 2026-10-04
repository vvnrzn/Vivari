import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/aquarium.dart';
import 'package:final_project/models/care_record.dart';
import 'package:final_project/screens/home_dashboard.dart';

void main() {
  testWidgets('latest activity shows a relative date and compact details', (
    tester,
  ) async {
    final now = DateTime.now();
    const aquariumName = 'An Extremely Long Aquarium Name That Cannot Fit';
    await tester.pumpWidget(
      MaterialApp(
        home: HomeDashboard(
          onSelectTab: (_) {},
          aquariums: const [],
          tasks: const [],
          activities: [
            CareActivity(
              name: 'Changed water',
              category: 'Maintenance',
              aquariumName: aquariumName,
              loggedAt: now,
              amount: '25',
              unit: '%',
            ),
            CareActivity(
              name: 'Added product or fertilizer',
              category: 'Water treatment',
              aquariumName: 'Pacific Reef',
              loggedAt: now.subtract(const Duration(days: 2)),
              amount: '2',
              unit: 'ml',
            ),
          ],
          onAquariumAdded: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('2 days ago'), findsOneWidget);
    expect(find.text('$aquariumName · 25%'), findsOneWidget);
    expect(find.text('Pacific Reef · 2 ml'), findsOneWidget);

    final waterChangeDate = tester.getTopLeft(find.text('Today')).dy;
    final dosingDate = tester.getTopLeft(find.text('2 days ago')).dy;
    expect(waterChangeDate, dosingDate);
    expect(
      tester.widget<Text>(find.text('Today')).style,
      tester.widget<Text>(find.text('No tasks for today')).style,
    );

    final caption = tester.widget<Text>(find.text('$aquariumName · 25%'));
    expect(caption.maxLines, 1);
    expect(caption.overflow, TextOverflow.ellipsis);
    expect(caption.textAlign, TextAlign.start);
    expect(tester.takeException(), isNull);
  });

  testWidgets('aquarium card counts associated scheduled tasks', (tester) async {
    final aquarium = Aquarium(
      name: 'Reef Tank',
      type: AquariumType.saltwater,
      volume: 40,
      volumeUnit: 'gal',
      createdAt: DateTime(2026),
    );
    final otherAquariumTask = CareTask(
      title: 'Feed fish',
      category: 'Feeding',
      aquariumName: 'Other Tank',
      dueAt: DateTime.now().add(const Duration(days: 30)),
    );
    final aquariumTask = CareTask(
      title: 'Check filter',
      category: 'Maintenance',
      aquariumName: 'Reef Tank',
      dueAt: DateTime.now().add(const Duration(days: 30)),
    );
    final sharedAquariumTask = CareTask(
      title: 'Test water',
      category: 'Water testing',
      aquariumName: 'Reef Tank',
      aquariumNames: const ['Reef Tank', 'Other Tank'],
      dueAt: DateTime.now().add(const Duration(days: 45)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HomeDashboard(
          onSelectTab: (_) {},
          aquariums: [aquarium],
          tasks: [otherAquariumTask, aquariumTask, sharedAquariumTask],
          activities: const [],
          onAquariumAdded: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Saltwater'));

    final badge = find.byKey(const ValueKey('pending-task-badge'));
    expect(badge, findsOneWidget);
    expect(find.descendant(of: badge, matching: find.text('2')), findsOneWidget);
    expect(find.text('2 pending'), findsNothing);
    expect(tester.getTopLeft(badge).dx, lessThan(tester.getTopLeft(find.text('Saltwater')).dx));
    expect(tester.takeException(), isNull);
  });

  testWidgets('aquarium card omits the pending badge when the count is zero', (
    tester,
  ) async {
    final aquarium = Aquarium(
      name: 'Reef Tank',
      type: AquariumType.saltwater,
      volume: 40,
      volumeUnit: 'gal',
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
    await tester.ensureVisible(find.text('Saltwater'));

    expect(find.byKey(const ValueKey('pending-task-badge')), findsNothing);
    expect(find.text('Saltwater'), findsOneWidget);
  });

  testWidgets('completed one-off tasks are excluded from pending count', (
    tester,
  ) async {
    final aquarium = Aquarium(
      name: 'Reef Tank',
      type: AquariumType.saltwater,
      volume: 40,
      volumeUnit: 'gal',
      createdAt: DateTime(2026),
    );
    final completedTask = CareTask(
      title: 'Clean glass',
      category: 'Maintenance',
      aquariumName: 'Reef Tank',
      dueAt: DateTime(2026, 10, 5),
    );
    final pendingTask = CareTask(
      title: 'Check filter',
      category: 'Maintenance',
      aquariumName: 'Reef Tank',
      dueAt: DateTime(2026, 10, 6),
      recurrence: TaskRecurrence.basic,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HomeDashboard(
          onSelectTab: (_) {},
          aquariums: [aquarium],
          tasks: [completedTask, pendingTask],
          taskCompletions: [
            CareTaskCompletion(
              task: completedTask,
              scheduledDate: completedTask.dueAt,
              completedAt: DateTime(2026, 10, 5),
            ),
          ],
          activities: const [],
          onAquariumAdded: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Saltwater'));

    final badge = find.byKey(const ValueKey('pending-task-badge'));
    expect(find.descendant(of: badge, matching: find.text('1')), findsOneWidget);
  });
}
