import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';
import 'package:fresh_pot/data/repositories/gear_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late BeanRepository beans;
  late BrewRepository brews;
  late int beanId;

  setUp(() async {
    db = makeTestDb();
    beans = BeanRepository(db);
    brews = BrewRepository(db);
    beanId = await beans.create(beanDraft());
  });

  tearDown(() => db.close());

  test('a pour-over logs water in; ratio computes', () async {
    await brews.create(beanId,
        brewDraft(doseG: 15, waterG: 250, rating: 4, notes: 'Sweet.'));
    final cup = (await brews.watchForBean(beanId).first).single;
    expect(cup.ratio, closeTo(16.67, 0.01));
    expect(cup.rating, 4);
    expect(cup.notes, 'Sweet.');
  });

  test('espresso logs yield out; the CHECK forbids logging both',
      () async {
    await brews.create(
        beanId,
        brewDraft(
            method: BrewMethod.espresso,
            doseG: 18,
            waterG: null,
            yieldG: 36));
    final shot = (await brews.watchForBean(beanId).first).single;
    expect(shot.ratio, 2.0);

    expect(
        () => brewDraft(doseG: 18, waterG: 250, yieldG: 36),
        throwsA(isA<AssertionError>()));
  });

  test('newest first, and latestForBean feeds repeat-last-brew',
      () async {
    await brews.create(beanId,
        brewDraft(brewedAt: DateTime(2026, 9, 1), grindSetting: '18'));
    await brews.create(beanId,
        brewDraft(brewedAt: DateTime(2026, 9, 4), grindSetting: '17'));
    final list = await brews.watchForBean(beanId).first;
    expect([for (final b in list) b.brew.grindSetting], ['17', '18']);
    expect((await brews.latestForBean(beanId))!.grindSetting, '17');
  });

  test('deleting a grinder keeps the brew, nulls the context link',
      () async {
    final gear = GearRepository(db);
    final grinderId = await gear.create(const GearDraft(
        kind: GearKind.grinder, name: 'Encore'));
    await brews.create(beanId,
        brewDraft(grindSetting: '18', grinderGearId: grinderId));
    await gear.delete(grinderId);
    final cup = (await brews.watchForBean(beanId).first).single;
    expect(cup.brew.grinderGearId, isNull);
    expect(cup.brew.grindSetting, '18'); // freeform value survives
  });

  test('update edits fields and grows a story', () async {
    final id = await brews.create(beanId, brewDraft());
    await brews.update(id,
        brewDraft(doseG: 16, waterG: 260, rating: 5, notes: 'Better.'));
    final cup = (await brews.watchForBean(beanId).first).single;
    expect(cup.brew.doseG, 16);
    expect(cup.rating, 5);
  });

  test('delete removes the brew and its entry', () async {
    final id =
        await brews.create(beanId, brewDraft(notes: 'gone soon'));
    await brews.delete(id);
    expect(await brews.watchForBean(beanId).first, isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
  });
}
