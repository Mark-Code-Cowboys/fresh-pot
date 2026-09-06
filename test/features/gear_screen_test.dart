import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/features/shell/home_shell.dart';

import '../helpers.dart';

void main() {
  testWidgets('the bench: empty invitation, add through the dialog',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gear'));
    await tester.pumpAndSettle();
    expect(find.text('The bench.'), findsOneWidget);

    await tester.tap(find.text('Add gear'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Name'), 'Encore');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Encore'), findsOneWidget);
    expect(find.text('Grinder'), findsOneWidget);
    final rows = await db.select(db.gear).get();
    expect(rows.single.kind, GearKind.grinder);

    await disposeApp(tester);
    await db.close();
  });
}
