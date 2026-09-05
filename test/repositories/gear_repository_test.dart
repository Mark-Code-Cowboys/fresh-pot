import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/gear_repository.dart';

import '../helpers.dart';

void main() {
  test('the bench: create, A-Z watch, grinders filter, update', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final gear = GearRepository(db);

    await gear.create(const GearDraft(kind: GearKind.kettle, name: 'Stagg'));
    final grinderId = await gear.create(
        const GearDraft(kind: GearKind.grinder, name: 'Encore'));
    await gear.create(const GearDraft(
        kind: GearKind.other, kindLabel: 'Dripper', name: 'Origami'));

    final all = await gear.watchAll().first;
    expect([for (final g in all) g.name], ['Encore', 'Origami', 'Stagg']);
    final grinders = await gear.watchGrinders().first;
    expect(grinders.single.name, 'Encore');

    await gear.update(grinderId,
        const GearDraft(kind: GearKind.grinder, name: 'Encore ESP'));
    expect((await gear.watchGrinders().first).single.name, 'Encore ESP');
  });
}
