import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Riverpod 3 keeps the Override type out of the main barrel.
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:fresh_pot/core/theme/app_theme.dart';
import 'package:fresh_pot/data/database/app_database.dart';
import 'package:fresh_pot/data/providers.dart';
import 'package:fresh_pot/data/repositories/bean_repository.dart';
import 'package:fresh_pot/data/repositories/brew_repository.dart';

AppDatabase makeTestDb() => AppDatabase(NativeDatabase.memory());

/// Plugin-free photo service for widget tests.
class FakeAppPhotoService implements PhotoService {
  final discarded = <String>[];

  @override
  Future<String?> acquire(PhotoSource source) async => null;

  @override
  Future<String?> acquireTransient(PhotoSource source) async => null;

  @override
  File fileFor(String photoPath) => File('/test-photos/$photoPath');

  @override
  Future<void> importBytes(String photoPath, List<int> bytes) async {}

  @override
  Future<void> discard(String photoPath) async {
    discarded.add(photoPath);
  }
}

/// The app wired to an in-memory database and fake services.
/// PHASE C adds the entitlement override here (see Hitch Post's
/// helpers for the full shape).
Widget testApp({
  required AppDatabase db,
  required Widget home,
  KeyValueStore? kvStore,
  List<Override> overrides = const [],
}) =>
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        photoServiceProvider.overrideWithValue(FakeAppPhotoService()),
        kvStoreProvider.overrideWithValue(kvStore ?? InMemoryKeyValueStore()),
        ...overrides,
      ],
      child: MaterialApp(theme: AppTheme.light(), home: home),
    );

/// Call at the end of every widget test that renders [testApp]; lets
/// drift stream-query cleanup timers fire inside the test zone.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

BeanDraft beanDraft({
  String roaster = 'Copper Kettle',
  String name = 'Guji Highlands',
  String? origin = 'Ethiopia',
  RoastProcess? process = RoastProcess.washed,
  RoastLevel? roastLevel = RoastLevel.light,
  int? priceBagCents,
  DateTime? roastDate,
  DateTime? openedDate,
  DateTime? finishedDate,
  int? rating,
  String? notes,
  List<JournalPhotoDraft> photos = const [],
}) =>
    BeanDraft(
      roaster: roaster,
      name: name,
      origin: origin,
      process: process,
      roastLevel: roastLevel,
      priceBagCents: priceBagCents,
      roastDate: roastDate,
      openedDate: openedDate,
      finishedDate: finishedDate,
      rating: rating,
      notes: notes,
      photos: photos,
    );

BrewDraft brewDraft({
  BrewMethod method = BrewMethod.v60,
  double? doseG = 15,
  double? waterG = 250,
  double? yieldG,
  String? grindSetting,
  int? grinderGearId,
  DateTime? brewedAt,
  int? rating,
  String? notes,
}) =>
    BrewDraft(
      method: method,
      doseG: doseG,
      waterG: waterG,
      yieldG: yieldG,
      grindSetting: grindSetting,
      grinderGearId: grinderGearId,
      brewedAt: brewedAt,
      rating: rating,
      notes: notes,
    );
