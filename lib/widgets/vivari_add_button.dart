import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class VivariAddButton extends StatelessWidget {
  const VivariAddButton({
    required this.onPressed,
    required this.tooltip,
    super.key,
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
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
