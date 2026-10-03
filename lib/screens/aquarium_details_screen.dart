import 'package:flutter/gestures.dart'
    show GestureBinding, PointerScrollEvent, PointerSignalEvent;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/aquarium.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import 'add_aquarium_screen.dart';

class AquariumDetailsScreen extends StatefulWidget {
  const AquariumDetailsScreen({
    required this.aquarium,
    this.onAquariumUpdated,
    this.onAquariumDeleted,
    super.key,
  });

  final Aquarium aquarium;
  final void Function(Aquarium previous, Aquarium updated)? onAquariumUpdated;
  final VoidCallback? onAquariumDeleted;

  @override
  State<AquariumDetailsScreen> createState() => _AquariumDetailsScreenState();
}

class _AquariumDetailsScreenState extends State<AquariumDetailsScreen> {
  late Aquarium _aquarium = widget.aquarium;

  @override
  void didUpdateWidget(covariant AquariumDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.aquarium, widget.aquarium)) {
      _aquarium = widget.aquarium;
    }
  }

  Future<void> _editAquarium() async {
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute<Object?>(
        builder: (_) => AddAquariumScreen(initialAquarium: _aquarium),
      ),
    );
    if (!mounted) return;

    if (result is Aquarium) {
      final previousAquarium = _aquarium;
      setState(() => _aquarium = result);
      widget.onAquariumUpdated?.call(previousAquarium, result);
    } else if (result == true) {
      widget.onAquariumDeleted?.call();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Fish',
      'Inverts',
      'Plants',
      if (_aquarium.type == AquariumType.saltwater) 'Corals',
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _AquariumHero(
              aquarium: _aquarium,
              onBack: () => Navigator.of(context).pop(),
              onEdit: _editAquarium,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.large,
                AppSpacing.screen,
                AppSpacing.large,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.small),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'INHABITANTS',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.7,
                              ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Inhabitant'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _CategoryScroller(categories: categories),
                  const SizedBox(height: AppSpacing.medium),
                  const SizedBox(
                    width: double.infinity,
                    child: EmptyState(
                      title: 'No inhabitants yet',
                      message:
                          'Your aquarium is ready for its first inhabitants.',
                      icon: Icons.bubble_chart_outlined,
                    ),
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

class _CategoryScroller extends StatefulWidget {
  const _CategoryScroller({required this.categories});

  final List<String> categories;

  @override
  State<_CategoryScroller> createState() => _CategoryScrollerState();
}

class _CategoryScrollerState extends State<_CategoryScroller> {
  final _scrollController = ScrollController();

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    _scrollController.jumpTo(
      (position.pixels + delta).clamp(0.0, position.maxScrollExtent),
    );
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      GestureBinding.instance.pointerSignalResolver.register(event, (event) {
        final scrollEvent = event as PointerScrollEvent;
        final delta = scrollEvent.scrollDelta.dx != 0
            ? scrollEvent.scrollDelta.dx
            : scrollEvent.scrollDelta.dy;
        _scrollBy(delta);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Listener(
          onPointerSignal: _handlePointerSignal,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) => _scrollBy(-details.delta.dx),
            child: SingleChildScrollView(
              key: const ValueKey('inhabitant-category-scroll-view'),
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0;
                      index < widget.categories.length;
                      index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.small),
                    _CategoryChip(label: widget.categories[index]),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AquariumHero extends StatelessWidget {
  const _AquariumHero({
    required this.aquarium,
    required this.onBack,
    required this.onEdit,
  });

  final Aquarium aquarium;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 248,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (aquarium.photoBytes != null)
            Image.memory(aquarium.photoBytes!, fit: BoxFit.cover)
          else
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF344E62),
                    Color(0xFF172526),
                    Color(0xFF4F3971),
                  ],
                ),
              ),
              child: Center(
                child: Icon(Icons.water, size: 76, color: Color(0x557DD7CF)),
              ),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.12, 1],
                colors: [Color(0x22000000), Color(0xE60E1718)],
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: AppSpacing.screen,
            right: AppSpacing.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onBack,
                  tooltip: 'Back',
                  style: IconButton.styleFrom(
                    backgroundColor: VivariColors.surface.withValues(
                      alpha: 0.9,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.settings_outlined, size: 18),
                  label: const Text('Edit Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: VivariColors.textPrimary,
                    backgroundColor: VivariColors.surface.withValues(
                      alpha: 0.92,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                      vertical: AppSpacing.small,
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.screen,
            right: AppSpacing.screen,
            bottom: AppSpacing.medium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${aquarium.type.label.toUpperCase()}  ·  '
                  '${_formatVolume(aquarium.volume)} ${aquarium.volumeUnit}  ·  '
                  '${_ageSince(aquarium.createdAt)} old',
                  style: GoogleFonts.dmMono(
                    color: VivariColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  aquarium.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.spaceGrotesk(
                    color: VivariColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: VivariColors.secondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: VivariColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label == 'Fish')
            const _FishIcon()
          else
            Icon(
              _iconForCategory(label),
              size: 15,
              color: VivariColors.textMuted,
            ),
          const SizedBox(width: AppSpacing.small),
          Text(
            '$label  (0)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: VivariColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String category) => switch (category) {
    'Fish' => Icons.set_meal_outlined,
    'Inverts' => Icons.bug_report_outlined,
    'Plants' => Icons.eco_outlined,
    _ => Icons.water_drop_outlined,
  };
}

class _FishIcon extends StatelessWidget {
  const _FishIcon();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 15,
    height: 15,
    child: CustomPaint(painter: _FishIconPainter()),
  );
}

class _FishIconPainter extends CustomPainter {
  const _FishIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = VivariColors.textMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final body = Path()
      ..moveTo(size.width * 0.12, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.05,
        size.width * 0.82,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.95,
        size.width * 0.12,
        size.height * 0.5,
      );
    canvas
      ..drawPath(body, paint)
      ..drawLine(
        Offset(size.width * 0.82, size.height * 0.5),
        Offset(size.width * 0.98, size.height * 0.28),
        paint,
      )
      ..drawLine(
        Offset(size.width * 0.82, size.height * 0.5),
        Offset(size.width * 0.98, size.height * 0.72),
        paint,
      )
      ..drawCircle(
        Offset(size.width * 0.34, size.height * 0.43),
        0.7,
        Paint()..color = VivariColors.textMuted,
      );
  }

  @override
  bool shouldRepaint(covariant _FishIconPainter oldDelegate) => false;
}

String _formatVolume(double volume) => volume == volume.roundToDouble()
    ? volume.toInt().toString()
    : volume.toString();

String _ageSince(DateTime date) {
  final days = DateUtils.dateOnly(
    DateTime.now(),
  ).difference(DateUtils.dateOnly(date)).inDays;
  if (days < 0) return '0d';
  if (days >= 365) return '${days ~/ 365}y';
  if (days >= 30) return '${days ~/ 30}mo';
  return '${days}d';
}
