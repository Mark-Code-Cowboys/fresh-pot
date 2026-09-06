import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../scan_import/csv_flow.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// PHASE F: replace the placeholder copy with the app's positioning
/// line and add the import-or-start-fresh fork (see Hitch Post's
/// onboarding for the house shape). The privacy promise stays.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.menu_book_outlined,
      positioning: 'Fresh Pot scaffold is alive.',
      subtitle: 'Phase F writes the real positioning line and the '
          'import-or-start-fresh fork here.',
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
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
