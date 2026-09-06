import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';
import 'package:fresh_pot/features/trends/trends_screen.dart';

import '../helpers.dart';

void main() {
  testWidgets('free users get the pitch — and the ungated restore',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const TrendsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your brewing, in the aggregate.'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);
    expect(find.text('The brewing calendar'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('Pro sees ratings, the calendar, and the export buttons',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    final beans = BeanRepository(db);
    final beanId = await beans.create(
        beanDraft(rating: 5, origin: 'Ethiopia', priceBagCents: 1800));
    await BrewRepository(db).create(beanId, brewDraft());

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const TrendsScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('1 bag · 1 brew · 1 rated roaster'), findsOneWidget);
    expect(find.text('Rating by roaster'), findsOneWidget);
    expect(find.text('Copper Kettle'), findsOneWidget);
    expect(find.text('Rating by origin'), findsOneWidget);
    expect(find.text('The brewing calendar'), findsOneWidget);
    expect(find.text('How the cups get made'), findsOneWidget);
    expect(find.text('V60'), findsOneWidget);
    expect(find.text('Share notes as CSV'), findsOneWidget);
    expect(find.text('Back up the whole journal'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
