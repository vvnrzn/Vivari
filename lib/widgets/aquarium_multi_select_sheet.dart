import 'package:flutter/material.dart';

import '../models/aquarium.dart';

Future<List<Aquarium>?> showAquariumMultiSelectSheet({
  required BuildContext context,
  required List<Aquarium> aquariums,
  required Iterable<Aquarium> selectedAquariums,
}) => showModalBottomSheet<List<Aquarium>>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) {
    final selected = Set<Aquarium>.of(selectedAquariums);
    return StatefulBuilder(
      builder: (context, setModalState) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.6,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final aquarium in aquariums)
                      CheckboxListTile(
                        value: selected.contains(aquarium),
                        title: Text(aquarium.name),
                        subtitle: Text(
                          '${aquarium.volume.toStringAsFixed(0)} ${aquarium.volumeUnit}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onChanged: (isSelected) => setModalState(() {
                          if (isSelected ?? false) {
                            selected.add(aquarium);
                          } else {
                            selected.remove(aquarium);
                          }
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, selected.toList()),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
