import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/core/utils/brew_math.dart';

void main() {
  test('ratio is water (or espresso yield) over dose', () {
    expect(brewRatio(doseG: 15, waterG: 250), closeTo(16.67, 0.01));
    expect(brewRatio(doseG: 18, yieldG: 36), 2.0);
  });

  test('never invented from partial or nonsense input', () {
    expect(brewRatio(doseG: 15), isNull);
    expect(brewRatio(waterG: 250), isNull);
    expect(brewRatio(doseG: 0, waterG: 250), isNull);
  });

  test('formats the way ratios are said at the bench', () {
    expect(formatRatio(16.666), '1:16.7');
    expect(formatRatio(2.0), '1:2');
    expect(formatRatio(15.04), '1:15');
  });
}
