import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/brew_math.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/providers.dart';
import '../../data/repositories/bean_repository.dart';
import '../../data/repositories/brew_repository.dart';
import '../brews/brew_composer_screen.dart';
import 'bean_composer_screen.dart';

final beanProvider = StreamProvider.family<BeanWithStory?, int>(
  (ref, id) => ref.watch(beanRepositoryProvider).watchOne(id),
);

final brewsProvider = StreamProvider.family<List<BrewWithStory>, int>(
  (ref, beanId) => ref.watch(brewRepositoryProvider).watchForBean(beanId),
);

/// The best-rated brew — the dial-in card's source. Ties go to the
/// newer cup (the list is newest first). Null until something is rated.
BrewWithStory? bestBrew(List<BrewWithStory> brews) {
  BrewWithStory? best;
  for (final b in brews) {
    if (b.rating == null) continue;
    if (best == null || b.rating! > best.rating!) best = b;
  }
  return best;
}

class BeanDetailScreen extends ConsumerWidget {
  const BeanDetailScreen({super.key, required this.beanId});

  final int beanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bag = ref.watch(beanProvider(beanId)).value;
    if (bag == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final brews = ref.watch(brewsProvider(beanId)).value ?? const [];
    final theme = Theme.of(context);
    final bean = bag.bean;
    final best = bestBrew(brews);
    return Scaffold(
      appBar: AppBar(
        title: Text(bean.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit bag',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BeanComposerScreen(existing: bag),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete bag',
            onPressed: () => _confirmDelete(context, ref, bag),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (brews.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'again',
              onPressed: () => _brewItAgain(context, ref),
              icon: const Icon(Icons.replay),
              label: const Text('Brew it again'),
            ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'log',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BrewComposerScreen(beanId: beanId),
                fullscreenDialog: true,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Log a brew'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 140),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(label: Text(bean.roaster)),
                    if (bean.origin != null) Chip(label: Text(bean.origin!)),
                    if (bean.process != null)
                      Chip(label: Text(beanProcessLabel(bean))),
                    if (bean.roastLevel != null)
                      Chip(label: Text(bean.roastLevel!.label)),
                    if (bag.rating != null) RatingStars(rating: bag.rating),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  [
                    if (bean.roastDate != null)
                      'Roasted ${formatDate(bean.roastDate!)}',
                    if (bean.priceBagCents != null && bean.bagSizeG != null)
                      '\$${(bean.priceBagCents! / 100).toStringAsFixed(2)} '
                          '/ ${bean.bagSizeG}g'
                    else if (bean.priceBagCents != null)
                      '\$${(bean.priceBagCents! / 100).toStringAsFixed(2)}',
                    if (bag.isActive) 'On the counter',
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant),
                ),
                if (bag.notes != null) ...[
                  const SizedBox(height: 12),
                  Text(bag.notes!, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          if (best != null) _DialInCard(best),
          const Divider(height: 32),
          if (brews.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No brews yet. Log the first cup — dose, water, grind — '
                'and the dial-in card builds itself.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          for (final brew in brews) _BrewTile(brew: brew, beanId: beanId),
        ],
      ),
    );
  }

  /// One tap re-opens the composer with the last cup's numbers — brew,
  /// adjust the rating, save.
  Future<void> _brewItAgain(BuildContext context, WidgetRef ref) async {
    final last =
        await ref.read(brewRepositoryProvider).latestForBean(beanId);
    if (last == null || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BrewComposerScreen(beanId: beanId, prefillFrom: last),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, BeanWithStory bag) async {
    final repo = ref.read(beanRepositoryProvider);
    final brews = await repo.brewCount(beanId);
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${bag.bean.name}?'),
        content: Text(brews == 0
            ? 'This cannot be undone.'
            : '$brews ${brews == 1 ? 'brew goes' : 'brews go'} with it. '
                'This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await repo.delete(beanId);
    if (context.mounted) Navigator.of(context).pop();
  }
}

/// The payoff of logging: the settings of the best cup so far, ready to
/// read off at the bench.
class _DialInCard extends StatelessWidget {
  const _DialInCard(this.best);

  final BrewWithStory best;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brew = best.brew;
    final parts = [
      brewMethodLabel(brew),
      if (brew.doseG != null) '${_trim(brew.doseG!)}g',
      if (brew.waterG != null) '${_trim(brew.waterG!)}g water',
      if (brew.yieldG != null) '${_trim(brew.yieldG!)}g out',
      if (best.ratio != null) formatRatio(best.ratio!),
      if (brew.grindSetting != null) 'grind ${brew.grindSetting}',
      if (brew.tempF != null) '${brew.tempF}°F',
      if (brew.timeSec != null) _clock(brew.timeSec!),
    ];
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('The dial-in', style: theme.textTheme.titleSmall),
                const Spacer(),
                RatingStars(rating: best.rating, size: 14),
              ],
            ),
            const SizedBox(height: 8),
            Text(parts.join(' · '), style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _BrewTile extends ConsumerWidget {
  const _BrewTile({required this.brew, required this.beanId});

  final BrewWithStory brew;
  final int beanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = brew.brew;
    final details = [
      if (b.doseG != null) '${_trim(b.doseG!)}g',
      if (brew.ratio != null) formatRatio(brew.ratio!),
      if (b.grindSetting != null) 'grind ${b.grindSetting}',
      if (b.timeSec != null) _clock(b.timeSec!),
    ].join(' · ');
    return ListTile(
      title: Row(
        children: [
          Text(brewMethodLabel(b)),
          const SizedBox(width: 8),
          if (brew.rating != null) RatingStars(rating: brew.rating, size: 14),
        ],
      ),
      subtitle: Text([
        formatDate(b.brewedAt),
        if (details.isNotEmpty) details,
        if (brew.notes != null) brew.notes!,
      ].join('\n')),
      isThreeLine: brew.notes != null,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BrewComposerScreen(beanId: beanId, existing: brew),
          fullscreenDialog: true,
        ),
      ),
    );
  }
}

String _trim(double v) =>
    v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(1);

String _clock(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}
