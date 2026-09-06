import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/gear_repository.dart';

final gearListProvider = StreamProvider<List<GearData>>(
  (ref) => ref.watch(gearRepositoryProvider).watchAll(),
);

/// The bench — grinders, brewers, kettles, with their notes.
class GearScreen extends ConsumerWidget {
  const GearScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gear = ref.watch(gearListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Gear')),
      body: gear.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) => all.isEmpty
            ? _empty(context)
            : ListView(
                children: [
                  for (final g in all)
                    ListTile(
                      leading: CircleAvatar(
                          child: Icon(_iconFor(g.kind), size: 20)),
                      title: Text(g.name),
                      subtitle: Text([
                        gearKindLabel(g),
                        if (g.notes != null) g.notes!,
                      ].join(' · ')),
                      onTap: () => showGearComposer(context, ref, existing: g),
                    ),
                  const SizedBox(height: 88),
                ],
              ),
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
            Icon(Icons.coffee_maker_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('The bench.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add your grinder first — grind settings mean more with '
              'the grinder next to them.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(GearKind kind) => switch (kind) {
        GearKind.grinder => Icons.settings,
        GearKind.brewer => Icons.coffee_outlined,
        GearKind.machine => Icons.coffee_maker_outlined,
        GearKind.kettle => Icons.water_drop_outlined,
        GearKind.scale => Icons.monitor_weight_outlined,
        GearKind.other => Icons.handyman_outlined,
      };
}

/// Add or edit a piece of gear in place — small enough for a dialog.
Future<void> showGearComposer(BuildContext context, WidgetRef ref,
    {GearData? existing}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _GearDialog(existing: existing),
  );
}

class _GearDialog extends ConsumerStatefulWidget {
  const _GearDialog({this.existing});

  final GearData? existing;

  @override
  ConsumerState<_GearDialog> createState() => _GearDialogState();
}

class _GearDialogState extends ConsumerState<_GearDialog> {
  late GearKind _kind = widget.existing?.kind ?? GearKind.grinder;
  late final _kindLabel =
      TextEditingController(text: widget.existing?.kindLabel);
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _notes = TextEditingController(text: widget.existing?.notes);

  @override
  void dispose() {
    _kindLabel.dispose();
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final draft = GearDraft(
      kind: _kind,
      kindLabel: _kind == GearKind.other ? emptyToNull(_kindLabel) : null,
      name: _name.text.trim(),
      notes: emptyToNull(_notes),
    );
    final repo = ref.read(gearRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(draft);
    } else {
      await repo.update(existing.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add gear' : 'Edit gear'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<GearKind>(
            initialValue: _kind,
            decoration: const InputDecoration(labelText: 'Kind'),
            items: [
              for (final k in GearKind.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: (k) => setState(() => _kind = k ?? _kind),
          ),
          if (_kind == GearKind.other) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _kindLabel,
              decoration:
                  const InputDecoration(labelText: 'Kind (your word)'),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
                labelText: 'Notes', hintText: 'Burrs, mods, quirks.'),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        if (widget.existing != null)
          TextButton(
            onPressed: () async {
              await ref
                  .read(gearRepositoryProvider)
                  .delete(widget.existing!.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
