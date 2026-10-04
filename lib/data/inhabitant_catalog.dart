import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/inhabitant.dart';

class InhabitantCatalog {
  const InhabitantCatalog();

  Future<List<InhabitantCatalogEntry>> load() async {
    final source = await rootBundle.loadString(
      'assets/data/inhabitants.json',
    );
    final decoded = jsonDecode(source) as List<dynamic>;
    return List<InhabitantCatalogEntry>.unmodifiable(
      decoded.map(
        (record) => InhabitantCatalogEntry.fromJson(
          record as Map<String, dynamic>,
        ),
      ),
    );
  }
}
