import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/summary_card.dart';
import '../widgets/vivari_bottom_navigation.dart';
import '../widgets/vivari_card.dart';
import 'care_screen.dart';
import 'parameters_screen.dart';
import 'placeholder_screen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  void _openCare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const CareScreen()),
    );
  }

  void _openParameters(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ParametersScreen()),
    );
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
              const Expanded(
                child: SummaryCard(label: 'Total Aquariums', value: '0'),
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
                onPressed: () => _openPlaceholder(context, 'Add/Edit Aquarium'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Aquarium'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          const EmptyState(
            title: 'No aquariums yet',
            message: 'Add your first aquarium to get started.',
            icon: Icons.water_outlined,
          ),
        ],
      ),
      bottomNavigationBar: VivariBottomNavigation(
        currentIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) {
            _openParameters(context);
          } else if (index == 2) {
            _openCare(context);
          }
        },
      ),
    );
  }
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
