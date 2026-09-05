/// The brew ratio: water (or espresso yield) over dose. Null when the
/// numbers aren't there — never invented from partial input.
double? brewRatio({double? doseG, double? waterG, double? yieldG}) {
  final out = waterG ?? yieldG;
  if (doseG == null || doseG <= 0 || out == null) return null;
  return out / doseG;
}

/// "1:16.7" (one decimal, trimmed to "1:2" when it's whole) — the way
/// ratios are said at the bench.
String formatRatio(double ratio) {
  final rounded = (ratio * 10).round() / 10;
  final text = rounded == rounded.roundToDouble()
      ? rounded.round().toString()
      : rounded.toStringAsFixed(1);
  return '1:$text';
}
