import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_pot/app.dart';

import 'helpers.dart';

void main() {
  testWidgets('boots: onboarding once, then the shell', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const AppRoot()));
    await tester.pumpAndSettle();

    expect(find.textContaining('scaffold is alive'), findsOneWidget);
    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Pot'), findsOneWidget);
    expect(find.text('Your tasting notes belong to you.'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
