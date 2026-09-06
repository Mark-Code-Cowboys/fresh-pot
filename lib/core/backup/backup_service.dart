import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';

/// The whole journal as a JSON-encodable map (format 1). Pure data —
/// photo files are referenced by store name; the backup archive
/// carries their bytes separately. Journal tables ride on cc_core's
/// dumpJournalTables (the fleet's canonical keys).
Future<Map<String, Object?>> buildExportData(
  AppDatabase db, {
  required int lifetimeBeans,
  DateTime? now,
}) async {
  final beans =
      await (db.select(db.beans)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final gear =
      await (db.select(db.gear)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final brews =
      await (db.select(db.brews)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();

  return {
    'app': 'FreshPot',
    'format': 1,
    'exportedAt': (now ?? DateTime.now()).toIso8601String(),
    // Carried so a restore never resets the free tier (raiseTo).
    'lifetimeBeans': lifetimeBeans,
    'beans': [
      for (final b in beans)
        {
          'id': b.id,
          'roaster': b.roaster,
          'name': b.name,
          'origin': b.origin,
          'region': b.region,
          'process': b.process?.name,
          'processLabel': b.processLabel,
          'roastLevel': b.roastLevel?.name,
          'priceBagCents': b.priceBagCents,
          'bagSizeG': b.bagSizeG,
          'roastDate': b.roastDate?.toIso8601String(),
          'openedDate': b.openedDate?.toIso8601String(),
          'finishedDate': b.finishedDate?.toIso8601String(),
          'createdAt': b.createdAt.toIso8601String(),
          'journalEntryId': b.journalEntryId,
        },
    ],
    'gear': [
      for (final g in gear)
        {
          'id': g.id,
          'kind': g.kind.name,
          'kindLabel': g.kindLabel,
          'name': g.name,
          'notes': g.notes,
        },
    ],
    'brews': [
      for (final b in brews)
        {
          'id': b.id,
          'beanId': b.beanId,
          'method': b.method.name,
          'methodLabel': b.methodLabel,
          'doseG': b.doseG,
          'waterG': b.waterG,
          'yieldG': b.yieldG,
          'grindSetting': b.grindSetting,
          'grinderGearId': b.grinderGearId,
          'tempF': b.tempF,
          'timeSec': b.timeSec,
          'brewedAt': b.brewedAt.toIso8601String(),
          'journalEntryId': b.journalEntryId,
        },
    ],
    ...await db.journal().dumpJournalTables(),
  };
}

DateTime? _date(Object? iso) =>
    iso == null ? null : DateTime.parse(iso as String);

/// Replaces the entire journal with the contents of an export. Runs in
/// one transaction; ids are preserved.
///
/// Returns the backup's lifetime-beans figure so the caller can
/// `raiseTo` the tally (never lowered).
Future<int> restoreFromExportData(
    AppDatabase db, Map<String, Object?> data) async {
  if (data['app'] != 'FreshPot' || data['format'] != 1) {
    throw const InvalidBackupException('Unrecognized export format');
  }
  final beans = data['beans'];
  final gear = data['gear'];
  final brews = data['brews'];
  if (beans is! List || gear is! List || brews is! List) {
    throw const InvalidBackupException('Malformed export tables');
  }

  await db.transaction(() async {
    await db.delete(db.gear).go();
    await db.delete(db.beans).go(); // brews cascade
    await db.journal().restoreJournalTables(data);

    for (final row in beans.cast<Map<String, dynamic>>()) {
      await db.into(db.beans).insert(BeansCompanion(
            id: Value(row['id'] as int),
            roaster: Value(row['roaster'] as String),
            name: Value(row['name'] as String),
            origin: Value(row['origin'] as String?),
            region: Value(row['region'] as String?),
            process: Value(switch (row['process'] as String?) {
              null => null,
              final name => RoastProcess.values.byName(name),
            }),
            processLabel: Value(row['processLabel'] as String?),
            roastLevel: Value(switch (row['roastLevel'] as String?) {
              null => null,
              final name => RoastLevel.values.byName(name),
            }),
            priceBagCents: Value(row['priceBagCents'] as int?),
            bagSizeG: Value(row['bagSizeG'] as int?),
            roastDate: Value(_date(row['roastDate'])),
            openedDate: Value(_date(row['openedDate'])),
            finishedDate: Value(_date(row['finishedDate'])),
            createdAt: Value(_date(row['createdAt'])!),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
    for (final row in gear.cast<Map<String, dynamic>>()) {
      await db.into(db.gear).insert(GearCompanion(
            id: Value(row['id'] as int),
            kind: Value(GearKind.values.byName(row['kind'] as String)),
            kindLabel: Value(row['kindLabel'] as String?),
            name: Value(row['name'] as String),
            notes: Value(row['notes'] as String?),
          ));
    }
    for (final row in brews.cast<Map<String, dynamic>>()) {
      await db.into(db.brews).insert(BrewsCompanion(
            id: Value(row['id'] as int),
            beanId: Value(row['beanId'] as int),
            method:
                Value(BrewMethod.values.byName(row['method'] as String)),
            methodLabel: Value(row['methodLabel'] as String?),
            doseG: Value((row['doseG'] as num?)?.toDouble()),
            waterG: Value((row['waterG'] as num?)?.toDouble()),
            yieldG: Value((row['yieldG'] as num?)?.toDouble()),
            grindSetting: Value(row['grindSetting'] as String?),
            grinderGearId: Value(row['grinderGearId'] as int?),
            tempF: Value(row['tempF'] as int?),
            timeSec: Value(row['timeSec'] as int?),
            brewedAt: Value(_date(row['brewedAt'])!),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
  });
  return (data['lifetimeBeans'] as num?)?.toInt() ?? beans.length;
}
