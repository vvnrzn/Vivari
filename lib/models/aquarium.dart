import 'dart:typed_data';

enum AquariumType {
  freshwater('Freshwater'),
  saltwater('Saltwater');

  const AquariumType(this.label);

  final String label;
}

class Aquarium {
  const Aquarium({
    required this.name,
    required this.type,
    required this.volume,
    required this.volumeUnit,
    required this.createdAt,
    this.photoBytes,
  });

  final String name;
  final AquariumType type;
  final double volume;
  final String volumeUnit;
  final DateTime createdAt;
  final Uint8List? photoBytes;
}
