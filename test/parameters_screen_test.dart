import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/aquarium.dart';
import 'package:final_project/screens/parameters_screen.dart';

void main() {
  testWidgets('parameters start empty without displaying tanks or logs', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ParametersScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Parameters'), findsOneWidget);
    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('No readings'), findsWidgets);
    expect(find.text('All Tanks'), findsNothing);
    expect(find.text('Pacific Reef'), findsNothing);
    expect(find.text('78.2°F'), findsNothing);
  });

  testWidgets('settings toggle adds an optional parameter to the list', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ParametersScreen()));
    await tester.tap(find.byTooltip('Parameter Settings'));
    await tester.pumpAndSettle();

    final settingsList = find.byKey(
      const ValueKey('parameter-settings-reorder-list'),
    );
    await tester.drag(settingsList, const Offset(0, -600));
    await tester.pumpAndSettle();
    final ghSwitch = find.byKey(const ValueKey('parameter-enabled-gh'));
    await tester.tap(ghSwitch);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(find.text('GH'), findsOneWidget);
    expect(find.text('No readings'), findsWidgets);
  });

  testWidgets('aquarium selection reveals its recommended parameter ranges', (
    tester,
  ) async {
    final aquarium = Aquarium(
      name: 'Pacific Reef',
      type: AquariumType.saltwater,
      volume: 40,
      volumeUnit: 'gal',
      createdAt: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(home: ParametersScreen(aquariums: [aquarium])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pacific Reef'), findsOneWidget);
    expect(find.text('24–27°C'), findsOneWidget);
    expect(find.text('8.1–8.4'), findsOneWidget);
    expect(find.text('All Tanks'), findsNothing);
  });

  testWidgets('long aquarium names are ellipsized in parameter filters', (
    tester,
  ) async {
    const name = 'An Extremely Long Aquarium Name That Cannot Fit';
    final aquarium = Aquarium(
      name: name,
      type: AquariumType.freshwater,
      volume: 40,
      volumeUnit: 'gal',
      createdAt: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(home: ParametersScreen(aquariums: [aquarium])),
    );
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text(name));
    expect(label.maxLines, 1);
    expect(label.overflow, TextOverflow.ellipsis);
  });

  testWidgets('parameter detail opens an empty chart with Week and Month', (
    tester,
  ) async {
    final aquarium = Aquarium(
      name: 'Freshwater Tank',
      type: AquariumType.freshwater,
      volume: 40,
      volumeUnit: 'gal',
      createdAt: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(home: ParametersScreen(aquariums: [aquarium])),
    );
    await tester.tap(find.text('Temperature'));
    await tester.pumpAndSettle();

    expect(find.text('FRESHWATER TANK'), findsOneWidget);
    expect(find.text('No readings yet'), findsOneWidget);
    expect(find.text('Week'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Custom'), findsNothing);
    expect(find.text('STATUS'), findsOneWidget);
    expect(find.text('AVERAGE'), findsOneWidget);
    expect(find.text('OPTIMAL'), findsOneWidget);
  });

  testWidgets('range editor saves ranges for the selected water type', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ParametersScreen()));
    await tester.tap(find.byTooltip('Parameter Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Customize Temperature range'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Freshwater'));
    await tester.pumpAndSettle();
    final inputs = find.byType(TextField);
    await tester.enterText(inputs.at(0), '70');
    await tester.enterText(inputs.at(1), '83');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Parameter Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Customize Temperature range'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Freshwater'));
    await tester.pumpAndSettle();

    final savedInputs = find.byType(TextField);
    expect(tester.widget<TextField>(savedInputs.at(0)).controller?.text, '70');
    expect(tester.widget<TextField>(savedInputs.at(1)).controller?.text, '83');
  });
}
