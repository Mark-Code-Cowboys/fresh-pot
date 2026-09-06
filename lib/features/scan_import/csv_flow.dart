import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import 'csv_importer.dart';

/// The rescue path: picks a CSV export (the incumbent's or any
/// spreadsheet) and opens cc_core's column-mapping screen. Free like
/// every your-data-in path — free users import up to the bag cap.
Future<void> runCsvImport(BuildContext context, WidgetRef ref) async {
  const typeGroup = XTypeGroup(
    label: 'Spreadsheet',
    extensions: ['csv', 'txt'],
  );
  final file = await openFile(acceptedTypeGroups: const [typeGroup]);
  if (file == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  final CsvDocument doc;
  try {
    doc = parseCsv(await File(file.path).readAsString());
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that file as CSV.")));
    return;
  }
  if (!context.mounted) return;
  if (doc.header.isEmpty || doc.rows.isEmpty) {
    messenger.showSnackBar(
        const SnackBar(content: Text('That file has no data rows.')));
    return;
  }
  await showCsvMappingScreen(
    context,
    doc: doc,
    fields: fpCsvFields,
    title: 'Import your notes',
    footnote: 'Rows without a coffee name are skipped; rows already in '
        'the journal are left alone, so re-importing is safe.',
    onImport: (mapping) async {
      final report = await importCsvBeans(
        beans: ref.read(beanRepositoryProvider),
        doc: doc,
        mapping: mapping,
        entitled: await ref.read(entitlementServiceProvider).isUnlimited(),
      );
      return report.summary;
    },
  );
}
