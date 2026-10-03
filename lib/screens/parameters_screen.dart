import 'package:flutter/material.dart';

import '../models/aquarium.dart';
import '../theme/app_theme.dart';
import '../widgets/vivari_add_button.dart';

enum ParameterStatus { withinRange, aboveRange, belowRange, noReading }

enum _ChartTimeframe { week, month }

class ParameterRange {
  const ParameterRange(this.minimum, this.maximum);

  final double minimum;
  final double maximum;

  String get formatted => '${_formatNumber(minimum)}–${_formatNumber(maximum)}';
}

class WaterParameter {
  const WaterParameter({
    required this.id,
    required this.name,
    required this.unit,
    required this.enabled,
    required this.freshwaterRange,
    required this.saltwaterRange,
  });

  final String id;
  final String name;
  final String unit;
  final bool enabled;
  final ParameterRange freshwaterRange;
  final ParameterRange saltwaterRange;

  ParameterRange rangeFor(AquariumType type) => switch (type) {
    AquariumType.freshwater => freshwaterRange,
    AquariumType.saltwater => saltwaterRange,
  };

  WaterParameter copyWith({
    bool? enabled,
    ParameterRange? freshwaterRange,
    ParameterRange? saltwaterRange,
  }) => WaterParameter(
    id: id,
    name: name,
    unit: unit,
    enabled: enabled ?? this.enabled,
    freshwaterRange: freshwaterRange ?? this.freshwaterRange,
    saltwaterRange: saltwaterRange ?? this.saltwaterRange,
  );
}

List<WaterParameter> _defaultParameters() => const [
  WaterParameter(
    id: 'temperature',
    name: 'Temperature',
    unit: '°C',
    enabled: true,
    freshwaterRange: ParameterRange(22, 28),
    saltwaterRange: ParameterRange(24, 27),
  ),
  WaterParameter(
    id: 'ammonia',
    name: 'Ammonia',
    unit: 'ppm',
    enabled: true,
    freshwaterRange: ParameterRange(0, 0.25),
    saltwaterRange: ParameterRange(0, 0.25),
  ),
  WaterParameter(
    id: 'nitrite',
    name: 'Nitrite',
    unit: 'ppm',
    enabled: true,
    freshwaterRange: ParameterRange(0, 0.1),
    saltwaterRange: ParameterRange(0, 0.1),
  ),
  WaterParameter(
    id: 'nitrate',
    name: 'Nitrate',
    unit: 'ppm',
    enabled: true,
    freshwaterRange: ParameterRange(0, 40),
    saltwaterRange: ParameterRange(0, 20),
  ),
  WaterParameter(
    id: 'ph',
    name: 'pH',
    unit: '',
    enabled: true,
    freshwaterRange: ParameterRange(6.5, 7.5),
    saltwaterRange: ParameterRange(8.1, 8.4),
  ),
  WaterParameter(
    id: 'salinity',
    name: 'Salinity',
    unit: 'ppt',
    enabled: true,
    freshwaterRange: ParameterRange(0, 0.5),
    saltwaterRange: ParameterRange(33, 35),
  ),
  WaterParameter(
    id: 'calcium',
    name: 'Calcium',
    unit: 'ppm',
    enabled: true,
    freshwaterRange: ParameterRange(20, 100),
    saltwaterRange: ParameterRange(380, 450),
  ),
  WaterParameter(
    id: 'alkalinity',
    name: 'Alkalinity',
    unit: 'dKH',
    enabled: true,
    freshwaterRange: ParameterRange(3, 8),
    saltwaterRange: ParameterRange(8, 12),
  ),
  WaterParameter(
    id: 'gh',
    name: 'GH',
    unit: 'dGH',
    enabled: false,
    freshwaterRange: ParameterRange(4, 12),
    saltwaterRange: ParameterRange(7, 12),
  ),
  WaterParameter(
    id: 'tds',
    name: 'TDS',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(50, 500),
    saltwaterRange: ParameterRange(30000, 40000),
  ),
  WaterParameter(
    id: 'conductivity',
    name: 'Conductivity',
    unit: 'µS/cm',
    enabled: false,
    freshwaterRange: ParameterRange(100, 800),
    saltwaterRange: ParameterRange(50000, 55000),
  ),
  WaterParameter(
    id: 'sg',
    name: 'SG',
    unit: '',
    enabled: false,
    freshwaterRange: ParameterRange(1, 1.001),
    saltwaterRange: ParameterRange(1.023, 1.026),
  ),
  WaterParameter(
    id: 'orp',
    name: 'ORP',
    unit: 'mV',
    enabled: false,
    freshwaterRange: ParameterRange(200, 400),
    saltwaterRange: ParameterRange(300, 450),
  ),
  WaterParameter(
    id: 'po4',
    name: 'PO4',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 1),
    saltwaterRange: ParameterRange(0, 0.1),
  ),
  WaterParameter(
    id: 'sio2',
    name: 'SiO2',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 2),
    saltwaterRange: ParameterRange(0, 1),
  ),
  WaterParameter(
    id: 'magnesium',
    name: 'Mg',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(5, 50),
    saltwaterRange: ParameterRange(1250, 1400),
  ),
  WaterParameter(
    id: 'potassium',
    name: 'K',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(5, 20),
    saltwaterRange: ParameterRange(380, 420),
  ),
  WaterParameter(
    id: 'iron',
    name: 'Fe',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 0.1),
    saltwaterRange: ParameterRange(0, 0.01),
  ),
  WaterParameter(
    id: 'copper',
    name: 'Cu',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 0.01),
    saltwaterRange: ParameterRange(0, 0.01),
  ),
  WaterParameter(
    id: 'zinc',
    name: 'Zn',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 0.05),
    saltwaterRange: ParameterRange(0, 0.05),
  ),
  WaterParameter(
    id: 'manganese',
    name: 'Mn',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 0.05),
    saltwaterRange: ParameterRange(0, 0.05),
  ),
  WaterParameter(
    id: 'boron',
    name: 'B',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 5),
    saltwaterRange: ParameterRange(4, 5),
  ),
  WaterParameter(
    id: 'molybdenum',
    name: 'Mo',
    unit: 'ppm',
    enabled: false,
    freshwaterRange: ParameterRange(0, 0.1),
    saltwaterRange: ParameterRange(0, 0.1),
  ),
];

class ParametersScreen extends StatefulWidget {
  const ParametersScreen({this.aquariums = const [], super.key});

  final List<Aquarium> aquariums;

  @override
  State<ParametersScreen> createState() => _ParametersScreenState();
}

class _ParametersScreenState extends State<ParametersScreen> {
  List<WaterParameter> _parameters = _defaultParameters();
  String? _selectedAquariumName;

  @override
  void initState() {
    super.initState();
    _selectedAquariumName = widget.aquariums.firstOrNull?.name;
  }

  @override
  void didUpdateWidget(covariant ParametersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.aquariums.any(
      (aquarium) => aquarium.name == _selectedAquariumName,
    )) {
      _selectedAquariumName = widget.aquariums.firstOrNull?.name;
    }
  }

  Aquarium? get _selectedAquarium {
    for (final aquarium in widget.aquariums) {
      if (aquarium.name == _selectedAquariumName) return aquarium;
    }
    return null;
  }

  Future<void> _openSettings() async {
    final result = await showModalBottomSheet<_ParameterSettingsResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: VivariColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.92,
        child: _ParameterSettings(
          parameters: _parameters,
          aquariums: widget.aquariums,
          selectedAquariumName: _selectedAquariumName,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _parameters = result.parameters;
        _selectedAquariumName = result.selectedAquariumName;
      });
    }
  }

  void _showLoggingNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parameter logging is not available yet.')),
    );
  }

  void _openDetails(WaterParameter parameter) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ParameterDetailsScreen(
          parameter: parameter,
          aquarium: _selectedAquarium,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aquarium = _selectedAquarium;
    final visibleParameters = _parameters
        .where((parameter) => parameter.enabled)
        .toList();
    return Scaffold(
      backgroundColor: VivariColors.background,
      floatingActionButton: VivariAddButton(
        onPressed: _showLoggingNotice,
        tooltip: 'Log Parameters',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.medium,
            AppSpacing.screen,
            96,
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WATER QUALITY',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Parameters',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                IconButton(
                  tooltip: 'Parameter Settings',
                  onPressed: _openSettings,
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
            if (widget.aquariums.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.medium),
              _AquariumPills(
                aquariums: widget.aquariums,
                selectedName: _selectedAquariumName,
                onSelected: (aquarium) =>
                    setState(() => _selectedAquariumName = aquarium.name),
              ),
            ],
            const SizedBox(height: AppSpacing.medium),
            for (final parameter in visibleParameters) ...[
              _ParameterListCard(
                parameter: parameter,
                aquarium: aquarium,
                onTap: () => _openDetails(parameter),
              ),
              const SizedBox(height: AppSpacing.small),
            ],
          ],
        ),
      ),
    );
  }
}

class _AquariumPills extends StatelessWidget {
  const _AquariumPills({
    required this.aquariums,
    required this.selectedName,
    required this.onSelected,
  });

  final List<Aquarium> aquariums;
  final String? selectedName;
  final ValueChanged<Aquarium> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: ListView.separated(
      key: const ValueKey('parameter-aquarium-filter'),
      scrollDirection: Axis.horizontal,
      itemCount: aquariums.length,
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final aquarium = aquariums[index];
        final selected = aquarium.name == selectedName;
        return ChoiceChip(
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              aquarium.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          selected: selected,
          onSelected: (_) => onSelected(aquarium),
          backgroundColor: VivariColors.secondary,
          selectedColor: VivariColors.primary,
          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? VivariColors.background : VivariColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: selected ? VivariColors.primary : VivariColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        );
      },
    ),
  );
}

class _ParameterListCard extends StatelessWidget {
  const _ParameterListCard({
    required this.parameter,
    required this.aquarium,
    required this.onTap,
  });

  final WaterParameter parameter;
  final Aquarium? aquarium;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final range = aquarium == null ? null : parameter.rangeFor(aquarium!.type);
    return Material(
      color: VivariColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: VivariColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 2,
                height: 42,
                decoration: BoxDecoration(
                  color: VivariColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parameter.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    const ParameterStatusBadge(
                      status: ParameterStatus.noReading,
                      compact: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '—',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: VivariColors.positive,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    range == null
                        ? 'Tank needed'
                        : '${range.formatted}${parameter.unit.isEmpty ? '' : parameter.unit}',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ParameterStatusBadge extends StatelessWidget {
  const ParameterStatusBadge({
    required this.status,
    super.key,
    this.compact = false,
  });

  final ParameterStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (status) {
      ParameterStatus.withinRange => (
        'Within range',
        Icons.check_rounded,
        VivariColors.positive,
      ),
      ParameterStatus.aboveRange => (
        'Above range',
        Icons.arrow_upward_rounded,
        VivariColors.warning,
      ),
      ParameterStatus.belowRange => (
        'Below range',
        Icons.arrow_downward_rounded,
        VivariColors.error,
      ),
      ParameterStatus.noReading => (
        'No readings',
        null,
        VivariColors.textMuted,
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 2 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.32)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 11 : 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParameterDetailsScreen extends StatefulWidget {
  const ParameterDetailsScreen({
    required this.parameter,
    required this.aquarium,
    super.key,
  });

  final WaterParameter parameter;
  final Aquarium? aquarium;

  @override
  State<ParameterDetailsScreen> createState() => _ParameterDetailsScreenState();
}

class _ParameterDetailsScreenState extends State<ParameterDetailsScreen> {
  _ChartTimeframe _timeframe = _ChartTimeframe.week;

  @override
  Widget build(BuildContext context) {
    final parameter = widget.parameter;
    final aquarium = widget.aquarium;
    final range = aquarium == null ? null : parameter.rangeFor(aquarium.type);
    return Scaffold(
      backgroundColor: VivariColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.small,
          AppSpacing.screen,
          AppSpacing.large,
        ),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aquarium?.name.toUpperCase() ?? 'NO AQUARIUM SELECTED',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      parameter.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '—',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: VivariColors.positive,
                  fontSize: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              _TimeframeChip(
                label: 'Week',
                selected: _timeframe == _ChartTimeframe.week,
                onTap: () => setState(() => _timeframe = _ChartTimeframe.week),
              ),
              const SizedBox(width: AppSpacing.small),
              _TimeframeChip(
                label: 'Month',
                selected: _timeframe == _ChartTimeframe.month,
                onTap: () => setState(() => _timeframe = _ChartTimeframe.month),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _ParameterChart(
            range: range,
            unit: parameter.unit,
            timeframe: _timeframe,
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            children: [
              Expanded(
                child: _ParameterStatCard(
                  label: 'STATUS',
                  child: const ParameterStatusBadge(
                    status: ParameterStatus.noReading,
                    compact: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              const Expanded(
                child: _ParameterStatCard(label: 'AVERAGE', child: Text('—')),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: _ParameterStatCard(
                  label: 'OPTIMAL',
                  child: Text(
                    range == null
                        ? 'Tank needed'
                        : '${range.formatted}${parameter.unit.isEmpty ? '' : parameter.unit}',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeframeChip extends StatelessWidget {
  const _TimeframeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    backgroundColor: VivariColors.secondary,
    selectedColor: VivariColors.primary,
    labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
      color: selected ? VivariColors.background : VivariColors.textMuted,
      fontWeight: FontWeight.w600,
    ),
    showCheckmark: false,
    side: BorderSide(
      color: selected ? VivariColors.primary : VivariColors.border,
    ),
  );
}

class _ParameterChart extends StatelessWidget {
  const _ParameterChart({
    required this.range,
    required this.unit,
    required this.timeframe,
  });

  final ParameterRange? range;
  final String unit;
  final _ChartTimeframe timeframe;

  @override
  Widget build(BuildContext context) => Container(
    height: 250,
    decoration: BoxDecoration(
      color: VivariColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: VivariColors.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _ParameterGridPainter(
              minimum: range?.minimum ?? 0,
              maximum: range?.maximum ?? 10,
              unit: unit,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.show_chart_rounded,
              color: VivariColors.textMuted.withValues(alpha: 0.65),
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              'No readings yet',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              timeframe == _ChartTimeframe.week
                  ? 'Your last 7 days will appear here'
                  : 'Your last 30 days will appear here',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 10),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ParameterGridPainter extends CustomPainter {
  const _ParameterGridPainter({
    required this.minimum,
    required this.maximum,
    required this.unit,
  });

  final double minimum;
  final double maximum;
  final String unit;

  @override
  void paint(Canvas canvas, Size size) {
    const leftInset = 48.0;
    const rightInset = 12.0;
    const topInset = 16.0;
    const bottomInset = 26.0;
    final chartHeight = size.height - topInset - bottomInset;
    final chartWidth = size.width - leftInset - rightInset;
    final gridPaint = Paint()
      ..color = VivariColors.border
      ..strokeWidth = 1;
    final textStyle = TextStyle(
      color: VivariColors.textMuted.withValues(alpha: 0.75),
      fontSize: 9,
      fontFamily: 'monospace',
    );
    for (var index = 0; index <= 4; index++) {
      final y = topInset + chartHeight * index / 4;
      canvas.drawLine(
        Offset(leftInset, y),
        Offset(leftInset + chartWidth, y),
        gridPaint,
      );
      final value = maximum - (maximum - minimum) * index / 4;
      final label = TextPainter(
        text: TextSpan(
          text: '${_formatAxisNumber(value)}$unit',
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: leftInset - 8);
      label.paint(
        canvas,
        Offset(leftInset - label.width - 6, y - label.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParameterGridPainter oldDelegate) =>
      minimum != oldDelegate.minimum ||
      maximum != oldDelegate.maximum ||
      unit != oldDelegate.unit;
}

class _ParameterStatCard extends StatelessWidget {
  const _ParameterStatCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 70),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: VivariColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: VivariColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontSize: 9, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

class _ParameterSettingsResult {
  const _ParameterSettingsResult(this.parameters, this.selectedAquariumName);

  final List<WaterParameter> parameters;
  final String? selectedAquariumName;
}

class _ParameterSettings extends StatefulWidget {
  const _ParameterSettings({
    required this.parameters,
    required this.aquariums,
    required this.selectedAquariumName,
  });

  final List<WaterParameter> parameters;
  final List<Aquarium> aquariums;
  final String? selectedAquariumName;

  @override
  State<_ParameterSettings> createState() => _ParameterSettingsState();
}

class _ParameterSettingsState extends State<_ParameterSettings> {
  late List<WaterParameter> _parameters;
  late String? _selectedAquariumName;
  AquariumType _rangeType = AquariumType.saltwater;

  @override
  void initState() {
    super.initState();
    _parameters = List.of(widget.parameters);
    _selectedAquariumName = widget.selectedAquariumName;
    final aquarium = _selectedAquarium;
    if (aquarium != null) _rangeType = aquarium.type;
  }

  Aquarium? get _selectedAquarium {
    for (final aquarium in widget.aquariums) {
      if (aquarium.name == _selectedAquariumName) return aquarium;
    }
    return null;
  }

  void _close() => Navigator.of(
    context,
  ).pop(_ParameterSettingsResult(_parameters, _selectedAquariumName));

  Future<void> _editRange(int index) async {
    final parameter = _parameters[index];
    final range = parameter.rangeFor(_rangeType);
    final updated = await showDialog<_RangeEditorResult>(
      context: context,
      builder: (_) => _RangeEditorDialog(
        parameter: parameter,
        initialRange: range,
        aquariumType: _rangeType,
        showWaterTypeSelector: _selectedAquarium == null,
      ),
    );
    if (updated == null || !mounted) return;
    setState(() {
      _parameters[index] = switch (updated.type) {
        AquariumType.freshwater => parameter.copyWith(
          freshwaterRange: updated.range,
        ),
        AquariumType.saltwater => parameter.copyWith(
          saltwaterRange: updated.range,
        ),
      };
    });
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      final parameter = _parameters.removeAt(oldIndex);
      _parameters.insert(newIndex, parameter);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Parameter Settings',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 20),
              ),
            ),
            IconButton(
              tooltip: 'Close settings',
              onPressed: _close,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
      if (widget.aquariums.isNotEmpty) ...[
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _AquariumPills(
            aquariums: widget.aquariums,
            selectedName: _selectedAquariumName,
            onSelected: (aquarium) => setState(() {
              _selectedAquariumName = aquarium.name;
              _rangeType = aquarium.type;
            }),
          ),
        ),
        const Divider(height: 1),
      ],
      Expanded(
        child: ReorderableListView.builder(
          key: const ValueKey('parameter-settings-reorder-list'),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          itemCount: _parameters.length,
          onReorderItem: _reorder,
          itemBuilder: (context, index) {
            final parameter = _parameters[index];
            return _SettingsParameterCard(
              key: ValueKey(parameter.id),
              index: index,
              parameter: parameter,
              aquariumType: _rangeType,
              onEditRange: () => _editRange(index),
              onEnabledChanged: (enabled) => setState(
                () => _parameters[index] = parameter.copyWith(enabled: enabled),
              ),
            );
          },
        ),
      ),
      SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _close, child: const Text('Done')),
          ),
        ),
      ),
    ],
  );
}

class _SettingsParameterCard extends StatelessWidget {
  const _SettingsParameterCard({
    required super.key,
    required this.index,
    required this.parameter,
    required this.aquariumType,
    required this.onEditRange,
    required this.onEnabledChanged,
  });

  final int index;
  final WaterParameter parameter;
  final AquariumType aquariumType;
  final VoidCallback onEditRange;
  final ValueChanged<bool> onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    final range = parameter.rangeFor(aquariumType);
    final unit = parameter.unit.isEmpty ? '' : parameter.unit;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: VivariColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.drag_indicator, size: 20),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: VivariColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parameter.name,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${range.formatted}$unit',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Customize ${parameter.name} range',
                onPressed: onEditRange,
                icon: const Icon(Icons.settings_outlined, size: 17),
                style: IconButton.styleFrom(
                  minimumSize: const Size(28, 28),
                  maximumSize: const Size(28, 28),
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                  shape: const CircleBorder(),
                ),
              ),
              Switch.adaptive(
                key: ValueKey('parameter-enabled-${parameter.id}'),
                value: parameter.enabled,
                onChanged: onEnabledChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return VivariColors.primary;
                  }
                  return VivariColors.border;
                }),
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return VivariColors.background;
                  }
                  return VivariColors.textMuted;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeEditorResult {
  const _RangeEditorResult(this.type, this.range);

  final AquariumType type;
  final ParameterRange range;
}

class _RangeEditorDialog extends StatefulWidget {
  const _RangeEditorDialog({
    required this.parameter,
    required this.initialRange,
    required this.aquariumType,
    required this.showWaterTypeSelector,
  });

  final WaterParameter parameter;
  final ParameterRange initialRange;
  final AquariumType aquariumType;
  final bool showWaterTypeSelector;

  @override
  State<_RangeEditorDialog> createState() => _RangeEditorDialogState();
}

class _RangeEditorDialogState extends State<_RangeEditorDialog> {
  late final TextEditingController _minimumController;
  late final TextEditingController _maximumController;
  late AquariumType _aquariumType;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _aquariumType = widget.aquariumType;
    _minimumController = TextEditingController(
      text: _formatNumber(widget.initialRange.minimum),
    );
    _maximumController = TextEditingController(
      text: _formatNumber(widget.initialRange.maximum),
    );
  }

  @override
  void dispose() {
    _minimumController.dispose();
    _maximumController.dispose();
    super.dispose();
  }

  void _save() {
    final minimum = double.tryParse(_minimumController.text.trim());
    final maximum = double.tryParse(_maximumController.text.trim());
    if (minimum == null ||
        maximum == null ||
        !minimum.isFinite ||
        !maximum.isFinite ||
        minimum >= maximum) {
      setState(() => _validationError = 'Enter a minimum below the maximum.');
      return;
    }
    Navigator.of(
      context,
    ).pop(_RangeEditorResult(_aquariumType, ParameterRange(minimum, maximum)));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      '${widget.parameter.name}${widget.parameter.unit.isEmpty ? '' : ' · ${widget.parameter.unit}'}',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showWaterTypeSelector) ...[
            Text('Range for', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            SegmentedButton<AquariumType>(
              segments: const [
                ButtonSegment(
                  value: AquariumType.freshwater,
                  label: Text('Freshwater'),
                ),
                ButtonSegment(
                  value: AquariumType.saltwater,
                  label: Text('Saltwater'),
                ),
              ],
              selected: {_aquariumType},
              onSelectionChanged: (selection) {
                final type = selection.first;
                final range = widget.parameter.rangeFor(type);
                setState(() {
                  _aquariumType = type;
                  _minimumController.text = _formatNumber(range.minimum);
                  _maximumController.text = _formatNumber(range.maximum);
                  _validationError = null;
                });
              },
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Expanded(
                child: _RangeInput(
                  label: 'Minimum',
                  controller: _minimumController,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RangeInput(
                  label: 'Maximum',
                  controller: _maximumController,
                ),
              ),
            ],
          ),
          if (_validationError != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationError!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: VivariColors.error),
            ),
          ],
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: _save, child: const Text('Save')),
    ],
  );
}

class _RangeInput extends StatelessWidget {
  const _RangeInput({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    ],
  );
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value
      .toString()
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

String _formatAxisNumber(double value) => value
    .toStringAsFixed(2)
    .replaceFirst(RegExp(r'0+$'), '')
    .replaceFirst(RegExp(r'\.$'), '');
