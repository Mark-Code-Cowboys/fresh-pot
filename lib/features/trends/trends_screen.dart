import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_service.dart';
import '../../core/export/export_service.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../home/home_screen.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'trends_math.dart';

/// Every brew in the journal, raw, for the trends math.
final allBrewsProvider = StreamProvider<List<Brew>>(
  (ref) => ref.watch(brewRepositoryProvider).watchAllRaw(),
);

/// The brewing year in numbers. Pro-only (the paywall's second
/// benefit); restore is never gated.
class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: pro
          ? const _TrendsContent()
          : ProTeaser(
              icon: Icons.insights_outlined,
              headline: 'Your brewing, in the aggregate.',
              body: 'Ratings by roaster and origin, the brewing '
                  'calendar, bag prices over time, and export — all '
                  'part of Fresh Pot Pro.',
              ctaLabel: 'See Fresh Pot Pro',
              onSeePro: () => showPaywallSheet(context),
              ungatedLabel: 'Restore a backup',
              onUngated: () => restoreBackupFlow(context, ref),
            ),
    );
  }
}

class _TrendsContent extends ConsumerStatefulWidget {
  const _TrendsContent();

  @override
  ConsumerState<_TrendsContent> createState() => _TrendsContentState();
}

class _TrendsContentState extends ConsumerState<_TrendsContent> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bags = ref.watch(beansProvider).value;
    final brews = ref.watch(allBrewsProvider).value;
    if (bags == null || brews == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final byRoaster = ratingByRoaster(bags);
    final byOrigin = ratingByOrigin(bags);
    final perDay = brewsPerDay(brews);
    final prices = pricePoints([for (final b in bags) b.bean]);
    final methods = methodDistribution(brews);
    final now = DateTime.now();

    Widget section(String title, Widget child) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              child,
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        section(
          'The journal so far',
          Text(
            countHeadline([
              CountedSubject(bags.length, 'bag'),
              CountedSubject(brews.length, 'brew'),
              CountedSubject(byRoaster.length, 'rated roaster'),
            ]),
            style: theme.textTheme.titleMedium,
          ),
        ),
        if (byRoaster.isNotEmpty)
          section('Rating by roaster', _RatingTable(rows: byRoaster)),
        if (byOrigin.isNotEmpty)
          section('Rating by origin', _RatingTable(rows: byOrigin)),
        section(
          'The brewing calendar',
          Column(
            children: [
              TrendWindowNav(
                label: '${_monthNames[_month.month - 1]} ${_month.year}',
                onPrev: () => setState(() =>
                    _month = DateTime(_month.year, _month.month - 1)),
                onNext: () => setState(() =>
                    _month = DateTime(_month.year, _month.month + 1)),
                nextEnabled: _month.isBefore(DateTime(now.year, now.month)),
              ),
              const SizedBox(height: 4),
              CalendarMonthGrid(
                year: _month.year,
                month: _month.month,
                dayBuilder: (context, date) =>
                    _DayCell(day: date.day, brews: perDay[date] ?? 0),
              ),
            ],
          ),
        ),
        section(
          'Bag prices',
          TrendGate(
            points: prices.length,
            minPoints: 3,
            nudge: 'Price three bags and the line appears — this is a '
                'journal, not a budgeting app.',
            builder: (_) => SimpleLineChart(points: prices),
          ),
        ),
        if (methods.isNotEmpty)
          section('How the cups get made', _MethodBars(rows: methods)),
        section(
          'Your notes, portable',
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('Share notes as CSV'),
                onPressed: () => _shareCsv(context),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Back up the whole journal'),
                onPressed: () => _shareBackup(context),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_backup_restore),
                label: const Text('Restore a backup'),
                onPressed: () => restoreBackupFlow(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ExportService _exporter() => ExportService(
        ref.read(databaseProvider),
        ref.read(shareLauncherProvider),
        ref.read(tempDirProvider),
        photos: ref.read(photoServiceProvider),
      );

  Future<void> _shareCsv(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter().shareBeansCsv();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _shareBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter().shareBackup(
          lifetimeBeans:
              await ref.read(beanRepositoryProvider).lifetimeCreated());
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    }
  }
}

/// "Copper Kettle ····· 4.5 (3)" rows, best first.
class _RatingTable extends StatelessWidget {
  const _RatingTable({required this.rows});

  final List<GroupRating> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final row in rows.take(8))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                    child: Text(row.label,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium)),
                RatingStars(rating: row.avg.round(), size: 14),
                const SizedBox(width: 8),
                Text(
                  '${row.avg.toStringAsFixed(1)} '
                  '(${row.count} ${row.count == 1 ? 'bag' : 'bags'})',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One calendar day, deepening with brew count. Transcription of the
/// journal, no judgement.
class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.brews});

  final int day;
  final int brews;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (brews) {
      0 => scheme.surfaceContainerHighest,
      1 => scheme.primary.withValues(alpha: 0.45),
      _ => scheme.primary,
    };
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: brews > 0 ? scheme.onPrimary : scheme.onSurfaceVariant),
      ),
    );
  }
}

/// Proportional bars: "V60 ███████ 34".
class _MethodBars extends StatelessWidget {
  const _MethodBars({required this.rows});

  final List<(String, int)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final max = rows.first.$2;
    return Column(
      children: [
        for (final (label, count) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(
                    width: 96,
                    child: Text(label,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: count / max,
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$count', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}

/// Pick a .zip backup, confirm the replace, restore, raise the tally.
/// Available to free users — restoring your own journal is never gated.
Future<void> restoreBackupFlow(BuildContext context, WidgetRef ref) async {
  const typeGroup = XTypeGroup(label: 'Backup', extensions: ['zip']);
  final picked = await openFile(acceptedTypeGroups: const [typeGroup]);
  if (picked == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Restore this backup?'),
      content: const Text(
          'The journal on this phone is replaced with the backup — '
          'beans, brews, and gear. This cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restore')),
      ],
    ),
  );
  if (confirmed != true) return;

  try {
    final contents = readBackupArchive(await File(picked.path).readAsBytes());
    final lifetime = await restoreFromExportData(
        ref.read(databaseProvider), contents.exportData);
    // Photo files ride along in the archive; put them back in the store.
    final store = ref.read(photoServiceProvider);
    for (final entry in contents.media.entries) {
      await store.importBytes(entry.key, entry.value);
    }
    await ref.read(beanTallyProvider).raiseTo(lifetime);
    messenger
        .showSnackBar(const SnackBar(content: Text('Backup restored.')));
  } on InvalidBackupException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  } on Exception catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Restore failed: $e')));
  }
}
