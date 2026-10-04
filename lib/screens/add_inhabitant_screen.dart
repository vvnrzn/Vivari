import 'package:flutter/material.dart';

import '../data/inhabitant_catalog.dart';
import '../models/aquarium.dart';
import '../models/inhabitant.dart';
import '../theme/app_theme.dart';

class AddInhabitantScreen extends StatefulWidget {
  const AddInhabitantScreen({required this.waterType, super.key});

  final AquariumType waterType;

  @override
  State<AddInhabitantScreen> createState() => _AddInhabitantScreenState();
}

class _AddInhabitantScreenState extends State<AddInhabitantScreen> {
  final _catalog = const InhabitantCatalog();
  final _searchController = TextEditingController();
  late final Future<List<InhabitantCatalogEntry>> _entries = _catalog.load();
  final Set<String> _selectedIds = {};
  InhabitantCategory? _selectedCategory;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(InhabitantCatalogEntry entry) {
    setState(() {
      if (!_selectedIds.add(entry.id)) _selectedIds.remove(entry.id);
    });
  }

  Future<void> _addSelectedInhabitants() async {
    final catalog = await _entries;
    if (!mounted) return;
    final selected = catalog
        .where((entry) => _selectedIds.contains(entry.id))
        .map((entry) => AquariumInhabitant(entry: entry, quantity: 1))
        .toList();
    Navigator.of(context).pop(selected);
  }

  List<InhabitantCatalogEntry> _matchingEntries(
    List<InhabitantCatalogEntry> entries,
  ) {
    final tokens = _searchTokens(_query);
    final matching = entries.where((entry) {
      if (entry.waterType != widget.waterType) return false;
      if (_selectedCategory != null && entry.category != _selectedCategory) {
        return false;
      }
      return tokens.every((token) => _matchesToken(entry, token));
    }).toList();
    matching.sort((a, b) {
      final scoreDifference = _matchScore(b, tokens) - _matchScore(a, tokens);
      return scoreDifference == 0
          ? a.commonName.compareTo(b.commonName)
          : scoreDifference;
    });
    return matching;
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      InhabitantCategory.fish,
      InhabitantCategory.inverts,
      InhabitantCategory.plants,
      if (widget.waterType == AquariumType.saltwater) InhabitantCategory.corals,
    ];
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        leadingWidth: 76,
        title: const Text('Add Inhabitant'),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.small,
                AppSpacing.screen,
                AppSpacing.medium,
              ),
              child: Column(
                children: [
                  TextField(
                    key: const ValueKey('inhabitant-search-field'),
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search names or keywords...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                      fillColor: VivariColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: VivariColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: VivariColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: VivariColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CategoryFilterChip(
                          label: 'All',
                          selected: _selectedCategory == null,
                          onTap: () => setState(() => _selectedCategory = null),
                        ),
                        for (final category in categories) ...[
                          const SizedBox(width: AppSpacing.small),
                          _CategoryFilterChip(
                            label: category.label,
                            selected: _selectedCategory == category,
                            onTap: () => setState(() {
                              _selectedCategory = _selectedCategory == category
                                  ? null
                                  : category;
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<InhabitantCatalogEntry>>(
                future: _entries,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.screen),
                        child: Text(
                          'Could not load the local inhabitant catalog: '
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final entries = _matchingEntries(snapshot.data!);
                  if (entries.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.screen),
                        child: Text(
                          _query.isEmpty
                              ? 'No inhabitants in this category yet.'
                              : 'No matches. Try a common name, scientific name, or keyword.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: VivariColors.textMuted),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    key: const ValueKey('inhabitant-catalog-list'),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      0,
                      AppSpacing.screen,
                      AppSpacing.medium,
                    ),
                    itemCount: entries.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.small),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _CatalogCard(
                        entry: entry,
                        selected: _selectedIds.contains(entry.id),
                        onTap: () => _toggleSelection(entry),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.small,
            AppSpacing.screen,
            AppSpacing.small,
          ),
          child: FilledButton(
            onPressed: _selectedIds.isEmpty ? null : _addSelectedInhabitants,
            child: Text(
              _selectedIds.isEmpty
                  ? 'Select inhabitants'
                  : 'Add to Aquarium (${_selectedIds.length})',
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final InhabitantCatalogEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${entry.commonName}, ${entry.scientificName}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: VivariColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? VivariColors.primary : VivariColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.commonName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.scientificName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: VivariColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Wrap(
                      spacing: AppSpacing.small,
                      runSpacing: 4,
                      children: [
                        _CatalogBadge(label: entry.waterType.label),
                        _CatalogBadge(label: entry.category.label),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Icon(
                selected ? Icons.check_circle : Icons.add_circle_outline,
                color: selected ? VivariColors.primary : VivariColors.textMuted,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
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
    selectedColor: VivariColors.primary,
    backgroundColor: VivariColors.secondary,
    side: BorderSide(
      color: selected ? VivariColors.primary : VivariColors.border,
    ),
    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: selected ? VivariColors.background : VivariColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _CatalogBadge extends StatelessWidget {
  const _CatalogBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: VivariColors.secondary,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: VivariColors.border),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: VivariColors.primary,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

List<String> _searchTokens(String query) => query
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
    .trim()
    .split(RegExp(r'\s+'))
    .where((token) => token.isNotEmpty)
    .toList();

bool _matchesToken(InhabitantCatalogEntry entry, String queryToken) {
  final searchableFields = [
    entry.commonName,
    entry.scientificName,
    ...entry.keywords,
    entry.category.label,
    entry.waterType.label,
  ].map(_searchTokens);
  for (final fieldTokens in searchableFields) {
    if (fieldTokens.any((token) => token.contains(queryToken))) return true;
    if (queryToken.length >= 4 &&
        fieldTokens.any((token) => _isNearMatch(token, queryToken))) {
      return true;
    }
  }
  return false;
}

bool _isNearMatch(String token, String query) {
  if ((token.length - query.length).abs() > 1) return false;
  var mismatches = 0;
  var left = 0;
  var right = 0;
  while (left < token.length && right < query.length) {
    if (token[left] == query[right]) {
      left++;
      right++;
    } else {
      mismatches++;
      if (mismatches > 1) return false;
      if (token.length > query.length) {
        left++;
      } else if (query.length > token.length) {
        right++;
      } else {
        left++;
        right++;
      }
    }
  }
  if (left < token.length || right < query.length) mismatches++;
  return mismatches <= 1;
}

int _matchScore(InhabitantCatalogEntry entry, List<String> tokens) {
  if (tokens.isEmpty) return 0;
  final commonName = _searchTokens(entry.commonName).join(' ');
  return tokens.fold(0, (score, token) {
    if (commonName == token) return score + 30;
    if (commonName.startsWith(token)) return score + 20;
    if (commonName.contains(token)) return score + 10;
    return score;
  });
}
