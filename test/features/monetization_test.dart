import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/features/shell/home_shell.dart';

import '../helpers.dart';

/// Restore that actually finds a purchase, for the restore-path test.
class _RestoringFake extends FakeEntitlementService {
  @override
  Future<void> restorePurchases() => buyUnlimited();
}

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Future<void> seedBeans(int n) async {
    final repo = BeanRepository(db);
    for (var i = 0; i < n; i++) {
      await repo.create(beanDraft(name: 'Bag $i'));
    }
  }

  testWidgets('at the cap, Add bag opens the paywall — both prices as '
      'equal citizens', (tester) async {
    await seedBeans(5);

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    expect(find.text('5 of 5 free beans used'), findsOneWidget);

    await tester.tap(find.text('Add bag'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Pot Pro'), findsOneWidget);
    expect(find.text('Unlimited bags'), findsOneWidget);
    expect(find.text(r'Monthly · $12.99 / month'), findsOneWidget);
    expect(find.text(r'Lifetime · $6.99 once'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Roaster'), findsNothing);

    await tester.ensureVisible(find.text('Maybe later'));
    await tester.tap(find.text('Maybe later'));
    await tester.pumpAndSettle();
    expect(find.text('Fresh Pot Pro'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('under the cap, Add bag goes straight through',
      (tester) async {
    await seedBeans(4);

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add bag'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Roaster'), findsOneWidget);
    await disposeApp(tester);
  });

  test('deleting a bag never refunds a free-tier slot', () async {
    final tally = LifetimeTally(InMemoryKeyValueStore(),
        key: 'beans_created_lifetime');
    addTearDown(tally.dispose);
    final repo = BeanRepository(db, tally: tally);
    final ids = <int>[];
    for (var i = 0; i < 5; i++) {
      ids.add(await repo.create(beanDraft(name: 'Bag $i')));
    }
    await repo.delete(ids.first);
    expect(await repo.count(), 4);
    expect(await repo.lifetimeCreated(), 5); // the slot stays spent
  });

  testWidgets('buying monthly mid-gate continues into the composer',
      (tester) async {
    await seedBeans(5);

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add bag'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(r'Monthly · $12.99 / month'));
    await tester.tap(find.text(r'Monthly · $12.99 / month'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Roaster'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('the lifetime unlock works from its own button',
      (tester) async {
    await seedBeans(5);

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add bag'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(r'Lifetime · $6.99 once'));
    await tester.tap(find.text(r'Lifetime · $6.99 once'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Roaster'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('restore purchase unlocks from the sheet', (tester) async {
    await seedBeans(5);

    await tester.pumpWidget(testApp(
        db: db, home: const HomeShell(), entitlements: _RestoringFake()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add bag'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Restore purchase'));
    await tester.tap(find.text('Restore purchase'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Roaster'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Pro owners see no counter and no gates', (tester) async {
    await seedBeans(6);

    await tester.pumpWidget(testApp(
        db: db,
        home: const HomeShell(),
        entitlements: FakeEntitlementService(unlimited: true)));
    await tester.pumpAndSettle();

    expect(find.textContaining('free beans used'), findsNothing);
    await tester.tap(find.text('Add bag'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Roaster'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Settings offers the upgrade path to the same sheet',
      (tester) async {
    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upgrade to Fresh Pot Pro'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Pot Pro'), findsOneWidget);
    await disposeApp(tester);
  });
}
