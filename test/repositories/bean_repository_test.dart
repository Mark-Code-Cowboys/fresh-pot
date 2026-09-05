import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late BeanRepository beans;

  setUp(() {
    db = makeTestDb();
    beans = BeanRepository(db);
  });

  tearDown(() => db.close());

  test('create stores the bag and its story atomically', () async {
    final id = await beans.create(beanDraft(
      rating: 4,
      notes: 'Blueberry up front, fades by week three.',
      photos: const [JournalPhotoDraft(path: 'bag-1.jpg')],
    ));
    final bag = (await beans.watchOne(id).first)!;
    expect(bag.bean.roaster, 'Copper Kettle');
    expect(bag.rating, 4);
    expect(bag.notes, contains('Blueberry'));
    expect(bag.photos.single.path, 'bag-1.jpg');
    expect(await beans.count(), 1);
  });

  test('active bag = opened and not finished', () async {
    final id = await beans.create(beanDraft(openedDate: DateTime(2026, 9, 1)));
    expect((await beans.watchOne(id).first)!.isActive, isTrue);
    await beans.update(
        id,
        beanDraft(
            openedDate: DateTime(2026, 9, 1),
            finishedDate: DateTime(2026, 9, 20)));
    expect((await beans.watchOne(id).first)!.isActive, isFalse);
  });

  test('update grows a story onto a storyless bag', () async {
    final id = await beans.create(beanDraft());
    await beans.update(id, beanDraft(rating: 5, notes: 'Dialed in.'));
    final bag = (await beans.watchOne(id).first)!;
    expect(bag.rating, 5);
    expect(bag.notes, 'Dialed in.');
  });

  test('lifetimeCreated never drops below the live count', () async {
    final tally = LifetimeTally(InMemoryKeyValueStore(),
        key: 'beans_created_lifetime');
    addTearDown(tally.dispose);
    final repo = BeanRepository(db, tally: tally);
    await repo.create(beanDraft(name: 'A'));
    await repo.create(beanDraft(name: 'B'));
    expect(await repo.lifetimeCreated(), 2);
    await repo.delete((await repo.getAll()).first.id);
    // The slot is spent even though the row is gone.
    expect(await repo.lifetimeCreated(), 2);
  });

  test('delete takes brews and every journal entry (photos included) '
      'with it', () async {
    final id = await beans.create(beanDraft(
        notes: 'bag story',
        photos: const [JournalPhotoDraft(path: 'bag.jpg')]));
    final brews = BrewRepository(db);
    await brews.create(id, brewDraft(notes: 'first cup'));
    expect(await beans.brewCount(id), 1);

    await beans.delete(id);
    expect(await beans.count(), 0);
    expect(await db.select(db.brews).get(), isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
    expect(await db.select(db.appJournalPhotos).get(), isEmpty);
  });
}
