import 'package:flutter/gestures.dart'
    show GestureBinding, PointerScrollEvent, PointerSignalEvent;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/aquarium.dart';
import '../models/inhabitant.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import 'add_aquarium_screen.dart';
import 'add_inhabitant_screen.dart';

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
  InhabitantCategory? _selectedCategory;

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

  List<String> get _categories => [
    'Fish',
    'Inverts',
    'Plants',
    if (_aquarium.type == AquariumType.saltwater) 'Corals',
  ];

  int _categoryQuantity(String category) => _aquarium.inhabitants
      .where((inhabitant) => inhabitant.entry.category.label == category)
      .fold(0, (total, inhabitant) => total + inhabitant.quantity);

  List<AquariumInhabitant> get _visibleInhabitants => _selectedCategory == null
      ? _aquarium.inhabitants
      : _aquarium.inhabitants
            .where(
              (inhabitant) => inhabitant.entry.category == _selectedCategory,
            )
            .toList();

  void _saveInhabitants(List<AquariumInhabitant> inhabitants) {
    final previous = _aquarium;
    final updated = _aquarium.copyWith(inhabitants: inhabitants);
    setState(() => _aquarium = updated);
    widget.onAquariumUpdated?.call(previous, updated);
  }

  Future<void> _addInhabitants() async {
    final added = await Navigator.of(context).push<List<AquariumInhabitant>>(
      MaterialPageRoute<List<AquariumInhabitant>>(
        builder: (_) => AddInhabitantScreen(waterType: _aquarium.type),
      ),
    );
    if (!mounted || added == null || added.isEmpty) return;

    final inhabitants = [..._aquarium.inhabitants];
    for (final inhabitant in added) {
      final index = inhabitants.indexWhere(
        (existing) => existing.entry.id == inhabitant.entry.id,
      );
      if (index == -1) {
        inhabitants.add(inhabitant);
      } else {
        inhabitants[index] = inhabitants[index].copyWith(
          quantity: inhabitants[index].quantity + inhabitant.quantity,
        );
      }
    }
    _saveInhabitants(inhabitants);
  }

  Future<void> _editInhabitant(AquariumInhabitant inhabitant) async {
    var quantity = inhabitant.quantity;
    final action = await showDialog<_InhabitantEditAction>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: VivariColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: VivariColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Inhabitant',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.medium),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: VivariColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: VivariColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inhabitant.entry.commonName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        inhabitant.entry.scientificName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: VivariColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                Text('Quantity', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.small),
                Container(
                  decoration: BoxDecoration(
                    color: VivariColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: VivariColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: 'Decrease quantity',
                        onPressed: quantity > 1
                            ? () => setDialogState(() => quantity--)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$quantity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        tooltip: 'Increase quantity',
                        onPressed: () => setDialogState(() => quantity++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(
                      dialogContext,
                    ).pop(_InhabitantEditAction.save(quantity)),
                    child: const Text('Save Changes'),
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(
                      dialogContext,
                    ).pop(const _InhabitantEditAction.remove()),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Remove'),
                    style: TextButton.styleFrom(
                      foregroundColor: VivariColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted || action == null) return;

    final inhabitants = [..._aquarium.inhabitants];
    final index = inhabitants.indexWhere(
      (entry) => entry.entry.id == inhabitant.entry.id,
    );
    if (index == -1) return;
    if (action.remove) {
      inhabitants.removeAt(index);
    } else {
      inhabitants[index] = inhabitants[index].copyWith(
        quantity: action.quantity,
      );
    }
    _saveInhabitants(inhabitants);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final inhabitants = _visibleInhabitants;
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
                        onPressed: _addInhabitants,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Inhabitant'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),
                  _CategoryScroller(
                    categories: categories,
                    selectedCategory: _selectedCategory?.label,
                    categoryQuantity: _categoryQuantity,
                    onSelectionChanged: (category) {
                      setState(() {
                        _selectedCategory = category == null
                            ? null
                            : InhabitantCategory.fromJson(category);
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  if (inhabitants.isEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: EmptyState(
                        title: _aquarium.inhabitants.isEmpty
                            ? 'No inhabitants yet'
                            : 'No ${_selectedCategory!.label.toLowerCase()} yet',
                        message: _aquarium.inhabitants.isEmpty
                            ? 'Your aquarium is ready for its first inhabitants.'
                            : 'Add an inhabitant in this category to see it here.',
                        icon: Icons.bubble_chart_outlined,
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth =
                            (constraints.maxWidth - AppSpacing.small) / 2;
                        return Wrap(
                          spacing: AppSpacing.small,
                          runSpacing: AppSpacing.small,
                          children: [
                            for (final inhabitant in inhabitants)
                              SizedBox(
                                width: cardWidth,
                                child: _InhabitantCard(
                                  inhabitant: inhabitant,
                                  onTap: () => _editInhabitant(inhabitant),
                                ),
                              ),
                          ],
                        );
                      },
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
  const _CategoryScroller({
    required this.categories,
    required this.categoryQuantity,
    required this.onSelectionChanged,
    this.selectedCategory,
  });

  final List<String> categories;
  final String? selectedCategory;
  final int Function(String category) categoryQuantity;
  final ValueChanged<String?> onSelectionChanged;

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
                  for (
                    var index = 0;
                    index < widget.categories.length;
                    index++
                  ) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.small),
                    _CategoryChip(
                      label: widget.categories[index],
                      quantity: widget.categoryQuantity(
                        widget.categories[index],
                      ),
                      selected:
                          widget.selectedCategory == widget.categories[index],
                      onTap: () => widget.onSelectionChanged(
                        widget.selectedCategory == widget.categories[index]
                            ? null
                            : widget.categories[index],
                      ),
                    ),
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
  const _CategoryChip({
    required this.label,
    required this.quantity,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int quantity;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? VivariColors.background
        : VivariColors.textMuted;
    return Material(
      color: selected ? VivariColors.primary : VivariColors.secondary,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? VivariColors.primary : VivariColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label == 'Fish')
                _FishIcon(color: foreground)
              else
                Icon(_iconForCategory(label), size: 15, color: foreground),
              const SizedBox(width: AppSpacing.small),
              Text(
                '$label  ($quantity)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: selected
                      ? VivariColors.background
                      : VivariColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
  const _FishIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 15,
    height: 15,
    child: CustomPaint(painter: _FishIconPainter(color)),
  );
}

class _FishIconPainter extends CustomPainter {
  const _FishIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
        Paint()..color = color,
      );
  }

  @override
  bool shouldRepaint(covariant _FishIconPainter oldDelegate) => false;
}

class _InhabitantCard extends StatelessWidget {
  const _InhabitantCard({required this.inhabitant, required this.onTap});

  final AquariumInhabitant inhabitant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: VivariColors.secondary,
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: VivariColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Text(
                inhabitant.entry.commonName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (inhabitant.quantity > 1) ...[
              const SizedBox(width: AppSpacing.small),
              Text(
                'x${inhabitant.quantity}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _InhabitantEditAction {
  const _InhabitantEditAction.save(this.quantity) : remove = false;
  const _InhabitantEditAction.remove() : quantity = 0, remove = true;

  final int quantity;
  final bool remove;
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
