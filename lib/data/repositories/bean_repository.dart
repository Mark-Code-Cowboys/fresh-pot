import 'dart:math';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A bean joined with its story (rating, tasting notes, bag photos).
class BeanWithStory {
  const BeanWithStory(this.bean, {this.entry, this.photos = const []});

  final Bean bean;
  final JournalEntry? entry;
  final List<JournalPhoto> photos;

  String? get notes => entry?.notes;
  int? get rating => entry?.rating;

  /// Opened and not finished — the bag on the counter.
  bool get isActive =>
      bean.openedDate != null && bean.finishedDate == null;
}

/// A bag being composed. Rating/notes/photos land in the journal
/// tables.
class BeanDraft {
  const BeanDraft({
    required this.roaster,
    required this.name,
    this.origin,
    this.region,
    this.process,
    this.processLabel,
    this.roastLevel,
    this.priceBagCents,
    this.bagSizeG,
    this.roastDate,
    this.openedDate,
    this.finishedDate,
    this.rating,
    this.notes,
    this.photos = const [],
  });

  final String roaster;
  final String name;
  final String? origin;
  final String? region;
  final RoastProcess? process;
  final String? processLabel;
  final RoastLevel? roastLevel;
  final int? priceBagCents;
  final int? bagSizeG;
  final DateTime? roastDate;
  final DateTime? openedDate;
  final DateTime? finishedDate;
  final int? rating;
  final String? notes;
  final List<JournalPhotoDraft> photos;

  bool get hasStory =>
      rating != null || notes != null || photos.isNotEmpty;
}

class BeanRepository {
  BeanRepository(this._db,
      {AppJournalRepository? journal, LifetimeTally? tally})
      // ignore: prefer_initializing_formals
      : _journalOverride = journal,
        _tally = tally; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  final LifetimeTally? _tally;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// All bags, newest first, each with its story; the home screen
  /// re-sorts active bags to the top.
  Stream<List<BeanWithStory>> watchAll() {
    final query = _db.select(_db.beans)
      ..orderBy([
        (b) => OrderingTerm.desc(b.createdAt),
        (b) => OrderingTerm.desc(b.id),
      ]);
    return _withStories(query.watch());
  }

  Stream<BeanWithStory?> watchOne(int id) {
    final query = _db.select(_db.beans)..where((b) => b.id.equals(id));
    return _withStories(
            query.watch().map((rows) => rows.take(1).toList()))
        .map((list) => list.firstOrNull);
  }

  /// One-shot list for the importers (matching by roaster + name).
  Future<List<Bean>> getAll() => _db.select(_db.beans).get();

  /// Bags in the journal — feeds `FreeLimit(5, 'beans')`.
  Future<int> count() async {
    final countExp = _db.beans.id.count();
    final query = _db.selectOnly(_db.beans)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp)!;
  }

  /// Bags ever added on this device: the tally, but never below the
  /// live row count (pre-tally installs, backup restores).
  Future<int> lifetimeCreated() async {
    final live = await count();
    final tallied = await _tally?.value() ?? 0;
    return max(live, tallied);
  }

  /// Creates the bag (and its journal entry when there's a story)
  /// atomically; returns the bean id.
  Future<int> create(BeanDraft d) async {
    final id = await _db.transaction(() async {
      int? entryId;
      if (d.hasStory) {
        entryId = await _journal.createEntry(JournalEntryDraft(
            notes: d.notes, rating: d.rating, photos: d.photos));
      }
      return _db.into(_db.beans).insert(_companion(d, entryId));
    });
    await _tally?.recordCreated(liveCount: await count());
    return id;
  }

  /// Rewrites the bag's fields, rating, and notes. Photos are managed
  /// separately via [addPhoto]/[removePhoto].
  Future<void> update(int id, BeanDraft d) {
    return _db.transaction(() async {
      final bean = await (_db.select(_db.beans)
            ..where((b) => b.id.equals(id)))
          .getSingle();
      var entryId = bean.journalEntryId;
      if (entryId == null && d.hasStory) {
        entryId = await _journal.createEntry(
            JournalEntryDraft(notes: d.notes, rating: d.rating));
      } else if (entryId != null) {
        await _journal.updateEntry(entryId,
            notes: d.notes, rating: d.rating);
      }
      await (_db.update(_db.beans)..where((b) => b.id.equals(id)))
          .write(_companion(d, entryId));
    });
  }

  /// Attaches a photo, creating the entry if the bag had no story yet.
  Future<void> addPhoto(int id, JournalPhotoDraft photo) {
    return _db.transaction(() async {
      final bean = await (_db.select(_db.beans)
            ..where((b) => b.id.equals(id)))
          .getSingle();
      var entryId = bean.journalEntryId;
      if (entryId == null) {
        entryId = await _journal.createEntry(const JournalEntryDraft());
        await (_db.update(_db.beans)..where((b) => b.id.equals(id)))
            .write(BeansCompanion(journalEntryId: Value(entryId)));
      }
      await _journal.addPhoto(entryId, photo);
    });
  }

  /// Removes one photo (row and file).
  Future<void> removePhoto(int photoId) => _journal.removePhoto(photoId);

  /// How many brews a delete would take with it.
  Future<int> brewCount(int id) async {
    final countExp = _db.brews.id.count();
    final query = _db.selectOnly(_db.brews)
      ..addColumns([countExp])
      ..where(_db.brews.beanId.equals(id));
    return (await query.getSingle()).read(countExp)!;
  }

  /// Brews cascade with the bean; their journal entries (and photo
  /// files) are deleted explicitly since the FK points domain -> entry.
  Future<void> delete(int id) async {
    final brewEntryId = _db.brews.journalEntryId;
    final query = _db.selectOnly(_db.brews)
      ..addColumns([brewEntryId])
      ..where(_db.brews.beanId.equals(id) & brewEntryId.isNotNull());
    final entryIds = [
      for (final row in await query.get()) row.read(brewEntryId)!,
    ];
    final bean = await (_db.select(_db.beans)
          ..where((b) => b.id.equals(id)))
        .getSingleOrNull();
    if (bean?.journalEntryId != null) entryIds.add(bean!.journalEntryId!);
    await (_db.delete(_db.beans)..where((b) => b.id.equals(id))).go();
    if (entryIds.isNotEmpty) await _journal.deleteEntries(entryIds);
  }

  Stream<List<BeanWithStory>> _withStories(Stream<List<Bean>> beans) {
    final entries = _db.select(_db.appJournalEntries).watch();
    final photos = (_db.select(_db.appJournalPhotos)
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .watch();
    return beans
        .combineLatest(
            entries, (List<Bean> b, List<JournalEntry> e) => (b, e))
        .combineLatest(photos, (pair, List<JournalPhoto> p) {
      final (beanRows, entryRows) = pair;
      final byId = {for (final e in entryRows) e.id: e};
      return [
        for (final bean in beanRows)
          BeanWithStory(
            bean,
            entry: byId[bean.journalEntryId],
            photos: [
              for (final photo in p)
                if (photo.entryId == bean.journalEntryId) photo,
            ],
          ),
      ];
    });
  }

  BeansCompanion _companion(BeanDraft d, int? entryId) =>
      BeansCompanion.insert(
        roaster: d.roaster,
        name: d.name,
        origin: Value(d.origin),
        region: Value(d.region),
        process: Value(d.process),
        processLabel: Value(d.processLabel),
        roastLevel: Value(d.roastLevel),
        priceBagCents: Value(d.priceBagCents),
        bagSizeG: Value(d.bagSizeG),
        roastDate: Value(d.roastDate),
        openedDate: Value(d.openedDate),
        finishedDate: Value(d.finishedDate),
        journalEntryId: Value(entryId),
      );
}
