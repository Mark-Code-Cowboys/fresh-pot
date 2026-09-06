import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/bean_repository.dart';

/// One group's average rating: "Copper Kettle · 4.5 over 3 bags".
typedef GroupRating = ({String label, double avg, int count});

/// Average bag rating per group (roaster, origin, ...), rated bags
/// only, best first (ties broken by more bags, then A-Z). Groups with
/// nothing rated don't appear — never invented.
List<GroupRating> ratingByGroup(
    List<BeanWithStory> bags, String? Function(BeanWithStory) groupOf) {
  final sums = <String, (int total, int count)>{};
  for (final bag in bags) {
    final rating = bag.rating;
    final group = groupOf(bag)?.trim();
    if (rating == null || group == null || group.isEmpty) continue;
    final (total, count) = sums[group] ?? (0, 0);
    sums[group] = (total + rating, count + 1);
  }
  final rows = [
    for (final e in sums.entries)
      (label: e.key, avg: e.value.$1 / e.value.$2, count: e.value.$2),
  ]..sort((a, b) {
      final byAvg = b.avg.compareTo(a.avg);
      if (byAvg != 0) return byAvg;
      final byCount = b.count.compareTo(a.count);
      return byCount != 0 ? byCount : a.label.compareTo(b.label);
    });
  return rows;
}

/// Rating by roaster.
List<GroupRating> ratingByRoaster(List<BeanWithStory> bags) =>
    ratingByGroup(bags, (b) => b.bean.roaster);

/// Rating by origin (bags without one don't appear).
List<GroupRating> ratingByOrigin(List<BeanWithStory> bags) =>
    ratingByGroup(bags, (b) => b.bean.origin);

/// Brews per calendar day — the brewing-calendar heatmap's fill.
Map<DateTime, int> brewsPerDay(List<Brew> brews) {
  final byDay = <DateTime, int>{};
  for (final b in brews) {
    final day =
        DateTime(b.brewedAt.year, b.brewedAt.month, b.brewedAt.day);
    byDay[day] = (byDay[day] ?? 0) + 1;
  }
  return byDay;
}

/// Bag price over time (priced bags only, by the day they were added),
/// in dollars for the chart.
List<(DateTime, num)> pricePoints(List<Bean> beans) {
  final priced = [
    for (final b in beans)
      if (b.priceBagCents != null)
        (b.createdAt, b.priceBagCents! / 100 as num),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  return priced;
}

/// How the cups get made: method label -> count, most-brewed first.
List<(String, int)> methodDistribution(List<Brew> brews) {
  final counts = <String, int>{};
  for (final b in brews) {
    final label = brewMethodLabel(b);
    counts[label] = (counts[label] ?? 0) + 1;
  }
  final rows = counts.entries.map((e) => (e.key, e.value)).toList()
    ..sort((a, b) {
      final byCount = b.$2.compareTo(a.$2);
      return byCount != 0 ? byCount : a.$1.compareTo(b.$1);
    });
  return rows;
}
