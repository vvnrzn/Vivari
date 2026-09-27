import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import 'placeholder_screen.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  String _selectedAquarium = 'All aquariums';

  void _openView(String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _CareViewScreen(title: title)),
    );
  }

  void _openAddTask() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlaceholderScreen(title: 'Add Task'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VivariColors.background,
      floatingActionButton: _AddTaskButton(onPressed: _openAddTask),
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
            const SizedBox(height: AppSpacing.large),
            _AquariumFilter(
              value: _selectedAquarium,
              onChanged: (value) => setState(() => _selectedAquarium = value),
            ),
            const SizedBox(height: AppSpacing.large),
            Text(
              'View Options',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            _CareViewOption(
              title: 'List',
              subtitle: 'Overdue, due today, and upcoming tasks',
              icon: Icons.checklist_outlined,
              onTap: () => _openView('List'),
            ),
            _CareViewOption(
              title: 'Week',
              subtitle: 'Tasks organized by day',
              icon: Icons.view_week_outlined,
              onTap: () => _openView('Week'),
            ),
            _CareViewOption(
              title: 'Month',
              subtitle: 'Monthly task schedule',
              icon: Icons.calendar_month_outlined,
              onTap: () => _openView('Month'),
            ),
            _CareViewOption(
              title: 'History',
              subtitle: 'Completed care tasks',
              icon: Icons.history,
              onTap: () => _openView('History'),
            ),
            const SizedBox(height: AppSpacing.large),
            Text(
              'Task Sections',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            const _TaskSection(title: 'Overdue'),
            const _TaskSection(title: 'Due Today'),
            const _TaskSection(title: 'Upcoming'),
          ],
        ),
      ),
    );
  }
}

class _CareViewScreen extends StatefulWidget {
  const _CareViewScreen({required this.title});

  final String title;

  @override
  State<_CareViewScreen> createState() => _CareViewScreenState();
}

class _CareViewScreenState extends State<_CareViewScreen> {
  String _selectedAquarium = 'All aquariums';

  void _openAddTask() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlaceholderScreen(title: 'Add Task'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VivariColors.background,
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: _AddTaskButton(onPressed: _openAddTask),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.medium,
            AppSpacing.screen,
            96,
          ),
          children: [
            _AquariumFilter(
              value: _selectedAquarium,
              onChanged: (value) => setState(() => _selectedAquarium = value),
            ),
            const SizedBox(height: AppSpacing.large),
            EmptyState(
              title: widget.title == 'History'
                  ? 'No completed tasks'
                  : 'No tasks scheduled',
              message: widget.title == 'History'
                  ? 'Completed care tasks will appear here.'
                  : 'Tasks for this view will appear here.',
              icon: widget.title == 'History'
                  ? Icons.history
                  : Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }
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
        const SizedBox(height: 4),
        Text('Care', style: textTheme.headlineSmall),
      ],
    );
  }
}

class _AquariumFilter extends StatelessWidget {
  const _AquariumFilter({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aquarium Filter', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.small),
        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(
            filled: true,
            fillColor: VivariColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: VivariColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: VivariColors.border),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          dropdownColor: VivariColors.surface,
          items: const [
            DropdownMenuItem(
              value: 'All aquariums',
              child: Text('All aquariums'),
            ),
            DropdownMenuItem(value: 'Unassigned', child: Text('Unassigned')),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}

class _CareViewOption extends StatelessWidget {
  const _CareViewOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: ListTile(
        leading: Icon(icon, color: VivariColors.primary),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.small),
            Text('No tasks', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  const _AddTaskButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Add Task',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const SizedBox(
        width: 20,
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: VivariColors.background,
                  borderRadius: BorderRadius.all(Radius.circular(1.5)),
                ),
              ),
            ),
            SizedBox(
              width: 3,
              height: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: VivariColors.background,
                  borderRadius: BorderRadius.all(Radius.circular(1.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
