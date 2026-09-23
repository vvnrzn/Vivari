import 'package:flutter/material.dart';

import 'vivari_card.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.label,
    required this.value,
    super.key,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = VivariCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: _isNumeric(value)
                ? Theme.of(context).textTheme.displaySmall
                : Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }

  bool _isNumeric(String text) => double.tryParse(text) != null;
}
