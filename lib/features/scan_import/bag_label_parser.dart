import 'package:cc_core/cc_core.dart';

import '../../data/database/app_database.dart';

/// What one bag-label photo transcribed to. Every field is exactly
/// what the camera saw — the user confirms before any composer field
/// is filled, and edits everything afterward.
class BagLabelReading {
  BagLabelReading({
    this.roaster,
    this.name,
    this.origin,
    this.process,
    this.roastDate,
  });

  String? roaster;
  String? name;
  String? origin;
  RoastProcess? process;
  DateTime? roastDate;

  bool get isEmpty =>
      roaster == null &&
      name == null &&
      origin == null &&
      process == null &&
      roastDate == null;
}

/// Producing countries bags actually print — the origin match list.
const coffeeOrigins = [
  'Ethiopia', 'Colombia', 'Kenya', 'Guatemala', 'Brazil', 'Honduras',
  'Costa Rica', 'El Salvador', 'Peru', 'Mexico', 'Nicaragua', 'Panama',
  'Rwanda', 'Burundi', 'Uganda', 'Tanzania', 'Indonesia', 'Sumatra',
  'Java', 'Yemen', 'India', 'Vietnam', 'Ecuador', 'Bolivia', 'Congo',
  'Papua New Guinea', 'Hawaii', 'Jamaica',
];

final _processWords = {
  'washed': RoastProcess.washed,
  'natural': RoastProcess.natural,
  'honey': RoastProcess.honey,
  'anaerobic': RoastProcess.anaerobic,
};

// Rows that are label plumbing, never a roaster or coffee name.
final _nameNoise = RegExp(
    r'\b(roasted?|roast date|net\s?wt|whole bean|ground|notes?|'
    r'process|washed|natural|honey|anaerobic|elevation|altitude|masl|'
    r'variet(y|al)|producer|farm|lot|www|\.com|oz|340g|250g|12\s?oz)\b',
    caseSensitive: false);

/// Transcribes one bag-label photo's OCR into a [BagLabelReading].
///
/// Roaster: the tallest text in the top half that isn't label plumbing
/// — bags shout the roaster. Name: the next-tallest distinct line.
/// Origin: the first producing country printed anywhere. Process: the
/// first process word. Roast date: a date on a "roast" row, else the
/// first date on the label.
///
/// Null when the photo had no text at all. No field is ever invented —
/// missing stays null for the user to fill in.
BagLabelReading? parseBagLabel(List<OcrLine> lines) {
  if (lines.isEmpty) return null;

  final bottom =
      lines.map((l) => l.top + l.height).reduce((a, b) => a > b ? a : b);
  final topHalf = lines.where((l) => l.top < bottom / 2).toList()
    ..sort((a, b) => b.height.compareTo(a.height));

  String? roaster;
  String? name;
  for (final line in topHalf) {
    final text = line.text.trim();
    if (text.length < 3 || _nameNoise.hasMatch(text)) continue;
    if (!RegExp(r'[a-zA-Z]{3}').hasMatch(text)) continue;
    if (parseLooseDate(text) != null) continue;
    if (roaster == null) {
      roaster = titleCaseShouted(text);
    } else if (text.toLowerCase() != roaster.toLowerCase()) {
      name = titleCaseShouted(text);
      break;
    }
  }

  final rows = mergeOcrRows(lines);

  String? origin;
  for (final row in rows) {
    origin = coffeeOrigins
        .where((o) => row.toLowerCase().contains(o.toLowerCase()))
        .firstOrNull;
    if (origin != null) break;
  }

  RoastProcess? process;
  for (final row in rows) {
    final lower = row.toLowerCase();
    process = _processWords.entries
        .where((e) => lower.contains(e.key))
        .map((e) => e.value)
        .firstOrNull;
    if (process != null) break;
  }

  DateTime? roastDate;
  for (final row in rows) {
    if (row.toLowerCase().contains('roast')) {
      roastDate = parseLooseDate(row);
      if (roastDate != null) break;
    }
  }
  roastDate ??= parsePageDatesFirst(rows);

  final reading = BagLabelReading(
    roaster: roaster,
    name: name,
    origin: origin,
    process: process,
    roastDate: roastDate,
  );
  return reading.isEmpty ? null : reading;
}

/// First parseable date across merged rows, or null.
DateTime? parsePageDatesFirst(List<String> rows) {
  for (final row in rows) {
    final d = parseLooseDate(row);
    if (d != null) return d;
  }
  return null;
}
