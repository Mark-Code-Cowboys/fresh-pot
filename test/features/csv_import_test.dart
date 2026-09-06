import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/features/scan_import/csv_importer.dart';

import '../helpers.dart';

void main() {
  test('guesses spreadsheet-keeper headers', () {
    final mapping = guessCsvMapping(
      ['Coffee', 'Roaster', 'Country', 'Process', 'Roast Date', 'Price',
          'Rating', 'Tasting Notes'],
      fpCsvFields,
    );
    expect(mapping, {
      'name': 0,
      'roaster': 1,
      'origin': 2,
      'region': null,
      'process': 3,
      'roastDate': 4,
      'price': 5,
      'rating': 6,
      'notes': 7,
    });
  });

  test('parseProcessCell keeps the user\'s own word for the unknown',
      () {
    expect(parseProcessCell('Washed'), (RoastProcess.washed, null));
    expect(parseProcessCell('Natural anaerobic'),
        (RoastProcess.natural, null));
    expect(parseProcessCell('Carbonic maceration'),
        (RoastProcess.other, 'Carbonic maceration'));
    expect(parseProcessCell(null), (null, null));
  });

  group('importCsvBeans', () {
    late AppDatabase db;
    late BeanRepository beans;

    setUp(() {
      db = makeTestDb();
      beans = BeanRepository(db);
    });

    tearDown(() => db.close());

    final doc = parseCsv('Coffee,Roaster,Country,Process,Roast Date,'
        'Price,Rating,Tasting Notes\n'
        'Guji Highlands,Copper Kettle,Ethiopia,Washed,8/28/2026,'
        '\$18.00,5,Blueberry bomb\n'
        'Mystery Blend,,,,,,9,\n'
        ',No Name Roasters,,,,,,\n');
    final mapping = guessCsvMapping(doc.header, fpCsvFields);

    Future<CsvImportReport> run({bool entitled = true}) => importCsvBeans(
        beans: beans, doc: doc, mapping: mapping, entitled: entitled);

    test('imports rows, validates rating, conventions the roaster',
        () async {
      final report = await run();
      expect(report.beansAdded, 2);
      expect(report.rowsSkipped, 1); // the nameless row

      final all = await beans.getAll();
      final guji = all.singleWhere((b) => b.name == 'Guji Highlands');
      expect(guji.roaster, 'Copper Kettle');
      expect(guji.origin, 'Ethiopia');
      expect(guji.process, RoastProcess.washed);
      expect(guji.roastDate, DateTime(2026, 8, 28));
      expect(guji.priceBagCents, 1800);
      final story = (await beans.watchOne(guji.id).first)!;
      expect(story.rating, 5);
      expect(story.notes, 'Blueberry bomb');

      final mystery = all.singleWhere((b) => b.name == 'Mystery Blend');
      expect(mystery.roaster, unknownRoaster);
      final mysteryStory = (await beans.watchOne(mystery.id).first)!;
      expect(mysteryStory.rating, isNull); // 9 isn't a rating
    });

    test('re-importing the same export never duplicates', () async {
      await run();
      final report = await run();
      expect(report.beansAdded, 0);
      expect(await beans.count(), 2);
    });

    test('free users stop at the cap; rows past it are counted',
        () async {
      for (var i = 0; i < 4; i++) {
        await beans.create(beanDraft(name: 'Filler $i'));
      }
      final report = await run(entitled: false);
      // One slot left: Guji lands, Mystery Blend is past the cap.
      expect(report.beansAdded, 1);
      expect(report.beansSkippedAtCap, 1);
      expect(await beans.count(), 5);
    });
  });
}
