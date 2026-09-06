import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_pot/app.dart';

import 'helpers.dart';

void main() {
  testWidgets('boots: onboarding once, then the shell', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const AppRoot()));
    await tester.pumpAndSettle();

    expect(find.text('Your tasting notes belong to you.'), findsOneWidget);
    await tester.ensureVisible(find.text('Just look around'));
    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Pot'), findsOneWidget);
    expect(find.text('Your tasting notes belong to you.'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('returning users go straight to the shell', (tester) async {
    final db = makeTestDb();
    final store = InMemoryKeyValueStore();
    await FirstRunFlag(store).markSeen();
    await tester.pumpWidget(
        testApp(db: db, kvStore: store, home: const AppRoot()));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Pot'), findsOneWidget);
    expect(find.text('Just look around'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });
}
