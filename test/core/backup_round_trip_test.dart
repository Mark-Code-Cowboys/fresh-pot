import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_pot/core/backup/backup_service.dart';
import 'package:fresh_pot/core/export/export_service.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';
import 'package:fresh_pot/data/repositories/gear_repository.dart';

import '../helpers.dart';

void main() {
  test('backup archive round-trips the whole journal and the tally',
      () async {
    final source = makeTestDb();
    addTearDown(source.close);
    final beans = BeanRepository(source);
    final brews = BrewRepository(source);
    final gear = GearRepository(source);

    final beanId = await beans.create(beanDraft(
      rating: 5,
      notes: 'Blueberry bomb.',
      priceBagCents: 1800,
      photos: const [JournalPhotoDraft(path: 'bag-1.jpg', caption: 'the bag')],
    ));
    final grinderId = await gear
        .create(const GearDraft(kind: GearKind.grinder, name: 'Encore'));
    await brews.create(
        beanId,
        brewDraft(
            doseG: 15,
            waterG: 250,
            grindSetting: '17',
            grinderGearId: grinderId,
            rating: 4,
            notes: 'Sweet.'));

    // Lifetime figure larger than the row count (a deleted bag).
    final bytes = buildBackupArchive(
      exportData: await buildExportData(source,
          lifetimeBeans: 7, now: DateTime(2026, 9, 5)),
      media: {
        'bag-1.jpg': [1, 2, 3],
      },
    );

    // Restore into a fresh database, as after a reinstall.
    final target = makeTestDb();
    addTearDown(target.close);
    final tally = LifetimeTally(InMemoryKeyValueStore(),
        key: 'beans_created_lifetime');
    addTearDown(tally.dispose);

    final contents = readBackupArchive(bytes);
    expect(contents.media['bag-1.jpg'], [1, 2, 3]);
    final lifetime = await restoreFromExportData(target, contents.exportData);
    await tally.raiseTo(lifetime);

    expect(await tally.value(), 7);
    final restored = await buildExportData(target,
        lifetimeBeans: 7, now: DateTime(2026, 9, 5));
    expect(restored, contents.exportData);

    // Spot checks through the repositories.
    final bag =
        (await BeanRepository(target).watchOne(beanId).first)!;
    expect(bag.rating, 5);
    expect(bag.notes, 'Blueberry bomb.');
    expect(bag.photos.single.caption, 'the bag');
    final cup =
        (await BrewRepository(target).watchForBean(beanId).first).single;
    expect(cup.notes, 'Sweet.');
    expect(cup.brew.grinderGearId, grinderId);
  });

  test('restore rejects foreign or malformed exports', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    expect(
      () => restoreFromExportData(db, {'app': 'HitchPost', 'format': 1}),
      throwsA(isA<InvalidBackupException>()),
    );
    expect(
      () => restoreFromExportData(
          db, {'app': 'FreshPot', 'format': 1, 'beans': 'nope'}),
      throwsA(isA<InvalidBackupException>()),
    );
  });

  test('CSV export flattens the bag and its story into one row',
      () async {
    final db = makeTestDb();
    addTearDown(db.close);
    await BeanRepository(db).create(beanDraft(
        rating: 5,
        notes: 'Blueberry bomb',
        priceBagCents: 1800,
        roastDate: DateTime(2026, 8, 28)));

    final share = FakeShareLauncher();
    final temp = await Directory.systemTemp.createTemp('fp-export');
    addTearDown(() => temp.delete(recursive: true));
    final file = await ExportService(db, share, () async => temp)
        .shareBeansCsv(now: DateTime(2026, 9, 5));

    expect(share.sharedFiles, [file.path]);
    expect(file.path, endsWith('freshpot-beans-2026-09-05.csv'));
    final doc = parseCsv(await file.readAsString());
    final row = doc.rows.single;
    expect(doc.rowCell(row, 0), 'Copper Kettle');
    expect(doc.rowCell(row, doc.header.indexOf('roast_date')), '2026-08-28');
    expect(doc.rowCell(row, doc.header.indexOf('price')), '18.00');
    expect(doc.rowCell(row, doc.header.indexOf('rating')), '5');
    expect(doc.rowCell(row, doc.header.indexOf('notes')), 'Blueberry bomb');
  });
}
