import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';
import 'package:fresh_pot/features/beans/bean_detail_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('the dial-in card pins the best-rated brew',
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
            brewedAt: DateTime(2026, 9, 1),
            grindSetting: '20',
            rating: 3));
    await brews.create(
        beanId,
        brewDraft(
            brewedAt: DateTime(2026, 9, 3),
            doseG: 16,
            waterG: 256,
            grindSetting: '17',
            rating: 5,
            notes: 'There it is.'));

    await tester.pumpWidget(
        testApp(db: db, home: BeanDetailScreen(beanId: beanId)));
    await tester.pumpAndSettle();

    expect(find.text('The dial-in'), findsOneWidget);
    expect(find.textContaining('grind 17'), findsWidgets);
    expect(find.textContaining('1:16'), findsWidgets);
    expect(find.text('Brew it again'), findsOneWidget);
    expect(find.textContaining('There it is.'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('no brews: empty invitation, no dial-in, no repeat',
      (tester) async {
    final db = makeTestDb();
    final beanId = await BeanRepository(db).create(beanDraft());
    await tester.pumpWidget(
        testApp(db: db, home: BeanDetailScreen(beanId: beanId)));
    await tester.pumpAndSettle();

    expect(find.textContaining('No brews yet'), findsOneWidget);
    expect(find.text('The dial-in'), findsNothing);
    expect(find.text('Brew it again'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  test('bestBrew: highest rating wins, ties go to the newer cup', () {
    BrewWithStory rated(int id, int? rating) => BrewWithStory(
          brewFor(id),
          entry: rating == null ? null : entryFor(id, rating: rating),
        );
    // Newest-first list, like the repository emits.
    expect(bestBrew([rated(3, 4), rated(2, 4), rated(1, 3)])!.brew.id, 3);
    expect(bestBrew([rated(2, null), rated(1, null)]), isNull);
  });
}
