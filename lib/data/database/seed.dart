import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import 'app_database.dart';

/// Demo journal for screenshots and store listing shots:
/// `flutter run --dart-define=DEMO_SEED=true`
///
/// Exactly 8 bags and 60 brews across the methods, with the kind of
/// notes the app exists for; one bag on the counter for the home shot.
/// No-op unless the journal is empty, so a real journal is never
/// polluted.
Future<void> seedDemoData(AppDatabase db) async {
  final existing = await db.select(db.beans).get();
  if (existing.isNotEmpty) return;

  final journal = db.journal();

  Future<int> bag(
    String roaster,
    String name, {
    String? origin,
    String? region,
    RoastProcess? process,
    RoastLevel? roastLevel,
    int? priceCents,
    int? sizeG,
    DateTime? roastDate,
    DateTime? openedDate,
    DateTime? finishedDate,
    int? rating,
    String? notes,
  }) async {
    int? entryId;
    if (rating != null || notes != null) {
      entryId = await journal
          .createEntry(JournalEntryDraft(notes: notes, rating: rating));
    }
    return db.into(db.beans).insert(BeansCompanion.insert(
          roaster: roaster,
          name: name,
          origin: Value(origin),
          region: Value(region),
          process: Value(process),
          roastLevel: Value(roastLevel),
          priceBagCents: Value(priceCents),
          bagSizeG: Value(sizeG),
          roastDate: Value(roastDate),
          openedDate: Value(openedDate),
          finishedDate: Value(finishedDate),
          journalEntryId: Value(entryId),
        ));
  }

  final grinder = await db.into(db.gear).insert(GearCompanion.insert(
      kind: GearKind.grinder,
      name: 'Baratza Encore',
      notes: const Value('Stock burrs. Numbers below are its dial.')));
  await db.into(db.gear).insert(GearCompanion.insert(
      kind: GearKind.brewer, name: 'Hario V60-02'));
  await db.into(db.gear).insert(GearCompanion.insert(
      kind: GearKind.kettle,
      name: 'Stagg EKG',
      notes: const Value('205°F for lights, 200 for the rest.')));

  var brewsPlanted = 0;
  Future<void> brew(
    int beanId,
    DateTime brewedAt, {
    BrewMethod method = BrewMethod.v60,
    double? dose = 15,
    double? water = 250,
    double? yieldG,
    String? grind = '17',
    int? tempF = 205,
    int? timeSec = 165,
    int? rating,
    String? notes,
  }) async {
    int? entryId;
    if (rating != null || notes != null) {
      entryId = await journal
          .createEntry(JournalEntryDraft(notes: notes, rating: rating));
    }
    await db.into(db.brews).insert(BrewsCompanion.insert(
          beanId: beanId,
          method: method,
          doseG: Value(dose),
          waterG: Value(water),
          yieldG: Value(yieldG),
          grindSetting: Value(grind),
          grinderGearId: Value(grinder),
          tempF: Value(tempF),
          timeSec: Value(timeSec),
          brewedAt: Value(brewedAt),
          journalEntryId: Value(entryId),
        ));
    brewsPlanted++;
  }

  // --- The 8 bags ---
  final guji = await bag('Copper Kettle', 'Guji Highlands',
      origin: 'Ethiopia', region: 'Guji',
      process: RoastProcess.washed, roastLevel: RoastLevel.light,
      priceCents: 1950, sizeG: 250,
      roastDate: DateTime(2026, 8, 25), openedDate: DateTime(2026, 8, 30),
      rating: 5,
      notes: 'Blueberry up front, black tea finish. The bag that '
          'started the light-roast phase.');
  final huila = await bag('Copper Kettle', 'Huila Decaf',
      origin: 'Colombia', region: 'Huila',
      process: RoastProcess.other, roastLevel: RoastLevel.medium,
      priceCents: 1700, sizeG: 250,
      roastDate: DateTime(2026, 8, 20), openedDate: DateTime(2026, 8, 26),
      rating: 3, notes: 'EA decaf. Fine after dinner, nothing to chase.');
  final gesha = await bag('Blue Door', 'La Esperanza Gesha',
      origin: 'Colombia',
      process: RoastProcess.washed, roastLevel: RoastLevel.light,
      priceCents: 3400, sizeG: 200,
      roastDate: DateTime(2026, 7, 14), openedDate: DateTime(2026, 7, 20),
      finishedDate: DateTime(2026, 8, 8),
      rating: 5, notes: 'Jasmine like a candle shop. Worth it exactly '
          'once a year.');
  final comet = await bag('Blue Door', 'Comet Blend',
      origin: 'Brazil',
      process: RoastProcess.natural, roastLevel: RoastLevel.medDark,
      priceCents: 1500, sizeG: 340,
      roastDate: DateTime(2026, 6, 2), openedDate: DateTime(2026, 6, 8),
      finishedDate: DateTime(2026, 7, 2),
      rating: 4, notes: 'The espresso workhorse. Chocolate, no drama.');
  final kiaga = await bag('Northbound Roasters', 'Kiaga AB',
      origin: 'Kenya',
      process: RoastProcess.washed, roastLevel: RoastLevel.medLight,
      priceCents: 2200, sizeG: 250,
      roastDate: DateTime(2026, 5, 10), openedDate: DateTime(2026, 5, 15),
      finishedDate: DateTime(2026, 6, 6),
      rating: 4, notes: 'Blackcurrant when hot, tomato when I over-pull '
          'the ratio. Keep it at 1:16.');
  final anaerobic = await bag('Northbound Roasters', 'El Vergel Anaerobic',
      origin: 'Colombia',
      process: RoastProcess.anaerobic, roastLevel: RoastLevel.light,
      priceCents: 2600, sizeG: 250,
      roastDate: DateTime(2026, 4, 1), openedDate: DateTime(2026, 4, 7),
      finishedDate: DateTime(2026, 4, 30),
      rating: 2, notes: 'Tastes like a wine cooler. Not for me — noted '
          'so I stop rebuying funk.');
  final sumatra = await bag('Harbor Coffee', 'Lake Toba',
      origin: 'Sumatra',
      process: RoastProcess.other, roastLevel: RoastLevel.dark,
      priceCents: 1600, sizeG: 340,
      roastDate: DateTime(2026, 2, 12), openedDate: DateTime(2026, 2, 16),
      finishedDate: DateTime(2026, 3, 20),
      rating: 3, notes: 'Wet-hulled. Earthy, huge body; the French '
          'press bag.');
  final holiday = await bag('Harbor Coffee', 'Cold Brew Blend',
      origin: 'Brazil',
      process: RoastProcess.natural, roastLevel: RoastLevel.dark,
      priceCents: 1400, sizeG: 454,
      roastDate: DateTime(2026, 6, 20), openedDate: DateTime(2026, 6, 25),
      finishedDate: DateTime(2026, 8, 1),
      rating: 4, notes: 'Summer tank fuel. 1:8 concentrate, cut over ice.');

  // --- 60 brews across the methods ---
  // The Guji, dialed in over the last week (daily V60, 8 brews).
  await brew(guji, DateTime(2026, 8, 30, 7), grind: '19', timeSec: 150,
      rating: 3, notes: 'First cup. Fast drawdown — grind finer.');
  await brew(guji, DateTime(2026, 8, 31, 7), grind: '17', rating: 4,
      notes: 'Better. Sweetness arrived.');
  await brew(guji, DateTime(2026, 9, 1, 7), grind: '16', timeSec: 180,
      rating: 4, notes: 'A shade bitter at the end. Split the difference.');
  await brew(guji, DateTime(2026, 9, 2, 7), grind: '17', rating: 5,
      notes: 'There it is. Blueberry and all.');
  await brew(guji, DateTime(2026, 9, 3, 7), grind: '17', rating: 5);
  await brew(guji, DateTime(2026, 9, 3, 14), method: BrewMethod.aeropress,
      dose: 14, water: 220, grind: '14', timeSec: 120, rating: 4,
      notes: 'Travel kit at the office.');
  await brew(guji, DateTime(2026, 9, 4, 7), grind: '17', rating: 5);
  await brew(guji, DateTime(2026, 9, 5, 7), grind: '17');

  // Decaf evenings (6 brews).
  for (var day = 27; day <= 31; day++) {
    await brew(huila, DateTime(2026, 8, day, 20),
        method: BrewMethod.frenchPress,
        dose: 18, water: 300, grind: '28', tempF: 200, timeSec: 240,
        rating: day == 29 ? 3 : null);
  }
  await brew(huila, DateTime(2026, 9, 2, 20),
      method: BrewMethod.frenchPress,
      dose: 18, water: 300, grind: '28', tempF: 200, timeSec: 240);

  // The Gesha, treated with ceremony (5 brews).
  for (final (day, rating) in [(21, 4), (24, 5), (28, 5), (31, 5), (3, 4)]) {
    await brew(gesha, DateTime(2026, day <= 3 ? 8 : 7, day, 9),
        dose: 12, water: 200, grind: '18', tempF: 205, timeSec: 165,
        rating: rating,
        notes: rating == 5 ? 'Jasmine. Still can\'t believe it.' : null);
  }

  // Comet: the espresso month (18 shots, weekdays June 9 - July 2).
  for (var i = 0; i < 18; i++) {
    final date = DateTime(2026, 6, 9).add(Duration(days: i + (i ~/ 5) * 2));
    await brew(comet, DateTime(date.year, date.month, date.day, 6, 45),
        method: BrewMethod.espresso,
        dose: 18, water: null, yieldG: 36, grind: '8', tempF: 200,
        timeSec: 28,
        rating: i == 4 ? 5 : null,
        notes: i == 4 ? 'Dialed: 18 in, 36 out, 28 seconds.' : null);
  }

  // Kiaga: pour-overs through May (10 brews).
  for (var i = 0; i < 10; i++) {
    await brew(kiaga, DateTime(2026, 5, 16 + i * 2, 7),
        dose: 15, water: 240, grind: '17', tempF: 205, timeSec: 170,
        rating: i == 6 ? 4 : null,
        notes: i == 6 ? 'Blackcurrant day. 1:16 confirmed.' : null);
  }

  // The anaerobic experiment, abandoned early (3 brews).
  await brew(anaerobic, DateTime(2026, 4, 8, 8), rating: 2,
      notes: 'Funky. Maybe it settles?');
  await brew(anaerobic, DateTime(2026, 4, 12, 8), rating: 2,
      notes: 'It does not settle.');
  await brew(anaerobic, DateTime(2026, 4, 20, 8), method: BrewMethod.aeropress,
      dose: 14, water: 220, grind: '14', timeSec: 120, rating: 3,
      notes: 'AeroPress tames it a little. Still a wine cooler.');

  // Sumatra: French press winter (6 brews).
  for (var i = 0; i < 6; i++) {
    await brew(sumatra, DateTime(2026, 2, 18 + i * 5, 8),
        method: BrewMethod.frenchPress,
        dose: 20, water: 320, grind: '30', tempF: 200, timeSec: 240,
        rating: i == 2 ? 4 : null);
  }

  // Cold brew tanks, one a week through summer (4 brews).
  for (var i = 0; i < 4; i++) {
    await brew(holiday, DateTime(2026, 6, 28 + i * 7, 21),
        method: BrewMethod.coldBrew,
        dose: 80, water: 640, grind: '32', tempF: null, timeSec: null,
        rating: i == 1 ? 4 : null,
        notes: i == 1 ? '16 hours on the counter. 1:8, cut 1:1 over ice.'
            : null);
  }

  assert(brewsPlanted == 60, 'Seed drift: $brewsPlanted brews');
}
