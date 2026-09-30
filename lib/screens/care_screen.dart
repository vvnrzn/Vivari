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
    this.activities = const [],
    this.taskCompletions = const [],
    this.templates = const [],
    this.onTaskCreated,
    this.onActivityLogged,
    this.onTaskCompletionChanged,
    super.key,
  });

  final List<Aquarium> aquariums;
  final List<CareTask> tasks;
  final List<CareActivity> activities;
  final List<CareTaskCompletion> taskCompletions;
  final List<ActivityTemplate> templates;
  final ValueChanged<CareTask>? onTaskCreated;
  final void Function(CareActivity activity, ActivityTemplate? template)?
  onActivityLogged;
  final void Function(CareTask task, DateTime scheduledDate, bool completed)?
  onTaskCompletionChanged;

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  _CareView _selectedView = _CareView.list;
  String? _selectedAquariumName;

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
    final aquariumName = _selectedAquariumName;
    final tasks = aquariumName == null
        ? widget.tasks
        : widget.tasks
              .where((task) => task.aquariumName == aquariumName)
              .toList();
    final activities = aquariumName == null
        ? widget.activities
        : widget.activities
              .where((activity) => activity.aquariumName == aquariumName)
              .toList();
    final completions = aquariumName == null
        ? widget.taskCompletions
        : widget.taskCompletions
              .where(
                (completion) =>
                    completion.task.aquariumName == aquariumName,
              )
              .toList();

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
            _AquariumFilter(
              aquariums: widget.aquariums,
              selectedName: _selectedAquariumName,
              onSelected: (name) =>
                  setState(() => _selectedAquariumName = name),
            ),
            const SizedBox(height: AppSpacing.large),
            switch (_selectedView) {
              _CareView.list => _ListViewContent(
                tasks: tasks,
                completions: completions,
                onCompletionChanged: widget.onTaskCompletionChanged,
              ),
              _CareView.week => _WeekViewContent(
                tasks: tasks,
                completions: completions,
                onCompletionChanged: widget.onTaskCompletionChanged,
              ),
              _CareView.month => _MonthViewContent(tasks: tasks),
              _CareView.history => _HistoryViewContent(
                activities: activities,
                completions: completions,
                onCompletionChanged: widget.onTaskCompletionChanged,
              ),
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
  const _AquariumFilter({
    required this.aquariums,
    required this.selectedName,
    required this.onSelected,
  });

  final List<Aquarium> aquariums;
  final String? selectedName;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Aquarium Filter',
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _CompactPill(
                label: 'All Tanks',
                selected: selectedName == null,
                onPressed: () => onSelected(null),
              ),
              for (final aquarium in aquariums) ...[
                const SizedBox(width: 8),
                _CompactPill(
                  label: aquarium.name,
                  selected: selectedName == aquarium.name,
                  onPressed: () => onSelected(aquarium.name),
                ),
              ],
            ],
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

typedef _TaskOccurrence = ({CareTask task, DateTime date});

class _ListViewContent extends StatelessWidget {
  const _ListViewContent({
    required this.tasks,
    required this.completions,
    required this.onCompletionChanged,
  });

  final List<CareTask> tasks;
  final List<CareTaskCompletion> completions;
  final void Function(CareTask task, DateTime date, bool completed)?
  onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final overdue = tasks
        .where(
          (task) =>
              task.recurrence == TaskRecurrence.none &&
              DateUtils.dateOnly(task.dueAt).isBefore(today),
        )
        .map((task) => (task: task, date: DateUtils.dateOnly(task.dueAt)))
        .toList();
    final dueToday = tasks
        .where((task) => task.isDueOn(today))
        .map((task) => (task: task, date: today))
        .toList();
    final upcoming = <_TaskOccurrence>[];
    for (var offset = 1; offset <= 7; offset++) {
      final date = today.add(Duration(days: offset));
      for (final task in tasks.where((task) => task.isDueOn(date))) {
        upcoming.add((task: task, date: date));
      }
    }

    return Column(
      children: [
        _TaskSection(
          title: 'OVERDUE',
          occurrences: overdue,
          completions: completions,
          onCompletionChanged: onCompletionChanged,
          indicatorColor: VivariColors.error,
          titleColor: VivariColors.error,
        ),
        const SizedBox(height: AppSpacing.medium),
        _TaskSection(
          title: 'DUE TODAY',
          occurrences: dueToday,
          completions: completions,
          onCompletionChanged: onCompletionChanged,
          indicatorColor: VivariColors.warning,
        ),
        const SizedBox(height: AppSpacing.medium),
        _TaskSection(
          title: 'UPCOMING — NEXT 7 DAYS',
          occurrences: upcoming,
          completions: completions,
          onCompletionChanged: onCompletionChanged,
          indicatorColor: VivariColors.textMuted,
        ),
      ],
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.title,
    required this.occurrences,
    required this.completions,
    required this.onCompletionChanged,
    required this.indicatorColor,
    this.titleColor,
  });

  final String title;
  final List<_TaskOccurrence> occurrences;
  final List<CareTaskCompletion> completions;
  final void Function(CareTask task, DateTime date, bool completed)?
  onCompletionChanged;
  final Color indicatorColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${occurrences.length})',
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
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: VivariColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: VivariColors.border),
          ),
          child: occurrences.isEmpty
              ? Text('No tasks', style: textTheme.bodySmall)
              : Column(
                  children: [
                    for (final occurrence in occurrences)
                      _TaskCard(
                        task: occurrence.task,
                        date: occurrence.date,
                        completed: _isCompleted(
                          completions,
                          occurrence.task,
                          occurrence.date,
                        ),
                        onChanged: onCompletionChanged,
                        indicatorColor: indicatorColor,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

bool _isCompleted(
  List<CareTaskCompletion> completions,
  CareTask task,
  DateTime date,
) => completions.any(
  (completion) =>
      identical(completion.task, task) &&
      DateUtils.isSameDay(completion.scheduledDate, date),
);

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.date,
    required this.completed,
    required this.onChanged,
    required this.indicatorColor,
  });

  final CareTask task;
  final DateTime date;
  final bool completed;
  final void Function(CareTask task, DateTime date, bool completed)? onChanged;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    final dueAt = DateTime(
      date.year,
      date.month,
      date.day,
      task.dueAt.hour,
      task.dueAt.minute,
    );
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: IconButton(
        tooltip: completed ? 'Mark task incomplete' : 'Mark task complete',
        onPressed: onChanged == null
            ? null
            : () => onChanged!(task, date, !completed),
        icon: _TaskRadioIndicator(
          completed: completed,
          color: completed ? VivariColors.primary : indicatorColor,
        ),
      ),
      title: Text(
        task.title,
        style: completed
            ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: VivariColors.textMuted,
              )
            : null,
      ),
      subtitle: task.aquariumName.isEmpty ? null : Text(task.aquariumName),
      trailing: Text(
        MaterialLocalizations.of(
          context,
        ).formatTimeOfDay(TimeOfDay.fromDateTime(dueAt)),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _TaskRadioIndicator extends StatelessWidget {
  const _TaskRadioIndicator({required this.completed, required this.color});

  final bool completed;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 16,
    height: 16,
    child: DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
      child: completed
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            )
          : null,
    ),
  );
}

class _WeekViewContent extends StatelessWidget {
  const _WeekViewContent({
    required this.tasks,
    required this.completions,
    required this.onCompletionChanged,
  });

  final List<CareTask> tasks;
  final List<CareTaskCompletion> completions;
  final void Function(CareTask task, DateTime date, bool completed)?
  onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());

    return Column(
      children: [
        for (var offset = 0; offset < 7; offset++) ...[
          _WeekDay(
            date: today.add(Duration(days: offset)),
            isToday: offset == 0,
            tasks: tasks,
            completions: completions,
            onCompletionChanged: onCompletionChanged,
          ),
          if (offset < 6) const SizedBox(height: AppSpacing.small),
        ],
      ],
    );
  }
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({
    required this.date,
    required this.isToday,
    required this.tasks,
    required this.completions,
    required this.onCompletionChanged,
  });

  final DateTime date;
  final bool isToday;
  final List<CareTask> tasks;
  final List<CareTaskCompletion> completions;
  final void Function(CareTask task, DateTime date, bool completed)?
  onCompletionChanged;

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
    final dueTasks = tasks.where((task) => task.isDueOn(date)).toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: VivariColors.border),
      ),
      child: Column(
        children: [
          Row(
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
              if (dueTasks.isEmpty)
                Text(
                  '-',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
            ],
          ),
          for (final task in dueTasks)
            _TaskCard(
              task: task,
              date: date,
              completed: _isCompleted(completions, task, date),
              onChanged: onCompletionChanged,
              indicatorColor: isToday
                  ? VivariColors.warning
                  : VivariColors.textMuted,
            ),
        ],
      ),
    );
  }
}

class _MonthViewContent extends StatefulWidget {
  const _MonthViewContent({required this.tasks});

  final List<CareTask> tasks;

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
                  taskCount: widget.tasks
                      .where(
                        (task) => task.isDueOn(
                          DateTime(
                            _displayedMonth.year,
                            _displayedMonth.month,
                            day,
                          ),
                        ),
                      )
                      .length,
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
    required this.taskCount,
  });

  final int day;
  final bool selected;
  final int taskCount;

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
            borderRadius: BorderRadius.circular(9),
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
        if (taskCount > 0)
          SizedBox(
            height: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var dot = 0; dot < taskCount.clamp(0, 3); dot++) ...[
                  if (dot > 0) const SizedBox(width: 2),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: VivariColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                if (taskCount > 3) ...[
                  const SizedBox(width: 2),
                  Text(
                    '+${taskCount - 3}',
                    style: const TextStyle(
                      color: VivariColors.primary,
                      fontSize: 8,
                      height: 1,
                    ),
                  ),
                ],
              ],
            ),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}

class _HistoryViewContent extends StatelessWidget {
  const _HistoryViewContent({
    required this.activities,
    required this.completions,
    required this.onCompletionChanged,
  });

  final List<CareActivity> activities;
  final List<CareTaskCompletion> completions;
  final void Function(CareTask task, DateTime date, bool completed)?
  onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    final entries = <({DateTime date, Widget child})>[
      for (final activity in activities)
        (
          date: activity.loggedAt,
          child: _ActivityHistoryCard(activity: activity),
        ),
      for (final completion in completions)
        (
          date: completion.completedAt,
          child: _CompletedTaskHistoryCard(
            completion: completion,
            onCompletionChanged: onCompletionChanged,
          ),
        ),
    ]..sort((a, b) => b.date.compareTo(a.date));

    if (entries.isNotEmpty) {
      return Column(
        children: [
          for (final entry in entries) ...[
            entry.child,
            const SizedBox(height: AppSpacing.small),
          ],
        ],
      );
    }

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
            'No history yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Logged activities and completed care tasks will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ActivityHistoryCard extends StatelessWidget {
  const _ActivityHistoryCard({required this.activity});

  final CareActivity activity;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final details = [
      activity.category,
      if (activity.aquariumName.isNotEmpty) activity.aquariumName,
      localizations.formatShortDate(activity.loggedAt),
    ].join(' · ');

    return _HistoryCard(
      title: activity.name,
      subtitle: details,
      checked: true,
      indicatorColor: VivariColors.primary,
    );
  }
}

class _CompletedTaskHistoryCard extends StatelessWidget {
  const _CompletedTaskHistoryCard({
    required this.completion,
    required this.onCompletionChanged,
  });

  final CareTaskCompletion completion;
  final void Function(CareTask task, DateTime date, bool completed)?
  onCompletionChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final details = [
      completion.task.category,
      if (completion.task.aquariumName.isNotEmpty)
        completion.task.aquariumName,
      localizations.formatShortDate(completion.scheduledDate),
    ].join(' · ');

    return _HistoryCard(
      title: completion.task.title,
      subtitle: details,
      checked: true,
      indicatorColor: VivariColors.primary,
      onPressed: onCompletionChanged == null
          ? null
          : () => onCompletionChanged!(
              completion.task,
              completion.scheduledDate,
              false,
            ),
      tooltip: 'Mark task incomplete',
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.title,
    required this.subtitle,
    required this.checked,
    required this.indicatorColor,
    this.onPressed,
    this.tooltip,
  });

  final String title;
  final String subtitle;
  final bool checked;
  final Color indicatorColor;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: VivariColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: VivariColors.border),
    ),
    child: ListTile(
      leading: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: _TaskRadioIndicator(
          completed: checked,
          color: indicatorColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    ),
  );
}
