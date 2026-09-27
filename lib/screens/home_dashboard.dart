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
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 3,
                    top: 10,
                    child: _VivariBubble(size: 10),
                  ),
                  Positioned(
                    left: 14,
                    top: 2,
                    child: _VivariBubble(size: 7),
                  ),
                  Positioned(
                    left: 16,
                    top: 17,
                    child: _VivariBubble(size: 6),
                  ),
                ],
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

class _VivariBubble extends StatelessWidget {
  const _VivariBubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: VivariColors.primary,
        shape: BoxShape.circle,
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
                        child: const Center(
                          child: CustomPaint(
                            size: Size(56, 42),
                            painter: _AquariumPlaceholderPainter(),
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
                    if (aquarium.pendingTasks > 0)
                      Positioned(
                        top: AppSpacing.small,
                        right: AppSpacing.small,
                        child: _Badge(
                          label: '${aquarium.pendingTasks} pending',
                          color: VivariColors.warning,
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

class _AquariumPlaceholderPainter extends CustomPainter {
  const _AquariumPlaceholderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 240;
    final scaleY = size.height / 180;
    canvas.scale(scaleX, scaleY);
    final paint = Paint()
      ..color = VivariColors.textMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final bowl = Path()
      ..moveTo(60, 10)
      ..lineTo(180, 10)
      ..cubicTo(202, 32, 220, 61, 220, 96)
      ..cubicTo(220, 135, 197, 163, 165, 179)
      ..lineTo(75, 179)
      ..cubicTo(43, 163, 20, 135, 20, 96)
      ..cubicTo(20, 61, 38, 32, 60, 10)
      ..moveTo(30, 43)
      ..cubicTo(66, 62, 95, 70, 120, 62)
      ..cubicTo(153, 50, 180, 38, 210, 48)
      ..moveTo(56, 151)
      ..lineTo(184, 151);
    canvas.drawPath(bowl, paint);

    final fish = Path()
      ..moveTo(70, 103)
      ..cubicTo(85, 88, 98, 86, 112, 99)
      ..cubicTo(128, 87, 143, 84, 160, 89)
      ..cubicTo(177, 94, 188, 103, 194, 112)
      ..cubicTo(188, 124, 177, 134, 160, 138)
      ..cubicTo(143, 143, 128, 138, 112, 126)
      ..cubicTo(98, 139, 85, 136, 70, 122)
      ..cubicTo(79, 117, 79, 108, 70, 103)
      ..moveTo(161, 112)
      ..lineTo(161, 112);
    canvas.drawPath(fish, paint);
    canvas.drawCircle(
      const Offset(163, 111),
      2,
      Paint()..color = VivariColors.textMuted,
    );
  }

  @override
  bool shouldRepaint(covariant _AquariumPlaceholderPainter oldDelegate) =>
      false;
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
