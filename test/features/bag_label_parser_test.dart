import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/features/scan_import/bag_label_parser.dart';

void main() {
  test('transcribes a full bag label', () {
    final reading = parseBagLabel(const [
      // Roaster shouted biggest, top of the bag.
      OcrLine('COPPER KETTLE COFFEE', left: 0, top: 0, height: 44),
      OcrLine('GUJI HIGHLANDS', left: 0, top: 60, height: 30),
      OcrLine('Ethiopia · Guji Zone', left: 0, top: 110, height: 18),
      OcrLine('Washed · 2100 masl', left: 0, top: 140, height: 16),
      OcrLine('Roast date 8/28/2026', left: 0, top: 400, height: 14),
    ])!;
    expect(reading.roaster, 'Copper Kettle Coffee');
    expect(reading.name, 'Guji Highlands');
    expect(reading.origin, 'Ethiopia');
    expect(reading.process, RoastProcess.washed);
    expect(reading.roastDate, DateTime(2026, 8, 28));
  });

  test('missing fields stay null — never guessed', () {
    final reading = parseBagLabel(const [
      OcrLine('Blue Door Roastery', left: 0, top: 0, height: 40),
    ])!;
    expect(reading.roaster, 'Blue Door Roastery');
    expect(reading.name, isNull);
    expect(reading.origin, isNull);
    expect(reading.process, isNull);
    expect(reading.roastDate, isNull);
  });

  test('null when the photo had no text', () {
    expect(parseBagLabel(const []), isNull);
  });
}
