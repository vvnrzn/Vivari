import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/aquarium.dart';
import 'package:final_project/models/care_record.dart';
import 'package:final_project/screens/add_task_screen.dart';
import 'package:final_project/screens/care_screen.dart';
import 'package:final_project/screens/log_activity_screen.dart';

void main() {
  final aquariums = [
    Aquarium(
      name: 'Tank A',
      type: AquariumType.freshwater,
      volume: 40,
      volumeUnit: 'L',
      createdAt: DateTime(2026),
    ),
    Aquarium(
      name: 'Tank B',
      type: AquariumType.saltwater,
      volume: 80,
      volumeUnit: 'L',
      createdAt: DateTime(2026),
    ),
  ];

  testWidgets('task can be assigned to multiple aquariums', (tester) async {
    CareTask? createdTask;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => AddTaskScreen(
                    aquariums: aquariums,
                    onCreated: (task) => createdTask = task,
                  ),
                ),
              ),
              child: const Text('Open task form'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open task form'));
    await tester.pumpAndSettle();

    final createTaskButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Create Task'),
    );
    expect(createTaskButton.onPressed, isNull);

    await tester.scrollUntilVisible(
      find.text('Select aquarium(s)'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Select aquarium(s)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile).at(0));
    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextButton>(
            find.widgetWithText(TextButton, 'Create Task'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.enterText(find.byType(TextField).first, 'Clean both tanks');
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    expect(createdTask, isNotNull);
    expect(createdTask!.associatedAquariumNames, ['Tank A', 'Tank B']);
    expect(createdTask!.isAssociatedWithAquarium('Tank B'), isTrue);
  });

  testWidgets('activity can be logged for multiple aquariums', (tester) async {
    final loggedActivities = <CareActivity>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => LogActivityScreen(
                    aquariums: aquariums,
                    templates: const [],
                    onSaved: (activity, _) => loggedActivities.add(activity),
                  ),
                ),
              ),
              child: const Text('Open activity form'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open activity form'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Save activity'),
          )
          .onPressed,
      isNull,
    );

    await tester.ensureVisible(find.text('Select aquarium(s)'));
    await tester.tap(find.text('Select aquarium(s)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile).at(0));
    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Save activity'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.ensureVisible(find.text('Fed fish'));
    await tester.tap(find.text('Fed fish'));
    await tester.tap(find.text('Save activity'));
    await tester.pumpAndSettle();

    expect(loggedActivities.map((activity) => activity.aquariumName), [
      'Tank A',
      'Tank B',
    ]);
  });

  testWidgets('history includes only the past 30 days', (tester) async {
    final now = DateTime.now();
    CareActivity activity(String name, DateTime loggedAt) => CareActivity(
      name: name,
      category: 'Maintenance',
      aquariumName: '',
      loggedAt: loggedAt,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CareScreen(
          activities: [
            activity('Recent log', now.subtract(const Duration(days: 3))),
            activity('Old log', now.subtract(const Duration(days: 31))),
          ],
        ),
      ),
    );
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(
      find.text('Showing tasks and logs from the past 30 days.'),
      findsOneWidget,
    );
    expect(find.text('Recent log'), findsOneWidget);
    expect(find.text('Old log'), findsNothing);
  });

  testWidgets('long aquarium names are ellipsized in care filters', (
    tester,
  ) async {
    const name = 'An Extremely Long Aquarium Name That Cannot Fit';
    final aquarium = Aquarium(
      name: name,
      type: AquariumType.freshwater,
      volume: 40,
      volumeUnit: 'L',
      createdAt: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(home: CareScreen(aquariums: [aquarium])),
    );
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text(name));
    expect(label.maxLines, 1);
    expect(label.overflow, TextOverflow.ellipsis);
  });
}
