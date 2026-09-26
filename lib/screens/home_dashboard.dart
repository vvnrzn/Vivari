import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/aquarium.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/summary_card.dart';
import '../widgets/vivari_card.dart';
import 'add_aquarium_screen.dart';
import 'aquarium_details_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({required this.onSelectTab, super.key});

  final ValueChanged<int> onSelectTab;

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final List<Aquarium> _aquariums = [];

  Future<void> _addAquarium(BuildContext context) async {
    final aquarium = await Navigator.push<Aquarium>(
      context,
      MaterialPageRoute<Aquarium>(builder: (_) => const AddAquariumScreen()),
    );
    if (aquarium != null && mounted) {
      setState(() => _aquariums.add(aquarium));
    }
  }

  void _openAquarium(BuildContext context, Aquarium aquarium) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AquariumDetailsScreen(aquarium: aquarium),
      ),
    );
  }

  void _openCare(BuildContext context) {
    widget.onSelectTab(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Vivari')),
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
                  value: '${_aquariums.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              const Expanded(
                child: SummaryCard(label: 'Total Inhabitants', value: '0'),
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
                  ),
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
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.medium),
                      child: _SummaryValue(
                        label: 'Last Water Change',
                        value: 'No records yet',
                      ),
                    ),
                  ),
                  Container(width: 1, color: VivariColors.secondary),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.medium),
                      child: _SummaryValue(
                        label: 'Last Dosing',
                        value: 'No records yet',
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
          if (_aquariums.isEmpty)
            const EmptyState(
              title: 'No aquariums yet',
              message: 'Add your first aquarium to get started.',
              icon: Icons.water_outlined,
            )
          else
            ..._aquariums.map(
              (aquarium) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.small),
                child: _AquariumCard(
                  aquarium: aquarium,
                  onTap: () => _openAquarium(context, aquarium),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

  class _AquariumCard extends StatelessWidget {
    const _AquariumCard({required this.aquarium, required this.onTap});

    final Aquarium aquarium;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: VivariCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aquarium.name,
                      style: GoogleFonts.spaceGrotesk(
                        color: VivariColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Wrap(
                      spacing: AppSpacing.medium,
                      runSpacing: AppSpacing.small,
                      children: [
                        _AquariumMetadata(
                          icon: Icons.schedule,
                          label: '${_ageSince(aquarium.createdAt)} ago',
                        ),
                        _AquariumMetadata(
                          icon: Icons.waves_outlined,
                          label:
                              '${_formatVolume(aquarium.volume)} ${aquarium.volumeUnit}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _Badge(
                    label: aquarium.type.label,
                    color: VivariColors.primary,
                  ),
                  if (aquarium.pendingTasks > 0) ...[
                    const SizedBox(height: AppSpacing.small),
                    _Badge(
                      label: '${aquarium.pendingTasks} pending',
                      color: VivariColors.warning,
                    ),
                  ],
                ],
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
    const _Badge({required this.label, required this.color});

    final String label;
    final Color color;

    @override
    Widget build(BuildContext context) {
      return Container(
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
    }
  }

  String _formatVolume(double volume) =>
      volume == volume.roundToDouble()
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
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: _isDataValue(value)
              ? Theme.of(context).textTheme.displaySmall
              : Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  bool _isDataValue(String text) {
    return text != 'No tasks for today' && text != 'No records yet';
  }
}
