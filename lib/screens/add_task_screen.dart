import 'package:flutter/material.dart';

import '../models/aquarium.dart';
import '../models/care_record.dart';
import '../theme/app_theme.dart';
import '../widgets/aquarium_multi_select_sheet.dart';
import '../widgets/vivari_card.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    required this.aquariums,
    required this.onCreated,
    super.key,
  });

  final List<Aquarium> aquariums;
  final ValueChanged<CareTask> onCreated;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static const _categories = [
    'Feed Fish',
    'Clean Glass',
    'Water Change',
    'Trim Plants',
    'Clean Filter',
    'Fertilize Tank',
    'Check Parameters',
    'Custom',
  ];
  static const _weekdays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final _titleController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final Set<Aquarium> _aquariums = {};
  String? _category;
  bool _recurring = false;
  TaskRecurrence _recurrence = TaskRecurrence.basic;
  String _recurrenceUnit = 'Weeks';
  int _interval = 1;
  int _weekday = DateTime.now().weekday % 7;
  final Set<int> _monthDays = {};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _selectCategory(String category) {
    setState(() {
      _category = category;
      if (category != 'Custom') _titleController.text = category;
    });
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (value != null) setState(() => _date = value);
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(context: context, initialTime: _time);
    if (value != null) setState(() => _time = value);
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

  void _createTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a task title to continue.')),
      );
      return;
    }
    if (_recurring &&
        _recurrence == TaskRecurrence.monthDays &&
        _monthDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose at least one day of the month.')),
      );
      return;
    }
    widget.onCreated(
      CareTask(
        title: title,
        category: _category ?? 'Custom',
        aquariumName: _aquariums.firstOrNull?.name ?? '',
        aquariumNames: _aquariums.map((aquarium) => aquarium.name).toList(),
        dueAt: DateTime(
          _date.year,
          _date.month,
          _date.day,
          _time.hour,
          _time.minute,
        ),
        recurrence: _recurring ? _recurrence : TaskRecurrence.none,
        recurrenceUnit: _recurrenceUnit,
        recurrenceInterval: _interval,
        weekdays: _recurrence == TaskRecurrence.weekdays
            ? {_weekday}
            : const {},
        monthDays: _recurrence == TaskRecurrence.monthDays
            ? Set<int>.of(_monthDays)
            : const {},
      ),
    );
    Navigator.of(context).pop();
  }

  String get _summary {
    if (_recurrence == TaskRecurrence.weekdays) {
      return 'Repeats every ${_weekdays[_weekday]}.';
    }
    if (_recurrence == TaskRecurrence.monthDays) {
      final days = _monthDays.toList()..sort();
      return days.isEmpty
          ? 'Choose at least one day of the month.'
          : 'Repeats on day${days.length == 1 ? '' : 's'} ${days.join(', ')} of each month.';
    }
    final every = _recurrence == TaskRecurrence.customInterval ? _interval : 1;
    final unit = _recurrence == TaskRecurrence.customInterval
        ? _recurrenceUnit.toLowerCase()
        : _recurrenceUnit.toLowerCase();
    return 'Repeats every ${every == 1 ? '' : '$every '}$unit.';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = MaterialLocalizations.of(context).formatFullDate(_date);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Task Details'),
        actions: [
          TextButton(onPressed: _createTask, child: const Text('Create Task')),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          const _SectionTitle('Task Category'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.45,
            children: [
              for (final category in _categories)
                _CategoryButton(
                  label: category,
                  selected: _category == category,
                  onTap: () => _selectCategory(category),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Task Title'),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Aquarium'),
          const SizedBox(height: 8),
          _AquariumCard(
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
          const SizedBox(height: 20),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Recurring Task'),
            subtitle: const Text('Task repeats automatically on a schedule'),
            value: _recurring,
            onChanged: (value) => setState(() => _recurring = value),
          ),
          const SizedBox(height: 8),
          if (_recurring)
            _RecurringEditor(
              selected: _recurrence,
              onSelected: (value) => setState(() => _recurrence = value),
              recurrenceUnit: _recurrenceUnit,
              onUnitSelected: (value) =>
                  setState(() => _recurrenceUnit = value),
              interval: _interval,
              onIntervalChanged: (value) => setState(() => _interval = value),
              dateLabel: dateLabel,
              time: _time,
              onDateTap: _pickDate,
              onTimeTap: _pickTime,
              summary: _summary,
              weekdays: _weekdays,
              weekday: _weekday,
              onWeekdaySelected: (value) => setState(() => _weekday = value),
              monthDays: _monthDays,
              onMonthDayTap: (value) => setState(() {
                if (!_monthDays.add(value)) _monthDays.remove(value);
              }),
            )
          else ...[
            const _SectionTitle('Date & Time'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DateTimeButton(
                    icon: Icons.calendar_today_outlined,
                    label: dateLabel,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 10),
                _DateTimeButton(
                  icon: Icons.access_time,
                  label: _time.format(context),
                  onTap: _pickTime,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RecurringEditor extends StatelessWidget {
  const _RecurringEditor({
    required this.selected,
    required this.onSelected,
    required this.recurrenceUnit,
    required this.onUnitSelected,
    required this.interval,
    required this.onIntervalChanged,
    required this.dateLabel,
    required this.time,
    required this.onDateTap,
    required this.onTimeTap,
    required this.summary,
    required this.weekdays,
    required this.weekday,
    required this.onWeekdaySelected,
    required this.monthDays,
    required this.onMonthDayTap,
  });

  final TaskRecurrence selected;
  final ValueChanged<TaskRecurrence> onSelected;
  final String recurrenceUnit;
  final ValueChanged<String> onUnitSelected;
  final int interval;
  final ValueChanged<int> onIntervalChanged;
  final String dateLabel;
  final TimeOfDay time;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;
  final String summary;
  final List<String> weekdays;
  final int weekday;
  final ValueChanged<int> onWeekdaySelected;
  final Set<int> monthDays;
  final ValueChanged<int> onMonthDayTap;

  static const _options = [
    (value: TaskRecurrence.basic, label: 'Basic'),
    (value: TaskRecurrence.customInterval, label: 'Custom Interval'),
    (value: TaskRecurrence.weekdays, label: 'Specific Weekdays'),
    (value: TaskRecurrence.monthDays, label: 'Specific Month Days'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in _options)
              ChoiceChip(
                label: Text(option.label),
                selected: selected == option.value,
                onSelected: (_) => onSelected(option.value),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (selected == TaskRecurrence.basic) ...[
          Wrap(
            spacing: 8,
            children: [
              for (final unit in _units)
                ChoiceChip(
                  label: Text(unit),
                  selected: recurrenceUnit == unit,
                  onSelected: (_) => onUnitSelected(unit),
                ),
            ],
          ),
        ] else if (selected == TaskRecurrence.customInterval) ...[
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text('Every'),
              SizedBox(
                width: 84,
                child: TextFormField(
                  initialValue: '$interval',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed > 0) onIntervalChanged(parsed);
                  },
                ),
              ),
              for (final unit in _units)
                ChoiceChip(
                  label: Text(unit.toLowerCase()),
                  selected: recurrenceUnit == unit,
                  onSelected: (_) => onUnitSelected(unit),
                ),
            ],
          ),
        ] else if (selected == TaskRecurrence.weekdays) ...[
          for (var index = 0; index < weekdays.length; index++)
            _WeekdayOption(
              title: weekdays[index],
              selected: weekday == index,
              onTap: () => onWeekdaySelected(index),
            ),
        ] else ...[
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
            children: [
              for (var day = 1; day <= 31; day++)
                _MonthDay(
                  day: day,
                  selected: monthDays.contains(day),
                  onTap: () => onMonthDayTap(day),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        const _SectionTitle('Start Date'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _DateTimeButton(
                icon: Icons.calendar_today_outlined,
                label: dateLabel,
                onTap: onDateTap,
              ),
            ),
            const SizedBox(width: 10),
            _DateTimeButton(
              icon: Icons.access_time,
              label: time.format(context),
              onTap: onTimeTap,
            ),
          ],
        ),
        const SizedBox(height: 12),
        VivariCard(
          child: Text(
            'Schedule Summary: $summary',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

const _units = ['Days', 'Weeks', 'Months'];

class _WeekdayOption extends StatelessWidget {
  const _WeekdayOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? VivariColors.primary : VivariColors.textMuted,
          ),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleMedium);
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      backgroundColor: selected ? VivariColors.primary : null,
      foregroundColor: selected ? VivariColors.background : null,
      side: BorderSide(
        color: selected ? VivariColors.primary : VivariColors.border,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(label, textAlign: TextAlign.center),
  );
}

class _AquariumCard extends StatelessWidget {
  const _AquariumCard({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => VivariCard(
    padding: EdgeInsets.zero,
    child: ListTile(
      leading: const Icon(Icons.water_outlined),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _DateTimeButton extends StatelessWidget {
  const _DateTimeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 18),
    label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
  );
}

class _MonthDay extends StatelessWidget {
  const _MonthDay({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? VivariColors.primary : VivariColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? VivariColors.primary : VivariColors.border,
        ),
      ),
      child: Text(
        '$day',
        style: TextStyle(
          color: selected ? VivariColors.background : VivariColors.textPrimary,
        ),
      ),
    ),
  );
}
