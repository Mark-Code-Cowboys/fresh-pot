import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'bag_label_parser.dart';
import 'scan_import_providers.dart';

/// Shoots one bag label and transcribes roaster, name, origin,
/// process, and roast date. Resolves to the reading the user
/// confirmed, or null (nothing readable, or they backed out). The
/// composer fills its fields from the result — nothing is saved here.
///
/// Transcription only: the confirm dialog shows exactly what was read.
Future<BagLabelReading?> scanBagLabel(
    BuildContext context, WidgetRef ref) async {
  // Scanning is a Pro feature, like in every CC app.
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return null;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return null;
  }

  final messenger = ScaffoldMessenger.of(context);

  final paths = await captureDocumentPages(
      ref.read(documentScanServiceProvider),
      pageLimit: 1);
  final path = paths.firstOrNull;
  if (path == null || !context.mounted) return null;

  final BagLabelReading? reading;
  try {
    final lines =
        await ref.read(textRecognitionServiceProvider).recognize(path);
    reading = parseBagLabel(lines);
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that label — try a closer, "
            'straighter shot.')));
    return null;
  }
  if (!context.mounted) return null;
  if (reading == null) {
    messenger.showSnackBar(const SnackBar(
        content: Text('No readable text found on that label.')));
    return null;
  }

  // A new local: the closure below blocks promotion of `reading`.
  final read = reading;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => _ConfirmLabelDialog(reading: read),
  );
  return confirmed == true ? read : null;
}

/// Shows exactly what the label said; the user applies it or not.
/// GUARDRAIL: values are verbatim — this dialog never suggests,
/// corrects, or flags anything.
class _ConfirmLabelDialog extends StatelessWidget {
  const _ConfirmLabelDialog({required this.reading});

  final BagLabelReading reading;

  @override
  Widget build(BuildContext context) {
    final lines = [
      if (reading.roaster != null) 'Roaster: ${reading.roaster}',
      if (reading.name != null) 'Coffee: ${reading.name}',
      if (reading.origin != null) 'Origin: ${reading.origin}',
      if (reading.process != null) 'Process: ${reading.process!.label}',
      if (reading.roastDate != null)
        'Roasted: ${formatDate(reading.roastDate!)}',
    ];
    return AlertDialog(
      title: const Text('The label says'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines) Text(line),
          const SizedBox(height: 12),
          Text(
            'Exactly what was read — you can still edit every field '
            'before saving.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Use these')),
      ],
    );
  }
}
