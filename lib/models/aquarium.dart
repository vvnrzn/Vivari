import 'dart:typed_data';

import 'inhabitant.dart';

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
    this.inhabitants = const [],
  });

  final String name;
  final AquariumType type;
  final double volume;
  final String volumeUnit;
  final DateTime createdAt;
  final Uint8List? photoBytes;
  final List<AquariumInhabitant> inhabitants;

  Aquarium copyWith({
    String? name,
    AquariumType? type,
    double? volume,
    String? volumeUnit,
    DateTime? createdAt,
    Uint8List? photoBytes,
    List<AquariumInhabitant>? inhabitants,
  }) => Aquarium(
    name: name ?? this.name,
    type: type ?? this.type,
    volume: volume ?? this.volume,
    volumeUnit: volumeUnit ?? this.volumeUnit,
    createdAt: createdAt ?? this.createdAt,
    photoBytes: photoBytes ?? this.photoBytes,
    inhabitants: inhabitants ?? this.inhabitants,
  );
}
