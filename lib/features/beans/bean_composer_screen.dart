import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/bean_repository.dart';

/// Add or edit a bag: roaster and name are the whole required path;
/// everything else is for the curious.
class BeanComposerScreen extends ConsumerStatefulWidget {
  const BeanComposerScreen({super.key, this.existing});

  final BeanWithStory? existing;

  @override
  ConsumerState<BeanComposerScreen> createState() =>
      _BeanComposerScreenState();
}

class _BeanComposerScreenState extends ConsumerState<BeanComposerScreen> {
  late final _roaster =
      TextEditingController(text: widget.existing?.bean.roaster);
  late final _name = TextEditingController(text: widget.existing?.bean.name);
  late final _origin =
      TextEditingController(text: widget.existing?.bean.origin);
  late final _region =
      TextEditingController(text: widget.existing?.bean.region);
  late final _processLabel =
      TextEditingController(text: widget.existing?.bean.processLabel);
  late final _price = TextEditingController(
      text: widget.existing?.bean.priceBagCents == null
          ? null
          : (widget.existing!.bean.priceBagCents! / 100).toStringAsFixed(2));
  late final _bagSize = TextEditingController(
      text: widget.existing?.bean.bagSizeG?.toString());
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late RoastProcess? _process = widget.existing?.bean.process;
  late RoastLevel? _roastLevel = widget.existing?.bean.roastLevel;
  late DateTime? _roastDate = widget.existing?.bean.roastDate;
  late DateTime? _openedDate = widget.existing?.bean.openedDate;
  late DateTime? _finishedDate = widget.existing?.bean.finishedDate;
  late int? _rating = widget.existing?.rating;
  final _newPhotos = <JournalPhotoDraft>[];
  var _saving = false;

  @override
  void dispose() {
    for (final c in [
      _roaster, _name, _origin, _region, _processLabel, _price, _bagSize,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickRoastDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _roastDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _roastDate = picked);
  }

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pick from gallery'),
              onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await ref.read(photoServiceProvider).acquire(source);
    if (path != null && mounted) {
      final existing = widget.existing;
      if (existing != null) {
        await ref
            .read(beanRepositoryProvider)
            .addPhoto(existing.bean.id, JournalPhotoDraft(path: path));
      } else {
        setState(() => _newPhotos.add(JournalPhotoDraft(path: path)));
      }
    }
  }

  Future<void> _save() async {
    if (_saving || _roaster.text.trim().isEmpty || _name.text.trim().isEmpty) {
      return;
    }
    setState(() => _saving = true);
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final priceText = emptyToNull(_price)?.replaceFirst(r'$', '');
    final draft = BeanDraft(
      roaster: _roaster.text.trim(),
      name: _name.text.trim(),
      origin: emptyToNull(_origin),
      region: emptyToNull(_region),
      process: _process,
      processLabel:
          _process == RoastProcess.other ? emptyToNull(_processLabel) : null,
      roastLevel: _roastLevel,
      priceBagCents: priceText == null
          ? null
          : switch (double.tryParse(priceText)) {
              null => null,
              final v => (v * 100).round(),
            },
      bagSizeG: switch (emptyToNull(_bagSize)) {
        null => null,
        final s => int.tryParse(s),
      },
      roastDate: _roastDate,
      openedDate: _openedDate,
      finishedDate: _finishedDate,
      rating: _rating,
      notes: emptyToNull(_notes),
      photos: List.of(_newPhotos),
    );
    final repo = ref.read(beanRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.create(draft);
    } else {
      await repo.update(existing.bean.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoService = ref.read(photoServiceProvider);
    final existingPhotos = widget.existing?.photos ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add a bag' : 'Edit bag'),
        actions: [
          TextButton(
              onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _roaster,
            decoration: const InputDecoration(labelText: 'Roaster'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Coffee name'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _origin,
                  decoration: const InputDecoration(labelText: 'Origin'),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _region,
                  decoration: const InputDecoration(labelText: 'Region'),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<RoastProcess?>(
            initialValue: _process,
            decoration: const InputDecoration(labelText: 'Process'),
            items: [
              const DropdownMenuItem(value: null, child: Text('—')),
              for (final p in RoastProcess.values)
                DropdownMenuItem(value: p, child: Text(p.label)),
            ],
            onChanged: (p) => setState(() => _process = p),
          ),
          if (_process == RoastProcess.other) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _processLabel,
              decoration:
                  const InputDecoration(labelText: 'Process (your word)'),
            ),
          ],
          const SizedBox(height: 12),
          DropdownButtonFormField<RoastLevel?>(
            initialValue: _roastLevel,
            decoration: const InputDecoration(labelText: 'Roast level'),
            items: [
              const DropdownMenuItem(value: null, child: Text('—')),
              for (final l in RoastLevel.values)
                DropdownMenuItem(value: l, child: Text(l.label)),
            ],
            onChanged: (l) => setState(() => _roastLevel = l),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _price,
                  decoration: const InputDecoration(
                      labelText: 'Bag price', prefixText: r'$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _bagSize,
                  decoration: const InputDecoration(
                      labelText: 'Bag size', suffixText: 'g'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickRoastDate,
            icon: const Icon(Icons.event),
            label: Text(_roastDate == null
                ? 'Roast date'
                : 'Roasted ${formatDate(_roastDate!)}'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('On the counter'),
            subtitle: Text(
              _openedDate == null
                  ? 'Flip when you open the bag.'
                  : 'Opened ${formatDate(_openedDate!)}',
              style: theme.textTheme.bodySmall,
            ),
            value: _openedDate != null && _finishedDate == null,
            onChanged: (on) => setState(() {
              if (on) {
                _openedDate ??= DateTime.now();
                _finishedDate = null;
              } else if (_openedDate != null) {
                _finishedDate = DateTime.now();
              }
            }),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('First impression'),
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
              labelText: 'Tasting notes',
              hintText: 'What the cup actually tastes like to you.',
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              hintStyle: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          PhotoAttachmentStrip(
            items: [
              for (final p in existingPhotos)
                PhotoStripItem(
                  file: photoService.fileFor(p.path),
                  caption: p.caption,
                  onRemove: () =>
                      ref.read(beanRepositoryProvider).removePhoto(p.id),
                ),
              for (final p in _newPhotos)
                PhotoStripItem(
                  file: photoService.fileFor(p.path),
                  onRemove: () => setState(() => _newPhotos.remove(p)),
                ),
            ],
            onAdd: _addPhoto,
          ),
        ],
      ),
    );
  }
}
