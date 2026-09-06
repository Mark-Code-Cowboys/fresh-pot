import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/providers.dart';
import '../../data/repositories/bean_repository.dart';
import '../beans/bean_detail_screen.dart';
import '../monetization/free_limit.dart';

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
      appBar: AppBar(title: const Text('Fresh Pot')),
      body: beans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) =>
            all.isEmpty ? _empty(context) : _list(context, ref, all),
      ),
    );
  }

  Widget _empty(BuildContext context) {
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
          ],
        ),
      ),
    );
  }

  Widget _list(
      BuildContext context, WidgetRef ref, List<BeanWithStory> all) {
    final usage = beanFreeLimit.usage(all.length);
    return ListView(
      children: [
        // Phase C hides this for Pro owners and wires the real paywall.
        FreeTierCounter(
          usage: usage,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          onGoPro: () => _showPaywallStub(context),
        ),
        for (final bag in activeFirst(all)) _BeanCard(bag),
        const SizedBox(height: 88), // keep the FAB off the last card
      ],
    );
  }

  void _showPaywallStub(BuildContext context) {
    showPaywallModal<void>(
      context,
      builder: (context) => PaywallSheetScaffold(
        icon: Icons.coffee_rounded,
        title: 'Fresh Pot Pro',
        body: 'Phase C wires real products here via cc_core '
            'StoreEntitlementService; this stub proves the sheet.',
        primaryLabel: 'Buy (stub)',
        onPrimary: () => Navigator.of(context).pop(),
        onLater: () => Navigator.of(context).pop(),
      ),
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
