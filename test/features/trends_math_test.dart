import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/features/trends/trends_math.dart';

import '../helpers.dart';

Bean bean(int id,
        {String roaster = 'Copper Kettle',
        String? origin,
        int? priceCents,
        DateTime? createdAt}) =>
    Bean(
      id: id,
      roaster: roaster,
      name: 'Bag $id',
      origin: origin,
      region: null,
      process: null,
      processLabel: null,
      roastLevel: null,
      priceBagCents: priceCents,
      bagSizeG: null,
      roastDate: null,
      openedDate: null,
      finishedDate: null,
      createdAt: createdAt ?? DateTime(2026, 9, id),
      journalEntryId: id,
    );

BeanWithStory rated(int id,
        {String roaster = 'Copper Kettle', String? origin, int? rating}) =>
    BeanWithStory(bean(id, roaster: roaster, origin: origin),
        entry: rating == null ? null : entryFor(id, rating: rating));

void main() {
  test('ratingByRoaster averages rated bags only, best first', () {
    final rows = ratingByRoaster([
      rated(1, roaster: 'Copper Kettle', rating: 5),
      rated(2, roaster: 'Copper Kettle', rating: 4),
      rated(3, roaster: 'Blue Door', rating: 5),
      rated(4, roaster: 'Unrated Roasters'), // no rating: absent
    ]);
    expect(rows, hasLength(2));
    expect(rows.first.label, 'Blue Door'); // 5.0 beats 4.5
    expect(rows.last, (label: 'Copper Kettle', avg: 4.5, count: 2));
  });

  test('ratingByOrigin skips bags without one', () {
    final rows = ratingByOrigin([
      rated(1, origin: 'Ethiopia', rating: 4),
      rated(2, rating: 5), // no origin
    ]);
    expect(rows.single.label, 'Ethiopia');
  });

  test('brewsPerDay buckets by calendar day', () {
    final perDay = brewsPerDay([
      brewFor(1),
      brewFor(1),
      brewFor(2),
    ]);
    expect(perDay[DateTime(2026, 9, 1)], 2);
    expect(perDay[DateTime(2026, 9, 2)], 1);
  });

  test('pricePoints: priced bags only, in date order, in dollars', () {
    final points = pricePoints([
      bean(2, priceCents: 2100, createdAt: DateTime(2026, 8, 1)),
      bean(1, priceCents: 1800, createdAt: DateTime(2026, 6, 1)),
      bean(3), // unpriced: absent
    ]);
    expect(points, [
      (DateTime(2026, 6, 1), 18.0),
      (DateTime(2026, 8, 1), 21.0),
    ]);
  });

  test('methodDistribution counts by display label, most-brewed first',
      () {
    final rows = methodDistribution([
      brewFor(1),
      brewFor(2),
      Brew(
        id: 3,
        beanId: 1,
        method: BrewMethod.other,
        methodLabel: 'Turkish',
        doseG: null,
        waterG: null,
        yieldG: null,
        grindSetting: null,
        grinderGearId: null,
        tempF: null,
        timeSec: null,
        brewedAt: DateTime(2026, 9, 3),
        journalEntryId: null,
      ),
    ]);
    expect(rows.first, ('V60', 2));
    expect(rows.last, ('Turkish', 1)); // the user's own word
  });
}
