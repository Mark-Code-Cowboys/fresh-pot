import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../backup/backup_service.dart';
import '../utils/labels.dart';

/// Writes exports to temp files and hands them to the share sheet.
/// The temp directory is injected so tests stay plugin-free.
class ExportService {
  ExportService(this._db, this._share, this._tempDir,
      {PhotoService? photos})
      : _photos = photos; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final ShareLauncher _share;
  final Future<Directory> Function() _tempDir;
  final PhotoService? _photos;

  static String _stamp(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Every bag as a CSV row with its tasting notes — the archive the
  /// incumbents wouldn't give back. Returns the written file.
  Future<File> shareBeansCsv({DateTime? now}) async {
    final beans = await (_db.select(_db.beans)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    final entries = {
      for (final e in await _db.select(_db.appJournalEntries).get()) e.id: e,
    };

    final csv = buildCsv([
      [
        'roaster', 'name', 'origin', 'region', 'process', 'roast_level',
        'roast_date', 'opened', 'finished', 'price', 'bag_size_g',
        'rating', 'notes',
      ],
      for (final b in beans)
        [
          b.roaster,
          b.name,
          b.origin,
          b.region,
          b.process == null ? null : beanProcessLabel(b),
          b.roastLevel?.label,
          b.roastDate?.toIso8601String().substring(0, 10),
          b.openedDate?.toIso8601String().substring(0, 10),
          b.finishedDate?.toIso8601String().substring(0, 10),
          b.priceBagCents == null
              ? null
              : (b.priceBagCents! / 100).toStringAsFixed(2),
          b.bagSizeG,
          entries[b.journalEntryId]?.rating,
          entries[b.journalEntryId]?.notes,
        ],
    ]);

    final stamp = _stamp(now ?? DateTime.now());
    final file =
        File('${(await _tempDir()).path}/freshpot-beans-$stamp.csv');
    await file.writeAsString(csv);
    await _share.shareFile(file.path,
        mimeType: 'text/csv', text: 'Fresh Pot notes ($stamp)');
    return file;
  }

  /// The full journal as one zip: export JSON plus bag photo files.
  Future<File> shareBackup(
      {required int lifetimeBeans, DateTime? now}) async {
    final store = _photos;
    final bytes = buildBackupArchive(
      exportData:
          await buildExportData(_db, lifetimeBeans: lifetimeBeans, now: now),
      media: store == null
          ? const {}
          : await _db.journal().collectMedia(store),
    );
    final stamp = _stamp(now ?? DateTime.now());
    final file =
        File('${(await _tempDir()).path}/freshpot-backup-$stamp.zip');
    await file.writeAsBytes(bytes);
    await _share.shareFile(file.path,
        mimeType: 'application/zip', text: 'Fresh Pot backup ($stamp)');
    return file;
  }
}
