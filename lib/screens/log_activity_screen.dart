import 'package:flutter/material.dart';

import '../models/aquarium.dart';
import '../models/care_record.dart';
import '../theme/app_theme.dart';
import '../widgets/aquarium_multi_select_sheet.dart';
import '../widgets/vivari_card.dart';

class LogActivityScreen extends StatefulWidget {
  const LogActivityScreen({
    required this.aquariums,
    required this.templates,
    required this.onSaved,
    super.key,
  });

  final List<Aquarium> aquariums;
  final List<ActivityTemplate> templates;
  final void Function(CareActivity activity, ActivityTemplate? template)
  onSaved;

  @override
  State<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends State<LogActivityScreen> {
  static const _activities = [
    'Fed fish',
    'Added product or fertilizer',
    'Cleaned filter',
    'Changed water',
    'Cleaned the glass',
    'Vacuumed the substrate',
    'Trimmed the plants',
    'Topped up the water',
    'Custom activity',
  ];
  static const _categories = [
    'Water treatment',
    'Filtration and media',
    'Bacteria and biology',
    'Maintenance',
    'Other',
  ];

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _date = DateTime.now();
  final Set<Aquarium> _aquariums = {};
  final Set<String> _selectedActivities = {};
  String _category = 'Maintenance';
  String? _unit;
  bool _saveAsTemplate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectActivity(String activity) {
    setState(() {
      if (!_selectedActivities.add(activity)) {
        _selectedActivities.remove(activity);
      } else if (activity == 'Custom activity') {
        _nameController.clear();
        _category = 'Maintenance';
      }
    });
  }

  String _categoryFor(String activity) => switch (activity) {
    'Added product or fertilizer' => 'Water treatment',
    'Cleaned filter' => 'Filtration and media',
    'Fed fish' => 'Other',
    _ => 'Maintenance',
  };

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (value != null) setState(() => _date = value);
  }

  Future<void> _pickAquarium() async {
    if (widget.aquariums.isEmpty) return;
    final aquariums = await showAquariumMultiSelectSheet(
      context: context,
      aquariums: widget.aquariums,
      selectedAquariums: _aquariums,
    );
    if (aquariums != null) {
      setState(() {
        _aquariums
          ..clear()
          ..addAll(aquariums);
      });
    }
  }

  Future<void> _pickUnit() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _UnitPicker(),
    );
    if (selected != null) setState(() => _unit = selected);
  }

  void _applyTemplate(ActivityTemplate template) {
    setState(() {
      _selectedActivities
        ..clear()
        ..add(
          _activities.contains(template.name)
              ? template.name
              : 'Custom activity',
        );
      _nameController.text = template.name;
      _category = template.category;
      _amountController.text = template.amount ?? '';
      _unit = template.unit;
      _noteController.text = template.note ?? '';
    });
  }

  void _save() {
    final customName = _nameController.text.trim();
    if (_selectedActivities.isEmpty ||
        (_selectedActivities.contains('Custom activity') &&
            customName.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choose at least one activity and enter its name.'),
        ),
      );
      return;
    }
    final now = DateTime.now();
    final loggedAt = DateTime(
      _date.year,
      _date.month,
      _date.day,
      now.hour,
      now.minute,
    );
    final amount = _amountController.text.trim();
    final note = _noteController.text.trim();

    final selectedAquariums = _aquariums.isEmpty
        ? <Aquarium?>[null]
        : _aquariums.toList();
    for (final selectedActivity in _selectedActivities) {
      final name = selectedActivity == 'Custom activity'
          ? customName
          : selectedActivity;
      final category = selectedActivity == 'Custom activity'
          ? _category
          : _categoryFor(selectedActivity);
      for (var index = 0; index < selectedAquariums.length; index++) {
        final aquarium = selectedAquariums[index];
        final activity = CareActivity(
          name: name,
          category: category,
          aquariumName: aquarium?.name ?? '',
          loggedAt: loggedAt,
          amount: amount.isEmpty ? null : amount,
          unit: _unit,
          note: note.isEmpty ? null : note,
        );
        final template = _saveAsTemplate && index == 0
            ? ActivityTemplate(
                name: name,
                category: category,
                amount: activity.amount,
                unit: activity.unit,
                note: activity.note,
              )
            : null;
        widget.onSaved(activity, template);
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = MaterialLocalizations.of(context).formatFullDate(_date);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: const Text('Log activity'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
        children: [
          Text(
            'Save something you did without creating a task',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          _SectionLabel('Date'),
          const SizedBox(height: 8),
          _SelectCard(
            icon: Icons.calendar_today_outlined,
            title: dateLabel,
            onTap: _pickDate,
          ),
          const SizedBox(height: 18),
          _SectionLabel('Aquarium'),
          const SizedBox(height: 8),
          _SelectCard(
            icon: Icons.water_outlined,
            title: _aquariums.isEmpty
                ? 'Select aquarium(s)'
                : _aquariums.map((aquarium) => aquarium.name).join(', '),
            subtitle: _aquariums.length > 1
                ? '${_aquariums.length} aquariums selected'
                : _aquariums.firstOrNull == null
                ? null
                : '${_aquariums.first.volume.toStringAsFixed(0)} ${_aquariums.first.volumeUnit}',
            onTap: _pickAquarium,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(child: _SectionLabel('My Templates')),
              TextButton.icon(
                onPressed: () => setState(() => _saveAsTemplate = true),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create template'),
              ),
            ],
          ),
          if (widget.templates.isEmpty)
            Text(
              'Save an activity as a template to reuse it later.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final template in widget.templates)
                  ActionChip(
                    label: Text(template.name),
                    onPressed: () => _applyTemplate(template),
                  ),
              ],
            ),
          const SizedBox(height: 20),
          _SectionLabel('What did you do?'),
          const SizedBox(height: 8),
          for (final activity in _activities)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ChoiceRow(
                label: activity,
                selected: _selectedActivities.contains(activity),
                onTap: () => _selectActivity(activity),
              ),
            ),
          if (_selectedActivities.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionLabel(
              _selectedActivities.contains('Custom activity')
                  ? 'Custom activity details'
                  : 'Activity details (applies to all selected)',
            ),
            const SizedBox(height: 10),
            if (_selectedActivities.contains('Custom activity')) ...[
              _TextField(controller: _nameController, label: 'Activity name'),
              const SizedBox(height: 16),
              _SectionLabel('Category'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in _categories)
                    _Pill(
                      label: category,
                      selected: category == _category,
                      onTap: () => setState(() => _category = category),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _TextField(
                    controller: _amountController,
                    label: 'Amount (optional)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('Unit'),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _pickUnit,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_unit ?? 'Select unit'),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TextField(
              controller: _noteController,
              label: 'Note (optional)',
              maxLines: 3,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Save as a template'),
              value: _saveAsTemplate,
              onChanged: (value) => setState(() => _saveAsTemplate = value),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: FilledButton(
          onPressed: _aquariums.isEmpty ? null : _save,
          style: FilledButton.styleFrom(
            disabledBackgroundColor: VivariColors.secondary,
            disabledForegroundColor: VivariColors.textMuted,
          ),
          child: const Text('Save activity'),
        ),
      ),
    );
  }
}

class _UnitPicker extends StatefulWidget {
  const _UnitPicker();

  @override
  State<_UnitPicker> createState() => _UnitPickerState();
}

class _UnitPickerState extends State<_UnitPicker> {
  static const _units = {
    'Volume': ['ml', 'l'],
    'Mass': ['mg', 'g', 'kg'],
    'Count': ['drops', 'pumps', 'pieces', 'tablets', 'capsules', 'bags'],
    'Measures': ['teaspoons'],
  };
  final _customController = TextEditingController();
  String? _selected;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('Select unit', style: Theme.of(context).textTheme.titleMedium),
            for (final entry in _units.entries) ...[
              const SizedBox(height: 16),
              _SectionLabel(entry.key),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final unit in entry.value)
                    _Pill(
                      label: unit,
                      selected: _selected == unit,
                      onTap: () => setState(() => _selected = unit),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            const _SectionLabel('Custom unit'),
            const SizedBox(height: 8),
            TextField(
              controller: _customController,
              decoration: const InputDecoration(hintText: 'Enter a unit'),
              onChanged: (value) => setState(
                () =>
                    _selected = value.trim().isEmpty ? _selected : value.trim(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _selected == null
                  ? null
                  : () => Navigator.pop(context, _selected),
              child: const Text('Use unit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
  );
}

class _SelectCard extends StatelessWidget {
  const _SelectCard({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => VivariCard(
    padding: EdgeInsets.zero,
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: VivariColors.surface,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? VivariColors.primary : VivariColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: selected ? VivariColors.primary : VivariColors.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
  );
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(labelText: label),
  );
}
