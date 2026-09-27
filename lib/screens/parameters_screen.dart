import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/vivari_add_button.dart';
import 'placeholder_screen.dart';

class ParametersScreen extends StatelessWidget {
  const ParametersScreen({super.key});

  void _openLogParameters(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlaceholderScreen(title: 'Log Parameters'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: VivariColors.background,
      floatingActionButton: VivariAddButton(
        onPressed: () => _openLogParameters(context),
        tooltip: 'Log Parameters',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text(
              'WATER QUALITY',
              style: textTheme.bodySmall?.copyWith(
                letterSpacing: 0.8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text('Parameters', style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'Parameters is ready to be built.',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
