import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/aquarium.dart';
import '../models/care_record.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/summary_card.dart';
import '../widgets/vivari_card.dart';
import 'add_aquarium_screen.dart';
import 'aquarium_details_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({
    required this.onSelectTab,
    required this.aquariums,
    required this.tasks,
    required this.activities,
    required this.onAquariumAdded,
    this.taskCompletions = const [],
    this.onOpenAquariumTasks,
    this.onAquariumUpdated,
    this.onAquariumDeleted,
    super.key,
  });

  final ValueChanged<int> onSelectTab;
  final List<Aquarium> aquariums;
  final List<CareTask> tasks;
  final List<CareActivity> activities;
  final List<CareTaskCompletion> taskCompletions;
  final ValueChanged<Aquarium> onAquariumAdded;
  final ValueChanged<Aquarium>? onOpenAquariumTasks;
  final void Function(Aquarium previous, Aquarium updated)? onAquariumUpdated;
  final ValueChanged<Aquarium>? onAquariumDeleted;

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int get _totalInhabitants => widget.aquariums.fold(
    0,
    (total, aquarium) =>
        total +
        aquarium.inhabitants.fold(
          0,
          (aquariumTotal, inhabitant) => aquariumTotal + inhabitant.quantity,
        ),
  );

  Future<void> _addAquarium(BuildContext context) async {
    final aquarium = await Navigator.push<Aquarium>(
      context,
      MaterialPageRoute<Aquarium>(builder: (_) => const AddAquariumScreen()),
    );
    if (aquarium != null && mounted) {
      widget.onAquariumAdded(aquarium);
    }
  }

  void _openAquarium(BuildContext context, Aquarium aquarium) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AquariumDetailsScreen(
          aquarium: aquarium,
          onAquariumUpdated: (previous, updated) =>
              widget.onAquariumUpdated?.call(previous, updated),
          onAquariumDeleted: () => widget.onAquariumDeleted?.call(aquarium),
        ),
      ),
    );
  }

  void _openCare(BuildContext context) {
    widget.onSelectTab(2);
  }

  void _openAquariumTasks(BuildContext context, Aquarium aquarium) {
    final callback = widget.onOpenAquariumTasks;
    if (callback != null) {
      callback(aquarium);
    } else {
      _openCare(context);
    }
  }

  CareActivity? _latestActivity(String name) {
    final matches = widget.activities.where(
      (activity) => activity.name == name,
    );
    if (matches.isEmpty) return null;
    return matches.reduce(
      (latest, activity) =>
          activity.loggedAt.isAfter(latest.loggedAt) ? activity : latest,
    );
  }

  int _pendingTaskCount(Aquarium aquarium) {
    return widget.tasks.where((task) {
      if (!task.isAssociatedWithAquarium(aquarium.name)) return false;
      if (task.recurrence != TaskRecurrence.none) return true;
      return !widget.taskCompletions.any(
        (completion) =>
            identical(completion.task, task) &&
            DateUtils.isSameDay(completion.scheduledDate, task.dueAt),
      );
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final dueTodayCount = widget.tasks
        .where((task) => task.isDueOn(DateUtils.dateOnly(DateTime.now())))
        .length;
    final lastWaterChange = _latestActivity('Changed water');
    final lastDosing = _latestActivity('Added product or fertilizer');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Vivari'),
            const SizedBox(width: 8),
            SizedBox(
              width: 28,
              height: 32,
              child: CustomPaint(
                size: const Size(28, 32),
                painter: const _VivariBubbleMarkPainter(
                  color: VivariColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          8,
          AppSpacing.screen,
          AppSpacing.large,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  label: 'Total Aquariums',
                  value: '${widget.aquariums.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: SummaryCard(
                  label: 'Total Inhabitants',
                  value: '$_totalInhabitants',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          InkWell(
            onTap: () => _openCare(context),
            borderRadius: BorderRadius.circular(16),
            child: VivariCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TASKS DUE TODAY',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(letterSpacing: 0.5),
                  ),
                  if (dueTodayCount == 0)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'No tasks for today',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _openCare(context),
                          child: const Text('VIEW ALL'),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$dueTodayCount',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _openCare(context),
                          child: const Text('VIEW ALL'),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          VivariCard(
            padding: EdgeInsets.zero,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      child: _SummaryValue(
                        label: 'Last Water Change',
                        activity: lastWaterChange,
                      ),
                    ),
                  ),
                  Container(width: 1, color: VivariColors.secondary),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      child: _SummaryValue(
                        label: 'Last Dosing',
                        activity: lastDosing,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MY AQUARIUMS',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton.icon(
                onPressed: () => _addAquarium(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Aquarium'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          if (widget.aquariums.isEmpty)
            const EmptyState(
              title: 'No aquariums yet',
              message: 'Add your first aquarium to get started.',
              icon: Icons.water_outlined,
            )
          else
            ...widget.aquariums.map(
              (aquarium) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.small),
                child: _AquariumCard(
                  aquarium: aquarium,
                  pendingTaskCount: _pendingTaskCount(aquarium),
                  onPendingTasksTap: () =>
                      _openAquariumTasks(context, aquarium),
                  onTap: () => _openAquarium(context, aquarium),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _activityDate(CareActivity? activity) {
  if (activity == null) return 'No records yet';
  final daysAgo = DateUtils.dateOnly(
    DateTime.now(),
  ).difference(DateUtils.dateOnly(activity.loggedAt)).inDays;
  if (daysAgo == 0) return 'Today';
  if (daysAgo == 1) return 'Yesterday';
  if (daysAgo > 0) return '$daysAgo days ago';
  if (daysAgo == -1) return 'Tomorrow';
  return 'In ${-daysAgo} days';
}

class _VivariBubbleMarkPainter extends CustomPainter {
  const _VivariBubbleMarkPainter({required this.color, this.outlined = false});

  final Color color;
  final bool outlined;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 28;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = outlined ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = 1.4 / scale;
    canvas
      ..drawCircle(const Offset(8, 15), 5, paint)
      ..drawCircle(const Offset(17.5, 5.5), 3.5, paint)
      ..drawCircle(const Offset(19, 20), 3, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _VivariBubbleMarkPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.outlined != outlined;
}

class _AquariumCard extends StatelessWidget {
  const _AquariumCard({
    required this.aquarium,
    required this.pendingTaskCount,
    required this.onPendingTasksTap,
    required this.onTap,
  });

  final Aquarium aquarium;
  final int pendingTaskCount;
  final VoidCallback onPendingTasksTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: VivariCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 2.65,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (aquarium.photoBytes != null)
                      Image.memory(aquarium.photoBytes!, fit: BoxFit.cover)
                    else
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              VivariColors.secondary,
                              VivariColors.surface,
                            ],
                          ),
                        ),
                        child: Center(
                          child: CustomPaint(
                            size: Size(56, 56),
                            painter: _VivariBubbleMarkPainter(
                              color: Colors.white,
                              outlined: true,
                            ),
                          ),
                        ),
                      ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.45, 1],
                          colors: [Colors.transparent, Color(0xCC0E1718)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.medium,
                      right: AppSpacing.medium,
                      bottom: AppSpacing.small,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              aquarium.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.spaceGrotesk(
                                color: VivariColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.small),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Row(
                children: [
                  _AquariumMetadata(
                    icon: Icons.schedule,
                    label: '${_ageSince(aquarium.createdAt)} ago',
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  _AquariumMetadata(
                    icon: Icons.waves_outlined,
                    label:
                        '${_formatVolume(aquarium.volume)} ${aquarium.volumeUnit}',
                  ),
                  const Spacer(),
                  if (pendingTaskCount > 0) ...[
                    _Badge(
                      key: const ValueKey('pending-task-badge'),
                      label: '$pendingTaskCount',
                      color: VivariColors.warning,
                      tooltip: 'View pending tasks for ${aquarium.name}',
                      onTap: onPendingTasksTap,
                    ),
                    const SizedBox(width: AppSpacing.small),
                  ],
                  _Badge(
                    label: aquarium.type.label,
                    color: VivariColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AquariumMetadata extends StatelessWidget {
  const _AquariumMetadata({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    super.key,
    required this.label,
    required this.color,
    this.tooltip,
    this.onTap,
  });

  final String label;
  final Color color;
  final String? tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    final interactiveBadge = onTap == null
        ? badge
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: badge,
          );
    return tooltip == null
        ? interactiveBadge
        : Tooltip(message: tooltip!, child: interactiveBadge);
  }
}

String _formatVolume(double volume) => volume == volume.roundToDouble()
    ? volume.toInt().toString()
    : volume.toString();

String _ageSince(DateTime date) {
  final now = DateTime.now();
  final days = now.difference(date).inDays;
  if (days >= 365) {
    final years = days ~/ 365;
    return '${years}y';
  }
  if (days >= 30) {
    final months = days ~/ 30;
    return '${months}mo';
  }
  return '${days < 0 ? 0 : days}d';
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.activity});

  final String label;
  final CareActivity? activity;

  @override
  Widget build(BuildContext context) {
    final amountValue = activity?.amount?.trim() ?? '';
    final unit = activity?.unit?.trim() ?? '';
    final amount = amountValue.isEmpty
        ? unit
        : unit.isEmpty
        ? amountValue
        : '$amountValue${unit == '%' ? '' : ' '}$unit';
    final aquariumName = activity?.aquariumName.trim() ?? '';
    final hasName = aquariumName.isNotEmpty;
    final hasAmount = amount.isNotEmpty;
    final caption = switch ((hasName, hasAmount)) {
      (true, true) => '$aquariumName · $amount',
      (true, false) => aquariumName,
      (false, true) => amount,
      (false, false) => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Text(
          _activityDate(activity),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 16,
          child: Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: GoogleFonts.dmSans(
              color: VivariColors.textMuted,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
