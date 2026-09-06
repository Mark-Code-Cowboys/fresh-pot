import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../beans/bean_composer_screen.dart';
import '../scan_import/csv_flow.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// The first thing a switcher reads is the ownership pitch — their
/// notes, held hostage nowhere — then the privacy promise, then the
/// fork: the importer leads because the rescue play IS the onboarding.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.coffee_outlined,
      positioning: 'Your tasting notes belong to you.',
      subtitle: 'No account, no cloud, no archive held for ransom. '
          'Fresh Pot is the coffee journal you keep — every bag, every '
          'brew, every note, on your phone and yours for good.',
      actions: [
        // The rescue play leads: switchers arrive with an export.
        FilledButton.icon(
          icon: const Icon(Icons.download_outlined),
          label: const Text('Import my notes'),
          onPressed: () async {
            // Run the flow first so this screen stays alive under it,
            // then swap to the shell.
            await runCsvImport(context, ref);
            await _finish(ref);
          },
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add my first bag'),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const BeanComposerScreen(),
                fullscreenDialog: true,
              ),
            );
            await _finish(ref);
          },
        ),
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
