import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// A piece of gear being composed.
class GearDraft {
  const GearDraft({
    required this.kind,
    this.kindLabel,
    required this.name,
    this.notes,
  });

  final GearKind kind;
  final String? kindLabel;
  final String name;
  final String? notes;
}

class GearRepository {
  GearRepository(this._db);

  final AppDatabase _db;

  /// The whole bench, A-Z.
  Stream<List<GearData>> watchAll() {
    final query = _db.select(_db.gear)
      ..orderBy([(g) => OrderingTerm.asc(g.name.lower())]);
    return query.watch();
  }

  /// Grinders only — the brew composer's grind-setting context picker.
  Stream<List<GearData>> watchGrinders() {
    final query = _db.select(_db.gear)
      ..where((g) => g.kind.equalsValue(GearKind.grinder))
      ..orderBy([(g) => OrderingTerm.asc(g.name.lower())]);
    return query.watch();
  }

  Future<int> create(GearDraft d) =>
      _db.into(_db.gear).insert(_companion(d));

  Future<void> update(int id, GearDraft d) {
    return (_db.update(_db.gear)..where((g) => g.id.equals(id)))
        .write(_companion(d));
  }

  /// Deletes the gear; brews that referenced it keep their freeform
  /// grind setting, the context link just goes null (FK SET NULL).
  Future<void> delete(int id) =>
      (_db.delete(_db.gear)..where((g) => g.id.equals(id))).go();

  GearCompanion _companion(GearDraft d) => GearCompanion.insert(
        kind: d.kind,
        kindLabel: Value(d.kindLabel),
        name: d.name,
        notes: Value(d.notes),
      );
}
