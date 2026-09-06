import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cc_core/cc_core.dart';

import '../../data/providers.dart';
import '../beans/bean_composer_screen.dart';
import '../gear/gear_screen.dart';
import '../home/home_screen.dart';
import '../monetization/free_limit.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import '../trends/trends_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), GearScreen(), TrendsScreen()];

  /// Adding a bag past the free five (lifetime adds, so deletes don't
  /// refund slots — history isn't a recyclable slot) opens the paywall
  /// instead; unlocking mid-flow continues to the composer.
  Future<void> _addBean() async {
    final entitled =
        await ref.read(entitlementServiceProvider).isUnlimited();
    final used = await ref.read(beanRepositoryProvider).lifetimeCreated();
    try {
      beanFreeLimit.guard(used: used, entitled: entitled);
    } on FreeLimitReachedException {
      if (!mounted) return;
      final unlocked = await showPaywallSheet(context);
      if (!unlocked) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BeanComposerScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: switch (_index) {
        0 => FloatingActionButton.extended(
            onPressed: _addBean,
            icon: const Icon(Icons.add),
            label: const Text('Add bag'),
          ),
        1 => FloatingActionButton.extended(
            onPressed: () => showGearComposer(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add gear'),
          ),
        _ => null, // trends is a reading tab
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.coffee_outlined), label: 'Beans'),
          NavigationDestination(
              icon: Icon(Icons.coffee_maker_outlined), label: 'Gear'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined), label: 'Trends'),
        ],
      ),
    );
  }
}
