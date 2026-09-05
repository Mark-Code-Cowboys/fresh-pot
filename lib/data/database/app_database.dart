import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// This database's concrete journal repository type (cc_core's
/// JournalRepository is generic over the generated table classes).
typedef AppJournalRepository = JournalRepository<$AppJournalEntriesTable,
    $AppJournalPhotosTable, $AppJournalTagsTable>;

// Thin local registrations of cc_core's journal tables (drift can't
// analyze table classes across package boundaries in the default build
// mode, and @UseRowClass doesn't inherit). Names pinned to the shared
// schema so backups stay fleet-compatible.
@UseRowClass(JournalEntry)
class AppJournalEntries extends JournalEntries {
  @override
  String get tableName => 'journal_entries';
}

@UseRowClass(JournalPhoto)
class AppJournalPhotos extends JournalPhotos {
  @override
  String get tableName => 'journal_photos';
}

@UseRowClass(JournalTag)
class AppJournalTags extends JournalTags {
  @override
  String get tableName => 'journal_tags';
}

/// How the coffee was processed. `other` pairs with
/// [Beans.processLabel] for the user's own word.
enum RoastProcess { washed, natural, honey, anaerobic, other }

/// Roast level, light to dark.
enum RoastLevel { light, medLight, medium, medDark, dark }

/// How the cup was brewed. `other` pairs with [Brews.methodLabel].
enum BrewMethod {
  v60,
  chemex,
  aeropress,
  espresso,
  mokaPot,
  frenchPress,
  drip,
  coldBrew,
  siphon,
  other,
}

/// What a piece of gear is. `other` pairs with [Gear.kindLabel].
enum GearKind { grinder, brewer, machine, kettle, scale, other }

/// A bag of coffee — the unit of the journal. The story (rating,
/// tasting notes, bag photos) lives in the shared cc_core journal
/// tables; BeanRepository owns the entry lifecycle.
class Beans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get roaster => text().withLength(min: 1, max: 120)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get origin => text().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get process => textEnum<RoastProcess>().nullable()();
  // The user's own word when process == other.
  TextColumn get processLabel => text().nullable()();
  TextColumn get roastLevel => textEnum<RoastLevel>().nullable()();
  IntColumn get priceBagCents => integer().nullable()();
  IntColumn get bagSizeG => integer().nullable()();
  DateTimeColumn get roastDate => dateTime().nullable()();
  DateTimeColumn get openedDate => dateTime().nullable()();
  // Set when the bag runs out — "active bag" = opened, not finished.
  DateTimeColumn get finishedDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Raw-SQL FK for the same cross-package reason as the journal tables.
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

/// The bench: grinders, brewers, machines. Plain notes — gear has no
/// story, it has settings.
class Gear extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<GearKind>()();
  // The user's own word when kind == other.
  TextColumn get kindLabel => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get notes => text().nullable()();
}

/// One cup. Water XOR yield (espresso weighs what comes out, everything
/// else what goes in) — enforced by CHECK, computed into a ratio in
/// Dart. The story (rating, notes) rides a journal entry.
class Brews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get beanId =>
      integer().references(Beans, #id, onDelete: KeyAction.cascade)();
  TextColumn get method => textEnum<BrewMethod>()();
  // The user's own word when method == other.
  TextColumn get methodLabel => text().nullable()();
  RealColumn get doseG => real().nullable()();
  RealColumn get waterG => real().nullable()();
  RealColumn get yieldG => real().nullable()();
  // Freeform — grinders differ; the grinder ref gives it context.
  TextColumn get grindSetting => text().nullable()();
  IntColumn get grinderGearId =>
      integer().nullable().references(Gear, #id, onDelete: KeyAction.setNull)();
  IntColumn get tempF => integer().nullable()();
  IntColumn get timeSec => integer().nullable()();
  DateTimeColumn get brewedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'CHECK (water_g IS NULL OR yield_g IS NULL)',
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

@DriftDatabase(tables: [
  Beans,
  Gear,
  Brews,
  AppJournalEntries,
  AppJournalPhotos,
  AppJournalTags,
])
class AppDatabase extends _$AppDatabase {
  /// Creates the database over any executor (tests pass an in-memory
  /// NativeDatabase).
  AppDatabase(super.e);

  /// The on-device database file.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'fresh_pot'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// cc_core's journal repository over this database's tables.
  AppJournalRepository journal({PhotoFileStore? photoStore}) =>
      JournalRepository(
        this,
        entries: appJournalEntries,
        photos: appJournalPhotos,
        tags: appJournalTags,
        photoStore: photoStore,
      );
}
