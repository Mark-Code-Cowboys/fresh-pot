import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/features/shell/home_shell.dart';

import '../helpers.dart';

void main() {
  testWidgets('empty state invites the first bag', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();

    expect(find.text('Your tasting notes belong to you.'), findsOneWidget);
    expect(find.text('Add bag'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('the bag on the counter floats first, counter counts',
      (tester) async {
    final db = makeTestDb();
    final beans = BeanRepository(db);
    // Newest-first would put Kenya on top; the active bag outranks it.
    await beans.create(beanDraft(
        name: 'Active Guji',
        openedDate: DateTime(2026, 9, 1),
        rating: 4));
    await beans.create(beanDraft(name: 'Shelved Kenya'));

    await tester.pumpWidget(testApp(db: db, home: const HomeShell()));
    await tester.pumpAndSettle();

    expect(find.text('2 of 5 free beans used'), findsOneWidget);
    expect(find.text('On the counter'), findsOneWidget);
    final activeY = tester.getTopLeft(find.text('Active Guji')).dy;
    final shelvedY = tester.getTopLeft(find.text('Shelved Kenya')).dy;
    expect(activeY, lessThan(shelvedY));

    // Tap through to the detail screen.
    await tester.tap(find.text('Active Guji'));
    await tester.pumpAndSettle();
    expect(find.text('Copper Kettle'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
