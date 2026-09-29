import 'package:flutter/material.dart';

import '../models/aquarium.dart';
import '../models/care_record.dart';
import '../theme/app_theme.dart';
import '../widgets/vivari_add_button.dart';
import 'add_task_screen.dart';
import 'log_activity_screen.dart';

enum _CareView { list, week, month, history }

class CareScreen extends StatefulWidget {
  const CareScreen({
    this.aquariums = const [],
    this.tasks = const [],
    this.templates = const [],
    this.onTaskCreated,
    this.onActivityLogged,
    super.key,
  });

  final List<Aquarium> aquariums;
  final List<CareTask> tasks;
  final List<ActivityTemplate> templates;
  final ValueChanged<CareTask>? onTaskCreated;
  final void Function(CareActivity activity, ActivityTemplate? template)?
  onActivityLogged;

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  _CareView _selectedView = _CareView.list;

  Future<void> _openAddOptions() async {
    final selection = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          children: [
            Text(
              'What would you like to add?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose whether you are recording something done or planning ahead.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            _AddOption(
              title: 'Log activity',
              description: 'Save something you did without creating a task.',
              icon: Icons.check_circle_outline,
              onTap: () => Navigator.pop(context, 'activity'),
            ),
            const SizedBox(height: 10),
            _AddOption(
              title: 'Add task',
              description: 'Plan something to do later.',
              icon: Icons.event_note_outlined,
              onTap: () => Navigator.pop(context, 'task'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || selection == null) return;

    if (selection == 'activity') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => LogActivityScreen(
            aquariums: widget.aquariums,
            templates: widget.templates,
            onSaved: (activity, template) =>
                widget.onActivityLogged?.call(activity, template),
          ),
        ),
      );
    } else {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => AddTaskScreen(
            aquariums: widget.aquariums,
            onCreated: (task) => widget.onTaskCreated?.call(task),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VivariColors.background,
      floatingActionButton: VivariAddButton(
        onPressed: _openAddOptions,
        tooltip: 'Add Task',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.medium,
            AppSpacing.screen,
            96,
          ),
          children: [
            const _CareHeader(),
            const SizedBox(height: AppSpacing.medium),
            _ViewSelector(
              value: _selectedView,
              onChanged: (view) => setState(() => _selectedView = view),
            ),
            const SizedBox(height: AppSpacing.small),
            const _AquariumFilter(),
            const SizedBox(height: AppSpacing.large),
            switch (_selectedView) {
              _CareView.list => _ListViewContent(tasks: widget.tasks),
              _CareView.week => const _WeekViewContent(),
              _CareView.month => const _MonthViewContent(),
              _CareView.history => const _HistoryViewContent(),
            },
          ],
        ),
      ),
    );
  }
}

class _AddOption extends StatelessWidget {
  const _AddOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: VivariColors.surface,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VivariColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: VivariColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    ),
  );
}

class _CareHeader extends StatelessWidget {
  const _CareHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCHEDULE',
          style: textTheme.bodySmall?.copyWith(
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text('Care', style: textTheme.headlineSmall),
      ],
    );
  }
}

class _ViewSelector extends StatelessWidget {
  const _ViewSelector({required this.value, required this.onChanged});

  final _CareView value;
  final ValueChanged<_CareView> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      (view: _CareView.list, label: 'List', icon: Icons.view_list_outlined),
      (view: _CareView.week, label: 'Week', icon: Icons.view_week_outlined),
      (
        view: _CareView.month,
        label: 'Month',
        icon: Icons.calendar_month_outlined,
      ),
      (view: _CareView.history, label: 'History', icon: Icons.history),
    ];

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final option in options) ...[
              _CompactPill(
                label: option.label,
                icon: option.icon,
                selected: value == option.view,
                onPressed: () => onChanged(option.view),
              ),
              if (option != options.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _AquariumFilter extends StatelessWidget {
  const _AquariumFilter();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Aquarium Filter',
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: const Row(
            children: [_CompactPill(label: 'All Tanks', selected: true)],
          ),
        ),
      ),
    );
  }
}

class _CompactPill extends StatelessWidget {
  const _CompactPill({
    required this.label,
    required this.selected,
    this.icon,
    this.onPressed,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? VivariColors.background
        : VivariColors.textMuted;

    return Material(
      color: selected ? VivariColors.primary : VivariColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? VivariColors.primary : VivariColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: foreground),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListViewContent extends StatelessWidget {
  const _ListViewContent({required this.tasks});

  final List<CareTask> tasks;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final dueToday = tasks.where((task) => task.isDueOn(today)).toList();
    final overdue = tasks
        .where(
          (task) =>
              !task.isDueOn(today) &&
              !task.dueAt.isAfter(DateTime.now()) &&
              task.recurrence == TaskRecurrence.none,
        )
        .toList();
    final upcoming = tasks
        .where(
          (task) =>
              task.dueAt.isAfter(today) &&
              task.dueAt.isBefore(today.add(const Duration(days: 8))),
        )
        .toList();

    return Column(
      children: [
        _TaskSection(
          title: 'OVERDUE',
          count: overdue.length,
          titleColor: VivariColors.error,
          tasks: overdue,
        ),
        SizedBox(height: AppSpacing.medium),
        _TaskSection(
          title: 'DUE TODAY',
          count: dueToday.length,
          tasks: dueToday,
        ),
        SizedBox(height: AppSpacing.medium),
        _TaskSection(
          title: 'UPCOMING — NEXT 7 DAYS',
          count: upcoming.length,
          tasks: upcoming,
        ),
      ],
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.title,
    required this.count,
    this.tasks = const [],
    this.titleColor,
  });

  final String title;
  final int count;
  final List<CareTask> tasks;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title ($count)',
          style: textTheme.labelSmall?.copyWith(
            color: titleColor ?? VivariColors.textMuted,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: VivariColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: VivariColors.border),
          ),
          child: tasks.isEmpty
              ? Text('No tasks', style: textTheme.bodySmall)
              : Column(
                  children: [
                    for (final task in tasks)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(task.title),
                        subtitle: task.aquariumName.isEmpty
                            ? null
                            : Text(task.aquariumName),
                        trailing: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatTimeOfDay(TimeOfDay.fromDateTime(task.dueAt)),
                          style: textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _WeekViewContent extends StatelessWidget {
  const _WeekViewContent();

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());

    return Column(
      children: [
        for (var offset = 0; offset < 7; offset++) ...[
          _WeekDay(
            date: today.add(Duration(days: offset)),
            isToday: offset == 0,
          ),
          if (offset < 6) const SizedBox(height: AppSpacing.small),
        ],
      ],
    );
  }
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({required this.date, required this.isToday});

  final DateTime date;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final weekday = switch (date.weekday) {
      DateTime.monday => 'Mon',
      DateTime.tuesday => 'Tue',
      DateTime.wednesday => 'Wed',
      DateTime.thursday => 'Thu',
      DateTime.friday => 'Fri',
      DateTime.saturday => 'Sat',
      _ => 'Sun',
    };
    final foreground = isToday
        ? VivariColors.background
        : VivariColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: VivariColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? VivariColors.primary : VivariColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${date.day}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              isToday ? 'Today' : weekday,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(
            '-',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MonthViewContent extends StatefulWidget {
  const _MonthViewContent();

  @override
  State<_MonthViewContent> createState() => _MonthViewContentState();
}

class _MonthViewContentState extends State<_MonthViewContent> {
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final DateTime _today = DateUtils.dateOnly(DateTime.now());
  late DateTime _displayedMonth = DateTime(_today.year, _today.month);

  void _changeMonth(int amount) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + amount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month).weekday % 7;
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VivariColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          Row(
            children: [
              for (final day in ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'])
                Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: VivariColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 2,
            childAspectRatio: 0.86,
            children: [
              for (var empty = 0; empty < firstWeekday; empty++)
                const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                _CalendarDay(
                  day: day,
                  selected:
                      _displayedMonth.year == _today.year &&
                      _displayedMonth.month == _today.month &&
                      day == _today.day,
                  hasTasks: false,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.selected,
    required this.hasTasks,
  });

  final int day;
  final bool selected;
  final bool hasTasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? VivariColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$day',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? VivariColors.background
                  : VivariColors.textPrimary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 4,
          height: 4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: hasTasks ? VivariColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryViewContent extends StatelessWidget {
  const _HistoryViewContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: VivariColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.history, color: VivariColors.primary, size: 28),
          const SizedBox(height: AppSpacing.small),
          Text(
            'No completed tasks',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Completed care tasks will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
