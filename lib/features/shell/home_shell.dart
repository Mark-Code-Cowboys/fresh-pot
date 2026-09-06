import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../beans/bean_composer_screen.dart';
import '../gear/gear_screen.dart';
import '../home/home_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), GearScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: switch (_index) {
        0 => FloatingActionButton.extended(
            // Phase C guards this behind the free-tier gate.
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const BeanComposerScreen(),
                fullscreenDialog: true,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add bag'),
          ),
        _ => FloatingActionButton.extended(
            onPressed: () => showGearComposer(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add gear'),
          ),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.coffee_outlined), label: 'Beans'),
          NavigationDestination(
              icon: Icon(Icons.coffee_maker_outlined), label: 'Gear'),
        ],
      ),
    );
  }
}
