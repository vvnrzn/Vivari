import 'aquarium.dart';

enum InhabitantCategory {
  fish('Fish'),
  inverts('Inverts'),
  plants('Plants'),
  corals('Corals');

  const InhabitantCategory(this.label);

  final String label;

  static InhabitantCategory fromJson(String value) => switch (value) {
    'Fish' => InhabitantCategory.fish,
    'Inverts' => InhabitantCategory.inverts,
    'Plants' => InhabitantCategory.plants,
    'Corals' => InhabitantCategory.corals,
    _ => throw FormatException('Unknown inhabitant category: $value'),
  };
}

class InhabitantCatalogEntry {
  const InhabitantCatalogEntry({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.waterType,
    required this.category,
    this.keywords = const [],
  });

  final String id;
  final String commonName;
  final String scientificName;
  final AquariumType waterType;
  final InhabitantCategory category;
  final List<String> keywords;

  factory InhabitantCatalogEntry.fromJson(Map<String, dynamic> json) {
    final water = json['waterType'] as String;
    return InhabitantCatalogEntry(
      id: json['id'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      waterType: switch (water) {
        'Freshwater' => AquariumType.freshwater,
        'Saltwater' => AquariumType.saltwater,
        _ => throw FormatException('Unknown water type: $water'),
      },
      category: InhabitantCategory.fromJson(json['category'] as String),
      keywords: List<String>.unmodifiable(
        (json['keywords'] as List<dynamic>? ?? const []).cast<String>(),
      ),
    );
  }
}

class AquariumInhabitant {
  const AquariumInhabitant({required this.entry, required this.quantity});

  final InhabitantCatalogEntry entry;
  final int quantity;

  AquariumInhabitant copyWith({int? quantity}) =>
      AquariumInhabitant(entry: entry, quantity: quantity ?? this.quantity);
}
