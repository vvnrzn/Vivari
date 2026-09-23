import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class VivariBottomNavigation extends StatelessWidget {
  const VivariBottomNavigation({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VivariColors.surface,
        border: Border.all(color: VivariColors.border),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.water_drop_outlined),
              selectedIcon: Icon(Icons.water_drop),
              label: 'Parameters',
            ),
            const NavigationDestination(
              icon: _FishbowlIcon(),
              selectedIcon: _FishbowlIcon(),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.checklist_outlined),
              selectedIcon: Icon(Icons.checklist),
              label: 'Care',
            ),
          ],
        ),
      ),
    );
  }
}

class _FishbowlIcon extends StatelessWidget {
  const _FishbowlIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _FishbowlPainter(
        IconTheme.of(context).color ?? VivariColors.textMuted,
      ),
    );
  }
}

class _FishbowlPainter extends CustomPainter {
  const _FishbowlPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final bowl = Path()
      ..moveTo(3, 7)
      ..lineTo(17, 7)
      ..lineTo(15.5, 15)
      ..quadraticBezierTo(10, 19, 4.5, 15)
      ..close();
    canvas.drawPath(bowl, paint);
    canvas.drawLine(const Offset(4, 5), const Offset(16, 5), paint);

    final fish = Path()
      ..moveTo(7, 11)
      ..quadraticBezierTo(10, 8.5, 13, 11)
      ..quadraticBezierTo(10, 13.5, 7, 11)
      ..moveTo(7, 11)
      ..lineTo(5.5, 9.5)
      ..moveTo(7, 11)
      ..lineTo(5.5, 12.5);
    canvas.drawPath(fish, paint);
    canvas.drawCircle(
      const Offset(11.2, 10.5),
      0.6,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_FishbowlPainter oldDelegate) =>
      oldDelegate.color != color;
}
