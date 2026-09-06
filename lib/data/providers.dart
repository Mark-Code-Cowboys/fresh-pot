import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/bean_repository.dart';
import 'repositories/brew_repository.dart';
import 'repositories/gear_repository.dart';

/// Overridden in main() with the real on-device database, and in tests
/// with an in-memory one.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

/// Overridden in tests with [InMemoryKeyValueStore].
final kvStoreProvider = Provider<KeyValueStore>((ref) => SharedPrefsStore());

/// Overridden in main() with ImagePickerPhotoService over the app's
/// photo directory, and in tests with a fake.
final photoServiceProvider = Provider<PhotoService>(
  (ref) => throw UnimplementedError('photoServiceProvider must be overridden'),
);

/// Overridden in main() with cc_core's SharePlusLauncher, and in tests
/// with FakeShareLauncher.
final shareLauncherProvider = Provider<ShareLauncher>(
  (ref) =>
      throw UnimplementedError('shareLauncherProvider must be overridden'),
);

/// Overridden in main() with path_provider's temp dir, and in tests
/// with a system temp directory.
final tempDirProvider = Provider<Future<Directory> Function()>(
  (ref) => throw UnimplementedError('tempDirProvider must be overridden'),
);

/// cc_core's journal repository over this database's generated tables.
final journalRepositoryProvider = Provider<AppJournalRepository>(
  (ref) => ref
      .watch(databaseProvider)
      .journal(photoStore: ref.watch(photoServiceProvider)),
);

/// Bags ever added on this device; feeds the free tier so a slot can't
/// be recycled by delete-and-re-add (a bag is your tasting history,
/// not a consumable slot — Phase C wires the gate).
final beanTallyProvider = Provider<LifetimeTally>((ref) {
  final tally = LifetimeTally(ref.watch(kvStoreProvider),
      key: 'beans_created_lifetime');
  ref.onDispose(tally.dispose);
  return tally;
});

final beanRepositoryProvider = Provider<BeanRepository>(
  (ref) => BeanRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider),
      tally: ref.watch(beanTallyProvider)),
);

final brewRepositoryProvider = Provider<BrewRepository>(
  (ref) => BrewRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final gearRepositoryProvider = Provider<GearRepository>(
  (ref) => GearRepository(ref.watch(databaseProvider)),
);
