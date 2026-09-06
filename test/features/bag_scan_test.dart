import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_pot/features/beans/bean_composer_screen.dart';
import 'package:fresh_pot/features/scan_import/scan_import_providers.dart';

import '../helpers.dart';

void main() {
  testWidgets('bag scan fills the label fields after the user confirms',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const BeanComposerScreen(),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['bag.jpg'])),
        textRecognitionServiceProvider.overrideWithValue(
          FakeTextRecognitionService(linesByPath: {
            'bag.jpg': const [
              OcrLine('COPPER KETTLE COFFEE', left: 0, top: 0, height: 44),
              OcrLine('GUJI HIGHLANDS', left: 0, top: 60, height: 30),
              OcrLine('Ethiopia · Washed', left: 0, top: 110, height: 18),
              OcrLine('Roast date 8/28/2026', left: 0, top: 400, height: 14),
            ],
          }),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Scan the bag'));
    await tester.pumpAndSettle();

    // The confirm dialog shows the reading verbatim.
    expect(find.text('The label says'), findsOneWidget);
    expect(find.text('Roaster: Copper Kettle Coffee'), findsOneWidget);
    expect(find.text('Origin: Ethiopia'), findsOneWidget);

    await tester.tap(find.text('Use these'));
    await tester.pumpAndSettle();

    expect(find.text('Copper Kettle Coffee'), findsOneWidget);
    expect(find.text('Guji Highlands'), findsOneWidget);
    expect(find.text('Ethiopia'), findsOneWidget);
    expect(find.textContaining('Roasted Aug 28, 2026'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('free users hit the paywall before the scanner',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(
      db: db,
      home: const BeanComposerScreen(),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['bag.jpg'])),
        textRecognitionServiceProvider
            .overrideWithValue(FakeTextRecognitionService()),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Scan the bag'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh Pot Pro'), findsOneWidget);
    expect(find.text('The label says'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });
}
