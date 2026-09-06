import 'package:cc_core/cc_core.dart';

/// Free tier: this many bags, forever. Adds gated only (Phase C wires
/// the gate); existing tasting notes are never locked.
const kFreeBeanLimit = 5;

/// Bean quota with Fresh Pot wording.
const beanFreeLimit = FreeLimit(
  kFreeBeanLimit,
  'beans',
  detailBuilder: _beanDetail,
);

String _beanDetail(int remaining) => switch (remaining) {
      0 => 'Free bags all used — go Pro to keep the notes coming.',
      1 => '1 more bag free — then Fresh Pot Pro.',
      final n => '$n more bags free — then Fresh Pot Pro.',
    };
