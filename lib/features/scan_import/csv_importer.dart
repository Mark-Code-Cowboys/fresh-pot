import 'package:cc_core/cc_core.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/bean_repository.dart';
import '../monetization/free_limit.dart';

/// The columns Fresh Pot can take from a spreadsheet or an incumbent
/// export, for cc_core's [CsvMappingScreen]. Guess tiers cover the
/// generic spreadsheet-keeper wording; when the incumbent sample file
/// lands, its exact headers join the first tiers so its exports map
/// with zero manual picking.
const fpCsvFields = [
  CsvField('name',
      label: 'Coffee name (required)',
      isRequired: true,
      guessTiers: [
        ['coffee', 'bean'],
        ['name'],
      ]),
  CsvField('roaster', label: 'Roaster', guessTiers: [
    ['roaster', 'brand', 'company'],
  ]),
  CsvField('origin', label: 'Origin', guessTiers: [
    ['origin', 'country'],
  ]),
  CsvField('region', label: 'Region', guessTiers: [
    ['region', 'area'],
  ]),
  CsvField('process', label: 'Process', guessTiers: [
    ['process', 'method'],
  ]),
  CsvField('roastDate', label: 'Roast date', guessTiers: [
    ['roast date', 'roasted', 'roast_date'],
    ['date'],
  ]),
  CsvField('price', label: 'Bag price', guessTiers: [
    ['price', 'cost', 'paid'],
  ]),
  CsvField('rating', label: 'Rating (1-5)', guessTiers: [
    ['rating', 'stars', 'score'],
  ]),
  CsvField('notes', label: 'Tasting notes', guessTiers: [
    ['note', 'tasting', 'comment', 'flavor', 'flavour'],
  ]),
];

/// Roaster shown when the file had no roaster column — a labeling
/// convention (same as the fleet's unknown-site "—"), never a guess.
const unknownRoaster = '—';

/// What a spreadsheet import did, for the wrap-up line.
class CsvImportReport {
  const CsvImportReport({
    required this.beansAdded,
    required this.rowsSkipped,
    required this.beansSkippedAtCap,
  });

  final int beansAdded;

  /// Rows without a usable coffee name.
  final int rowsSkipped;

  /// Rows a free-tier user had no slots left for.
  final int beansSkippedAtCap;

  String get summary {
    final parts = [
      'Imported $beansAdded ${beansAdded == 1 ? 'bag' : 'bags'}',
      if (rowsSkipped > 0) '$rowsSkipped unusable rows skipped',
      if (beansSkippedAtCap > 0)
        '$beansSkippedAtCap rows past the free bag limit',
    ];
    return parts.join(' · ');
  }
}

/// "$18.00" / "18" cells to cents; null when the cell isn't a number.
int? parsePriceCell(String cell) {
  final cleaned = cell.replaceAll(RegExp(r'[$,\s]'), '');
  final value = double.tryParse(cleaned);
  return value == null ? null : (value * 100).round();
}

/// Reads a process cell into the enum; anything unrecognized becomes
/// other with the user's own word carried verbatim.
(RoastProcess?, String?) parseProcessCell(String? cell) {
  if (cell == null || cell.trim().isEmpty) return (null, null);
  final lower = cell.trim().toLowerCase();
  for (final p in RoastProcess.values) {
    if (p != RoastProcess.other && lower.contains(p.name)) return (p, null);
  }
  return (RoastProcess.other, cell.trim());
}

/// Imports spreadsheet rows as bags. Existing bags are matched by
/// roaster + name (case-insensitive) and skipped — re-importing the
/// same export never duplicates. Free users import up to the cap:
/// rows past it are counted and skipped, never silently dropped.
Future<CsvImportReport> importCsvBeans({
  required BeanRepository beans,
  required CsvDocument doc,
  required Map<String, int?> mapping,
  required bool entitled,
}) async {
  final existing = await beans.getAll();
  final seen = {
    for (final b in existing)
      '${b.roaster.trim().toLowerCase()}|${b.name.trim().toLowerCase()}',
  };

  var added = 0, skipped = 0, atCap = 0;
  for (final row in doc.rows) {
    String? cell(String key) {
      final column = mapping[key];
      return column == null ? null : doc.rowCell(row, column);
    }

    final name = cell('name');
    if (name == null) {
      skipped++;
      continue;
    }
    final roaster = cell('roaster') ?? unknownRoaster;
    final key = '${roaster.trim().toLowerCase()}|${name.trim().toLowerCase()}';
    if (seen.contains(key)) continue;

    if (!entitled &&
        beanFreeLimit.isReached(await beans.lifetimeCreated())) {
      atCap++;
      continue;
    }

    final (process, processLabel) = parseProcessCell(cell('process'));
    final rating = switch (cell('rating')) {
      null => null,
      final text => switch (int.tryParse(text.trim())) {
          final r? when r >= 1 && r <= 5 => r,
          _ => null,
        },
    };
    await beans.create(BeanDraft(
      roaster: roaster,
      name: name,
      origin: cell('origin'),
      region: cell('region'),
      process: process,
      processLabel: processLabel,
      roastDate: switch (cell('roastDate')) {
        null => null,
        final text => parseLooseDate(text),
      },
      priceBagCents: switch (cell('price')) {
        null => null,
        final text => parsePriceCell(text),
      },
      rating: rating,
      notes: cell('notes'),
    ));
    seen.add(key);
    added++;
  }
  return CsvImportReport(
    beansAdded: added,
    rowsSkipped: skipped,
    beansSkippedAtCap: atCap,
  );
}
