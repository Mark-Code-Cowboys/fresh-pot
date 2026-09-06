import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/brew_repository.dart';

final grindersProvider = StreamProvider<List<GearData>>(
  (ref) => ref.watch(gearRepositoryProvider).watchGrinders(),
);

/// Log or edit a cup. Method-aware: espresso weighs what comes out
/// (yield), everything else what goes in (water). [prefillFrom] is the
/// repeat-last-brew hook — same params, fresh rating.
class BrewComposerScreen extends ConsumerStatefulWidget {
  const BrewComposerScreen({
    super.key,
    required this.beanId,
    this.existing,
    this.prefillFrom,
  }) : assert(existing == null || prefillFrom == null,
            'Edit an existing brew or prefill a new one, not both');

  final int beanId;
  final BrewWithStory? existing;

  /// A previous brew whose parameters seed a NEW brew (rating and
  /// notes deliberately not carried — today's cup earns its own).
  final Brew? prefillFrom;

  @override
  ConsumerState<BrewComposerScreen> createState() =>
      _BrewComposerScreenState();
}

class _BrewComposerScreenState extends ConsumerState<BrewComposerScreen> {
  Brew? get _seed => widget.existing?.brew ?? widget.prefillFrom;

  late BrewMethod _method = _seed?.method ?? BrewMethod.v60;
  late final _methodLabel = TextEditingController(text: _seed?.methodLabel);
  late final _dose =
      TextEditingController(text: _seed?.doseG == null ? null : _num(_seed!.doseG!));
  late final _water = TextEditingController(
      text: _seed?.waterG == null ? null : _num(_seed!.waterG!));
  late final _yield = TextEditingController(
      text: _seed?.yieldG == null ? null : _num(_seed!.yieldG!));
  late final _grind = TextEditingController(text: _seed?.grindSetting);
  late int? _grinderGearId = _seed?.grinderGearId;
  late final _temp =
      TextEditingController(text: _seed?.tempF?.toString());
  late final _time = TextEditingController(
      text: _seed?.timeSec == null ? null : _seed!.timeSec.toString());
  late int? _rating = widget.existing?.rating;
  late final _notes = TextEditingController(text: widget.existing?.notes);
  var _saving = false;

  static String _num(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toString();

  @override
  void dispose() {
    for (final c in [
      _methodLabel, _dose, _water, _yield, _grind, _temp, _time, _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    double? parse(TextEditingController c) =>
        c.text.trim().isEmpty ? null : double.tryParse(c.text.trim());
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final yieldMode = usesYield(_method);
    final draft = BrewDraft(
      method: _method,
      methodLabel:
          _method == BrewMethod.other ? emptyToNull(_methodLabel) : null,
      doseG: parse(_dose),
      waterG: yieldMode ? null : parse(_water),
      yieldG: yieldMode ? parse(_yield) : null,
      grindSetting: emptyToNull(_grind),
      grinderGearId: _grinderGearId,
      tempF: switch (emptyToNull(_temp)) {
        null => null,
        final t => int.tryParse(t),
      },
      timeSec: switch (emptyToNull(_time)) {
        null => null,
        final t => int.tryParse(t),
      },
      brewedAt: widget.existing?.brew.brewedAt,
      rating: _rating,
      notes: emptyToNull(_notes),
    );
    final repo = ref.read(brewRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(widget.beanId, draft);
    } else {
      await repo.update(existing.brew.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grinders = ref.watch(grindersProvider).value ?? const [];
    final yieldMode = usesYield(_method);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Log a brew' : 'Edit brew'),
        actions: [
          TextButton(
              onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<BrewMethod>(
            initialValue: _method,
            decoration: const InputDecoration(labelText: 'Method'),
            items: [
              for (final m in BrewMethod.values)
                DropdownMenuItem(value: m, child: Text(m.label)),
            ],
            onChanged: (m) => setState(() => _method = m ?? _method),
          ),
          if (_method == BrewMethod.other) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _methodLabel,
              decoration:
                  const InputDecoration(labelText: 'Method (your word)'),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dose,
                  decoration: const InputDecoration(
                      labelText: 'Dose', suffixText: 'g'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                // Espresso weighs what comes out; everything else what
                // goes in.
                child: yieldMode
                    ? TextField(
                        key: const ValueKey('yield'),
                        controller: _yield,
                        decoration: const InputDecoration(
                            labelText: 'Yield', suffixText: 'g'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      )
                    : TextField(
                        key: const ValueKey('water'),
                        controller: _water,
                        decoration: const InputDecoration(
                            labelText: 'Water', suffixText: 'g'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _grind,
                  decoration:
                      const InputDecoration(labelText: 'Grind setting'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int?>(
                  initialValue: _grinderGearId,
                  decoration: const InputDecoration(labelText: 'Grinder'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('—')),
                    for (final g in grinders)
                      DropdownMenuItem(value: g.id, child: Text(g.name)),
                  ],
                  onChanged: (id) => setState(() => _grinderGearId = id),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _temp,
                  decoration: const InputDecoration(
                      labelText: 'Water temp', suffixText: '°F'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _time,
                  decoration: const InputDecoration(
                      labelText: 'Time', suffixText: 'sec'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('The cup'),
              const SizedBox(width: 8),
              RatingStars(
                rating: _rating,
                onChanged: (r) => setState(() => _rating = r),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: InputDecoration(
              labelText: 'Notes',
              hintText: 'What changed, what you\'d change next time.',
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              hintStyle: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
