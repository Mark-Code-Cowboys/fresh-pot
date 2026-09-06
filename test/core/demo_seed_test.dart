import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_pot/data/database/seed.dart';

import '../helpers.dart';

void main() {
  test('DEMO_SEED plants exactly 8 bags and 60 brews across methods',
      () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);

    final beans = await db.select(db.beans).get();
    final brews = await db.select(db.brews).get();
    final gear = await db.select(db.gear).get();
    expect(beans, hasLength(8));
    expect(brews, hasLength(60));
    expect(gear, hasLength(3));

    // Across the methods — the distribution chart has something to say.
    final methods = brews.map((b) => b.method).toSet();
    expect(methods.length, greaterThanOrEqualTo(5));

    // Exactly one bag on the counter, for the home shot.
    final active = beans
        .where((b) => b.openedDate != null && b.finishedDate == null);
    expect(active, hasLength(2)); // Guji + the decaf evenings bag

    // Notes are the point — a healthy share of stories.
    final entries = await db.select(db.appJournalEntries).get();
    expect(entries.where((e) => e.notes != null).length,
        greaterThanOrEqualTo(20));
  });

  test('seeding is a no-op on a journal with data', () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);
    await seedDemoData(db);

    expect(await db.select(db.beans).get(), hasLength(8));
    expect(await db.select(db.brews).get(), hasLength(60));
  });
}
