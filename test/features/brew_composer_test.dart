import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';
import 'package:fresh_pot/features/brews/brew_composer_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('method-aware: pour-over takes water, espresso takes yield',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final beanId = await BeanRepository(db).create(beanDraft());
    await tester.pumpWidget(
        testApp(db: db, home: BrewComposerScreen(beanId: beanId)));
    await tester.pumpAndSettle();

    // V60 default: water field, no yield field.
    expect(find.widgetWithText(TextField, 'Water'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Yield'), findsNothing);

    // Switch to espresso: the pair swaps.
    await tester.tap(find.text('V60'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Espresso').last);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Yield'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Water'), findsNothing);

    await tester.enterText(
        find.widgetWithText(TextField, 'Dose'), '18');
    await tester.enterText(
        find.widgetWithText(TextField, 'Yield'), '36');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final shot = (await db.select(db.brews).get()).single;
    expect(shot.method, BrewMethod.espresso);
    expect(shot.yieldG, 36);
    expect(shot.waterG, isNull);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('repeat-last prefills the params but not the rating',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final beanId = await BeanRepository(db).create(beanDraft());
    final brews = BrewRepository(db);
    await brews.create(
        beanId,
        brewDraft(
            doseG: 16, waterG: 256, grindSetting: '17', rating: 5));
    final last = await brews.latestForBean(beanId);

    await tester.pumpWidget(testApp(
        db: db,
        home: BrewComposerScreen(beanId: beanId, prefillFrom: last)));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Dose'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text('256'), findsOneWidget);
    expect(find.text('17'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final all = await db.select(db.brews).get();
    expect(all, hasLength(2));
    // Today's cup earns its own rating — the prefill carried no entry.
    final repeat = all.singleWhere((b) => b.id != last!.id);
    expect(repeat.journalEntryId, isNull);
    expect(repeat.grindSetting, '17');

    await disposeApp(tester);
    await db.close();
  });
}
