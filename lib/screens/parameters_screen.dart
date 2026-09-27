import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ParametersScreen extends StatelessWidget {
  const ParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: VivariColors.background,
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
