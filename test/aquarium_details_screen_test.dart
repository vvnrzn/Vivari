import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/aquarium.dart';
import 'package:final_project/screens/add_inhabitant_screen.dart';
import 'package:final_project/screens/aquarium_details_screen.dart';
import 'package:final_project/screens/home_dashboard.dart';
import 'package:final_project/theme/app_theme.dart';

Aquarium _aquarium(AquariumType type) => Aquarium(
  name: 'Reef Tank',
  type: type,
  volume: 40,
  volumeUnit: 'gal',
  createdAt: DateTime(2026),
);

void main() {
  testWidgets(
    'details show an empty state and only show corals for saltwater',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AquariumDetailsScreen(
            key: const ValueKey('saltwater'),
            aquarium: _aquarium(AquariumType.saltwater),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No inhabitants yet'), findsOneWidget);
      expect(find.textContaining('Corals'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: AquariumDetailsScreen(
            key: const ValueKey('freshwater'),
            aquarium: _aquarium(AquariumType.freshwater),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No inhabitants yet'), findsOneWidget);
      expect(find.textContaining('Corals'), findsNothing);
    },
  );

  testWidgets(
    'inhabitant categories scroll on one row with a full-width empty state',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: AquariumDetailsScreen(
            aquarium: _aquarium(AquariumType.saltwater),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final fishChip = find.text('Fish  (0)');
      final coralsChip = find.text('Corals  (0)');
      expect(tester.getTopLeft(fishChip).dy, tester.getTopLeft(coralsChip).dy);
      expect(find.text('Add Inhabitant'), findsOneWidget);
      expect(find.byType(Scrollbar), findsNothing);

      final emptyCard = find.ancestor(
        of: find.text('No inhabitants yet'),
        matching: find.byType(Card),
      );
      expect(tester.getSize(emptyCard).width, 360 - (AppSpacing.screen * 2));
      expect(tester.takeException(), isNull);

      await tester.drag(
        find.byKey(const ValueKey('inhabitant-category-scroll-view')),
        const Offset(-300, 0),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(coralsChip).dy, tester.getTopLeft(fishChip).dy);
      expect(tester.getTopLeft(fishChip).dx, lessThan(48));
    },
  );

  testWidgets('add inhabitant supports keyword search and quantity editing', (
    tester,
  ) async {
    final aquarium = _aquarium(AquariumType.freshwater);
    Aquarium? updatedAquarium;
    await tester.pumpWidget(
      MaterialApp(
        theme: VivariTheme.app,
        home: AquariumDetailsScreen(
          aquarium: aquarium,
          onAquariumUpdated: (_, updated) => updatedAquarium = updated,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Inhabitant'));
    await tester.pumpAndSettle();

    expect(find.byType(AddInhabitantScreen), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('inhabitant-search-field')),
      'fighting fish',
    );
    await tester.pumpAndSettle();
    expect(find.text('Betta Fish'), findsOneWidget);
    expect(find.text('GloFish Tetra'), findsNothing);

    await tester.tap(find.text('Betta Fish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Aquarium (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Betta Fish'), findsOneWidget);
    await tester.tap(find.text('Betta Fish'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Inhabitant'), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('x2'), findsOneWidget);
    expect(find.text('Fish  (2)'), findsOneWidget);
    expect(updatedAquarium?.inhabitants.single.quantity, 2);

    await tester.tap(find.text('Plants  (0)'));
    await tester.pumpAndSettle();
    expect(find.text('No plants yet'), findsOneWidget);
    await tester.tap(find.text('Fish  (2)'));
    await tester.pumpAndSettle();
    expect(find.text('Betta Fish'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deleting an aquarium requires confirmation and removes it', (
    tester,
  ) async {
    final aquarium = _aquarium(AquariumType.saltwater);
    final aquariums = [aquarium];
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => HomeDashboard(
            onSelectTab: (_) {},
            aquariums: aquariums,
            tasks: const [],
            activities: const [],
            onAquariumAdded: (_) {},
            onAquariumDeleted: (deleted) =>
                setState(() => aquariums.remove(deleted)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Reef Tank'));
    await tester.tap(find.text('Reef Tank'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Details'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Delete Aquarium'));
    await tester.tap(find.text('Delete Aquarium'));
    await tester.pumpAndSettle();
    expect(find.text('Delete aquarium?'), findsOneWidget);
    expect(
      find.textContaining('This action cannot be undone.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Aquarium'), findsOneWidget);

    await tester.tap(find.text('Delete Aquarium'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete Aquarium').last);
    await tester.pumpAndSettle();

    expect(find.text('No aquariums yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
