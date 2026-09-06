import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';

/// Settings: the Pro state and the privacy promise. More arrives with
/// export/backup in Phase E.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              pro ? Icons.verified_outlined : Icons.workspace_premium_outlined,
              color: theme.colorScheme.primary,
            ),
            title: Text(pro ? 'Fresh Pot Pro' : 'Upgrade to Fresh Pot Pro'),
            subtitle: Text(pro
                ? 'Unlimited bags, trends, export. Thanks for the support.'
                : 'Unlimited bags, brew trends, export and backup.'),
            onTap: pro ? null : () => showPaywallSheet(context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.lock_outline,
                color: theme.colorScheme.onSurfaceVariant),
            title: const Text('Private by construction'),
            subtitle: const Text(kPrivacyBoilerplate),
          ),
        ],
      ),
    );
  }
}
