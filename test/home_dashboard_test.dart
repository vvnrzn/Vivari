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

  testWidgets('aquarium card shows a count-only pending badge when needed', (
    tester,
  ) async {
    final aquarium = Aquarium(
      name: 'Reef Tank',
      type: AquariumType.saltwater,
      volume: 40,
      volumeUnit: 'gal',
      createdAt: DateTime(2026),
      pendingTasks: 3,
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

    expect(find.text('3'), findsOneWidget);
    expect(find.text('3 pending'), findsNothing);
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

    expect(find.text('0'), findsOneWidget);
    expect(find.text('Saltwater'), findsOneWidget);
  });
}
