import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../core/utils/brew_math.dart';
import '../database/app_database.dart';

/// A brew joined with its story (rating, notes).
class BrewWithStory {
  const BrewWithStory(this.brew, {this.entry});

  final Brew brew;
  final JournalEntry? entry;

  String? get notes => entry?.notes;
  int? get rating => entry?.rating;

  /// Water (or yield) over dose; null when either wasn't logged.
  double? get ratio => brewRatio(
      doseG: brew.doseG, waterG: brew.waterG, yieldG: brew.yieldG);
}

/// A cup being composed. Water XOR yield — asserted here so the CHECK
/// never fires from app code. Rating/notes land in the journal tables.
class BrewDraft {
  const BrewDraft({
    required this.method,
    this.methodLabel,
    this.doseG,
    this.waterG,
    this.yieldG,
    this.grindSetting,
    this.grinderGearId,
    this.tempF,
    this.timeSec,
    this.brewedAt,
    this.rating,
    this.notes,
  }) : assert(waterG == null || yieldG == null,
            'A brew logs water in OR yield out, never both');

  final BrewMethod method;
  final String? methodLabel;
  final double? doseG;
  final double? waterG;
  final double? yieldG;
  final String? grindSetting;
  final int? grinderGearId;
  final int? tempF;
  final int? timeSec;
  final DateTime? brewedAt;
  final int? rating;
  final String? notes;

  bool get hasStory => rating != null || notes != null;
}

class BrewRepository {
  BrewRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// A bean's brews, newest first, each with its story.
  Stream<List<BrewWithStory>> watchForBean(int beanId) {
    final query = _db.select(_db.brews)
      ..where((b) => b.beanId.equals(beanId))
      ..orderBy([
        (b) => OrderingTerm.desc(b.brewedAt),
        (b) => OrderingTerm.desc(b.id),
      ]);
    return _withStories(query.watch());
  }

  /// Every brew in the journal, raw — the trends math works across the
  /// whole book.
  Stream<List<Brew>> watchAllRaw() => _db.select(_db.brews).watch();

  /// The bean's most recent brew — the repeat-last-brew hook.
  Future<Brew?> latestForBean(int beanId) {
    final query = _db.select(_db.brews)
      ..where((b) => b.beanId.equals(beanId))
      ..orderBy([
        (b) => OrderingTerm.desc(b.brewedAt),
        (b) => OrderingTerm.desc(b.id),
      ])
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// Creates the brew (and its journal entry when there's a story)
  /// atomically; returns the brew id.
  Future<int> create(int beanId, BrewDraft d) {
    return _db.transaction(() async {
      int? entryId;
      if (d.hasStory) {
        entryId = await _journal.createEntry(
            JournalEntryDraft(notes: d.notes, rating: d.rating));
      }
      return _db.into(_db.brews).insert(_companion(beanId, d, entryId));
    });
  }

  /// Rewrites the brew's fields, rating, and notes.
  Future<void> update(int id, BrewDraft d) {
    return _db.transaction(() async {
      final brew = await (_db.select(_db.brews)
            ..where((b) => b.id.equals(id)))
          .getSingle();
      var entryId = brew.journalEntryId;
      if (entryId == null && d.hasStory) {
        entryId = await _journal.createEntry(
            JournalEntryDraft(notes: d.notes, rating: d.rating));
      } else if (entryId != null) {
        await _journal.updateEntry(entryId,
            notes: d.notes, rating: d.rating);
      }
      await (_db.update(_db.brews)..where((b) => b.id.equals(id)))
          .write(_companion(brew.beanId, d, entryId));
    });
  }

  /// Deletes the brew and its journal entry.
  Future<void> delete(int id) async {
    final brew = await (_db.select(_db.brews)
          ..where((b) => b.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.brews)..where((b) => b.id.equals(id))).go();
    final entryId = brew?.journalEntryId;
    if (entryId != null) await _journal.deleteEntries([entryId]);
  }

  Stream<List<BrewWithStory>> _withStories(Stream<List<Brew>> brews) {
    final entries = _db.select(_db.appJournalEntries).watch();
    return brews.combineLatest(entries,
        (List<Brew> b, List<JournalEntry> e) {
      final byId = {for (final entry in e) entry.id: entry};
      return [
        for (final brew in b)
          BrewWithStory(brew, entry: byId[brew.journalEntryId]),
      ];
    });
  }

  BrewsCompanion _companion(int beanId, BrewDraft d, int? entryId) =>
      BrewsCompanion.insert(
        beanId: beanId,
        method: d.method,
        methodLabel: Value(d.methodLabel),
        doseG: Value(d.doseG),
        waterG: Value(d.waterG),
        yieldG: Value(d.yieldG),
        grindSetting: Value(d.grindSetting),
        grinderGearId: Value(d.grinderGearId),
        tempF: Value(d.tempF),
        timeSec: Value(d.timeSec),
        brewedAt: d.brewedAt == null
            ? const Value.absent()
            : Value(d.brewedAt!),
        journalEntryId: Value(entryId),
      );
}
