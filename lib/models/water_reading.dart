class WaterReading {
  const WaterReading({
    required this.aquariumName,
    required this.parameterId,
    required this.parameterName,
    required this.value,
    required this.unit,
    required this.measuredAt,
  });

  final String aquariumName;
  final String parameterId;
  final String parameterName;
  final double value;
  final String unit;
  final DateTime measuredAt;
}
