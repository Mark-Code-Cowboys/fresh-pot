import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/providers.dart';
import '../../data/repositories/bean_repository.dart';
import '../beans/bean_detail_screen.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import '../scan_import/csv_flow.dart';
import '../settings/settings_screen.dart';

/// Live bags, newest first from the repository.
final beansProvider = StreamProvider<List<BeanWithStory>>(
  (ref) => ref.watch(beanRepositoryProvider).watchAll(),
);

/// The bag on the counter floats to the top; everything else keeps the
/// repository's newest-first order.
List<BeanWithStory> activeFirst(List<BeanWithStory> all) => [
      for (final b in all)
        if (b.isActive) b,
      for (final b in all)
        if (!b.isActive) b,
    ];

/// The bean journal — Fresh Pot's home tab.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beans = ref.watch(beansProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Pot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Import your notes',
            onPressed: () => runCsvImport(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: beans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) =>
            all.isEmpty ? _empty(context, ref) : _list(context, ref, all),
      ),
    );
  }

  Widget _empty(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.coffee_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Your tasting notes belong to you.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add the bag on your counter — roaster, name, and the '
              'first impression.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // The rescue path, front and center for switchers.
            FilledButton.tonalIcon(
              onPressed: () => runCsvImport(context, ref),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Import my notes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(
      BuildContext context, WidgetRef ref, List<BeanWithStory> all) {
    final usage = ref.watch(freeTierUsageProvider);
    return ListView(
      children: [
        // Invisible for Pro owners; taps open the paywall.
        if (usage != null)
          FreeTierCounter(
            usage: usage,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            onGoPro: () => showPaywallSheet(context),
          ),
        for (final bag in activeFirst(all)) _BeanCard(bag),
        const SizedBox(height: 88), // keep the FAB off the last card
      ],
    );
  }
}

class _BeanCard extends StatelessWidget {
  const _BeanCard(this.bag);

  final BeanWithStory bag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bean = bag.bean;
    final details = [
      bean.roaster,
      if (bean.origin != null) bean.origin!,
      if (bean.process != null) beanProcessLabel(bean),
    ].join(' · ');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(bean.name),
        subtitle: Text(details),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (bag.rating != null)
              RatingStars(rating: bag.rating, size: 14),
            if (bag.isActive)
              Text('On the counter',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BeanDetailScreen(beanId: bean.id),
          ),
        ),
      ),
    );
  }
}
