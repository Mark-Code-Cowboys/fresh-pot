// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppJournalEntriesTable extends AppJournalEntries
    with TableInfo<$AppJournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, notes, rating, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppJournalEntriesTable createAlias(String alias) {
    return $AppJournalEntriesTable(attachedDatabase, alias);
  }
}

class AppJournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String?> notes;
  final Value<int?> rating;
  final Value<DateTime> createdAt;
  const AppJournalEntriesCompanion({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppJournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? notes,
    Expression<int>? rating,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppJournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? notes,
    Value<int?>? rating,
    Value<DateTime>? createdAt,
  }) {
    return AppJournalEntriesCompanion(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('notes: $notes, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BeansTable extends Beans with TableInfo<$BeansTable, Bean> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roasterMeta = const VerificationMeta(
    'roaster',
  );
  @override
  late final GeneratedColumn<String> roaster = GeneratedColumn<String>(
    'roaster',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoastProcess?, String> process =
      GeneratedColumn<String>(
        'process',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<RoastProcess?>($BeansTable.$converterprocessn);
  static const VerificationMeta _processLabelMeta = const VerificationMeta(
    'processLabel',
  );
  @override
  late final GeneratedColumn<String> processLabel = GeneratedColumn<String>(
    'process_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RoastLevel?, String> roastLevel =
      GeneratedColumn<String>(
        'roast_level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<RoastLevel?>($BeansTable.$converterroastLeveln);
  static const VerificationMeta _priceBagCentsMeta = const VerificationMeta(
    'priceBagCents',
  );
  @override
  late final GeneratedColumn<int> priceBagCents = GeneratedColumn<int>(
    'price_bag_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bagSizeGMeta = const VerificationMeta(
    'bagSizeG',
  );
  @override
  late final GeneratedColumn<int> bagSizeG = GeneratedColumn<int>(
    'bag_size_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roastDateMeta = const VerificationMeta(
    'roastDate',
  );
  @override
  late final GeneratedColumn<DateTime> roastDate = GeneratedColumn<DateTime>(
    'roast_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openedDateMeta = const VerificationMeta(
    'openedDate',
  );
  @override
  late final GeneratedColumn<DateTime> openedDate = GeneratedColumn<DateTime>(
    'opened_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedDateMeta = const VerificationMeta(
    'finishedDate',
  );
  @override
  late final GeneratedColumn<DateTime> finishedDate = GeneratedColumn<DateTime>(
    'finished_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roaster,
    name,
    origin,
    region,
    process,
    processLabel,
    roastLevel,
    priceBagCents,
    bagSizeG,
    roastDate,
    openedDate,
    finishedDate,
    createdAt,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bean> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('roaster')) {
      context.handle(
        _roasterMeta,
        roaster.isAcceptableOrUnknown(data['roaster']!, _roasterMeta),
      );
    } else if (isInserting) {
      context.missing(_roasterMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('process_label')) {
      context.handle(
        _processLabelMeta,
        processLabel.isAcceptableOrUnknown(
          data['process_label']!,
          _processLabelMeta,
        ),
      );
    }
    if (data.containsKey('price_bag_cents')) {
      context.handle(
        _priceBagCentsMeta,
        priceBagCents.isAcceptableOrUnknown(
          data['price_bag_cents']!,
          _priceBagCentsMeta,
        ),
      );
    }
    if (data.containsKey('bag_size_g')) {
      context.handle(
        _bagSizeGMeta,
        bagSizeG.isAcceptableOrUnknown(data['bag_size_g']!, _bagSizeGMeta),
      );
    }
    if (data.containsKey('roast_date')) {
      context.handle(
        _roastDateMeta,
        roastDate.isAcceptableOrUnknown(data['roast_date']!, _roastDateMeta),
      );
    }
    if (data.containsKey('opened_date')) {
      context.handle(
        _openedDateMeta,
        openedDate.isAcceptableOrUnknown(data['opened_date']!, _openedDateMeta),
      );
    }
    if (data.containsKey('finished_date')) {
      context.handle(
        _finishedDateMeta,
        finishedDate.isAcceptableOrUnknown(
          data['finished_date']!,
          _finishedDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bean map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bean(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roaster: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roaster'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      process: $BeansTable.$converterprocessn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}process'],
        ),
      ),
      processLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_label'],
      ),
      roastLevel: $BeansTable.$converterroastLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}roast_level'],
        ),
      ),
      priceBagCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_bag_cents'],
      ),
      bagSizeG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bag_size_g'],
      ),
      roastDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}roast_date'],
      ),
      openedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_date'],
      ),
      finishedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $BeansTable createAlias(String alias) {
    return $BeansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RoastProcess, String, String> $converterprocess =
      const EnumNameConverter<RoastProcess>(RoastProcess.values);
  static JsonTypeConverter2<RoastProcess?, String?, String?>
  $converterprocessn = JsonTypeConverter2.asNullable($converterprocess);
  static JsonTypeConverter2<RoastLevel, String, String> $converterroastLevel =
      const EnumNameConverter<RoastLevel>(RoastLevel.values);
  static JsonTypeConverter2<RoastLevel?, String?, String?>
  $converterroastLeveln = JsonTypeConverter2.asNullable($converterroastLevel);
}

class Bean extends DataClass implements Insertable<Bean> {
  final int id;
  final String roaster;
  final String name;
  final String? origin;
  final String? region;
  final RoastProcess? process;
  final String? processLabel;
  final RoastLevel? roastLevel;
  final int? priceBagCents;
  final int? bagSizeG;
  final DateTime? roastDate;
  final DateTime? openedDate;
  final DateTime? finishedDate;
  final DateTime createdAt;
  final int? journalEntryId;
  const Bean({
    required this.id,
    required this.roaster,
    required this.name,
    this.origin,
    this.region,
    this.process,
    this.processLabel,
    this.roastLevel,
    this.priceBagCents,
    this.bagSizeG,
    this.roastDate,
    this.openedDate,
    this.finishedDate,
    required this.createdAt,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['roaster'] = Variable<String>(roaster);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || process != null) {
      map['process'] = Variable<String>(
        $BeansTable.$converterprocessn.toSql(process),
      );
    }
    if (!nullToAbsent || processLabel != null) {
      map['process_label'] = Variable<String>(processLabel);
    }
    if (!nullToAbsent || roastLevel != null) {
      map['roast_level'] = Variable<String>(
        $BeansTable.$converterroastLeveln.toSql(roastLevel),
      );
    }
    if (!nullToAbsent || priceBagCents != null) {
      map['price_bag_cents'] = Variable<int>(priceBagCents);
    }
    if (!nullToAbsent || bagSizeG != null) {
      map['bag_size_g'] = Variable<int>(bagSizeG);
    }
    if (!nullToAbsent || roastDate != null) {
      map['roast_date'] = Variable<DateTime>(roastDate);
    }
    if (!nullToAbsent || openedDate != null) {
      map['opened_date'] = Variable<DateTime>(openedDate);
    }
    if (!nullToAbsent || finishedDate != null) {
      map['finished_date'] = Variable<DateTime>(finishedDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  BeansCompanion toCompanion(bool nullToAbsent) {
    return BeansCompanion(
      id: Value(id),
      roaster: Value(roaster),
      name: Value(name),
      origin: origin == null && nullToAbsent
          ? const Value.absent()
          : Value(origin),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      process: process == null && nullToAbsent
          ? const Value.absent()
          : Value(process),
      processLabel: processLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(processLabel),
      roastLevel: roastLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(roastLevel),
      priceBagCents: priceBagCents == null && nullToAbsent
          ? const Value.absent()
          : Value(priceBagCents),
      bagSizeG: bagSizeG == null && nullToAbsent
          ? const Value.absent()
          : Value(bagSizeG),
      roastDate: roastDate == null && nullToAbsent
          ? const Value.absent()
          : Value(roastDate),
      openedDate: openedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(openedDate),
      finishedDate: finishedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedDate),
      createdAt: Value(createdAt),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory Bean.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bean(
      id: serializer.fromJson<int>(json['id']),
      roaster: serializer.fromJson<String>(json['roaster']),
      name: serializer.fromJson<String>(json['name']),
      origin: serializer.fromJson<String?>(json['origin']),
      region: serializer.fromJson<String?>(json['region']),
      process: $BeansTable.$converterprocessn.fromJson(
        serializer.fromJson<String?>(json['process']),
      ),
      processLabel: serializer.fromJson<String?>(json['processLabel']),
      roastLevel: $BeansTable.$converterroastLeveln.fromJson(
        serializer.fromJson<String?>(json['roastLevel']),
      ),
      priceBagCents: serializer.fromJson<int?>(json['priceBagCents']),
      bagSizeG: serializer.fromJson<int?>(json['bagSizeG']),
      roastDate: serializer.fromJson<DateTime?>(json['roastDate']),
      openedDate: serializer.fromJson<DateTime?>(json['openedDate']),
      finishedDate: serializer.fromJson<DateTime?>(json['finishedDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roaster': serializer.toJson<String>(roaster),
      'name': serializer.toJson<String>(name),
      'origin': serializer.toJson<String?>(origin),
      'region': serializer.toJson<String?>(region),
      'process': serializer.toJson<String?>(
        $BeansTable.$converterprocessn.toJson(process),
      ),
      'processLabel': serializer.toJson<String?>(processLabel),
      'roastLevel': serializer.toJson<String?>(
        $BeansTable.$converterroastLeveln.toJson(roastLevel),
      ),
      'priceBagCents': serializer.toJson<int?>(priceBagCents),
      'bagSizeG': serializer.toJson<int?>(bagSizeG),
      'roastDate': serializer.toJson<DateTime?>(roastDate),
      'openedDate': serializer.toJson<DateTime?>(openedDate),
      'finishedDate': serializer.toJson<DateTime?>(finishedDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  Bean copyWith({
    int? id,
    String? roaster,
    String? name,
    Value<String?> origin = const Value.absent(),
    Value<String?> region = const Value.absent(),
    Value<RoastProcess?> process = const Value.absent(),
    Value<String?> processLabel = const Value.absent(),
    Value<RoastLevel?> roastLevel = const Value.absent(),
    Value<int?> priceBagCents = const Value.absent(),
    Value<int?> bagSizeG = const Value.absent(),
    Value<DateTime?> roastDate = const Value.absent(),
    Value<DateTime?> openedDate = const Value.absent(),
    Value<DateTime?> finishedDate = const Value.absent(),
    DateTime? createdAt,
    Value<int?> journalEntryId = const Value.absent(),
  }) => Bean(
    id: id ?? this.id,
    roaster: roaster ?? this.roaster,
    name: name ?? this.name,
    origin: origin.present ? origin.value : this.origin,
    region: region.present ? region.value : this.region,
    process: process.present ? process.value : this.process,
    processLabel: processLabel.present ? processLabel.value : this.processLabel,
    roastLevel: roastLevel.present ? roastLevel.value : this.roastLevel,
    priceBagCents: priceBagCents.present
        ? priceBagCents.value
        : this.priceBagCents,
    bagSizeG: bagSizeG.present ? bagSizeG.value : this.bagSizeG,
    roastDate: roastDate.present ? roastDate.value : this.roastDate,
    openedDate: openedDate.present ? openedDate.value : this.openedDate,
    finishedDate: finishedDate.present ? finishedDate.value : this.finishedDate,
    createdAt: createdAt ?? this.createdAt,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  Bean copyWithCompanion(BeansCompanion data) {
    return Bean(
      id: data.id.present ? data.id.value : this.id,
      roaster: data.roaster.present ? data.roaster.value : this.roaster,
      name: data.name.present ? data.name.value : this.name,
      origin: data.origin.present ? data.origin.value : this.origin,
      region: data.region.present ? data.region.value : this.region,
      process: data.process.present ? data.process.value : this.process,
      processLabel: data.processLabel.present
          ? data.processLabel.value
          : this.processLabel,
      roastLevel: data.roastLevel.present
          ? data.roastLevel.value
          : this.roastLevel,
      priceBagCents: data.priceBagCents.present
          ? data.priceBagCents.value
          : this.priceBagCents,
      bagSizeG: data.bagSizeG.present ? data.bagSizeG.value : this.bagSizeG,
      roastDate: data.roastDate.present ? data.roastDate.value : this.roastDate,
      openedDate: data.openedDate.present
          ? data.openedDate.value
          : this.openedDate,
      finishedDate: data.finishedDate.present
          ? data.finishedDate.value
          : this.finishedDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bean(')
          ..write('id: $id, ')
          ..write('roaster: $roaster, ')
          ..write('name: $name, ')
          ..write('origin: $origin, ')
          ..write('region: $region, ')
          ..write('process: $process, ')
          ..write('processLabel: $processLabel, ')
          ..write('roastLevel: $roastLevel, ')
          ..write('priceBagCents: $priceBagCents, ')
          ..write('bagSizeG: $bagSizeG, ')
          ..write('roastDate: $roastDate, ')
          ..write('openedDate: $openedDate, ')
          ..write('finishedDate: $finishedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roaster,
    name,
    origin,
    region,
    process,
    processLabel,
    roastLevel,
    priceBagCents,
    bagSizeG,
    roastDate,
    openedDate,
    finishedDate,
    createdAt,
    journalEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bean &&
          other.id == this.id &&
          other.roaster == this.roaster &&
          other.name == this.name &&
          other.origin == this.origin &&
          other.region == this.region &&
          other.process == this.process &&
          other.processLabel == this.processLabel &&
          other.roastLevel == this.roastLevel &&
          other.priceBagCents == this.priceBagCents &&
          other.bagSizeG == this.bagSizeG &&
          other.roastDate == this.roastDate &&
          other.openedDate == this.openedDate &&
          other.finishedDate == this.finishedDate &&
          other.createdAt == this.createdAt &&
          other.journalEntryId == this.journalEntryId);
}

class BeansCompanion extends UpdateCompanion<Bean> {
  final Value<int> id;
  final Value<String> roaster;
  final Value<String> name;
  final Value<String?> origin;
  final Value<String?> region;
  final Value<RoastProcess?> process;
  final Value<String?> processLabel;
  final Value<RoastLevel?> roastLevel;
  final Value<int?> priceBagCents;
  final Value<int?> bagSizeG;
  final Value<DateTime?> roastDate;
  final Value<DateTime?> openedDate;
  final Value<DateTime?> finishedDate;
  final Value<DateTime> createdAt;
  final Value<int?> journalEntryId;
  const BeansCompanion({
    this.id = const Value.absent(),
    this.roaster = const Value.absent(),
    this.name = const Value.absent(),
    this.origin = const Value.absent(),
    this.region = const Value.absent(),
    this.process = const Value.absent(),
    this.processLabel = const Value.absent(),
    this.roastLevel = const Value.absent(),
    this.priceBagCents = const Value.absent(),
    this.bagSizeG = const Value.absent(),
    this.roastDate = const Value.absent(),
    this.openedDate = const Value.absent(),
    this.finishedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  BeansCompanion.insert({
    this.id = const Value.absent(),
    required String roaster,
    required String name,
    this.origin = const Value.absent(),
    this.region = const Value.absent(),
    this.process = const Value.absent(),
    this.processLabel = const Value.absent(),
    this.roastLevel = const Value.absent(),
    this.priceBagCents = const Value.absent(),
    this.bagSizeG = const Value.absent(),
    this.roastDate = const Value.absent(),
    this.openedDate = const Value.absent(),
    this.finishedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : roaster = Value(roaster),
       name = Value(name);
  static Insertable<Bean> custom({
    Expression<int>? id,
    Expression<String>? roaster,
    Expression<String>? name,
    Expression<String>? origin,
    Expression<String>? region,
    Expression<String>? process,
    Expression<String>? processLabel,
    Expression<String>? roastLevel,
    Expression<int>? priceBagCents,
    Expression<int>? bagSizeG,
    Expression<DateTime>? roastDate,
    Expression<DateTime>? openedDate,
    Expression<DateTime>? finishedDate,
    Expression<DateTime>? createdAt,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roaster != null) 'roaster': roaster,
      if (name != null) 'name': name,
      if (origin != null) 'origin': origin,
      if (region != null) 'region': region,
      if (process != null) 'process': process,
      if (processLabel != null) 'process_label': processLabel,
      if (roastLevel != null) 'roast_level': roastLevel,
      if (priceBagCents != null) 'price_bag_cents': priceBagCents,
      if (bagSizeG != null) 'bag_size_g': bagSizeG,
      if (roastDate != null) 'roast_date': roastDate,
      if (openedDate != null) 'opened_date': openedDate,
      if (finishedDate != null) 'finished_date': finishedDate,
      if (createdAt != null) 'created_at': createdAt,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  BeansCompanion copyWith({
    Value<int>? id,
    Value<String>? roaster,
    Value<String>? name,
    Value<String?>? origin,
    Value<String?>? region,
    Value<RoastProcess?>? process,
    Value<String?>? processLabel,
    Value<RoastLevel?>? roastLevel,
    Value<int?>? priceBagCents,
    Value<int?>? bagSizeG,
    Value<DateTime?>? roastDate,
    Value<DateTime?>? openedDate,
    Value<DateTime?>? finishedDate,
    Value<DateTime>? createdAt,
    Value<int?>? journalEntryId,
  }) {
    return BeansCompanion(
      id: id ?? this.id,
      roaster: roaster ?? this.roaster,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      region: region ?? this.region,
      process: process ?? this.process,
      processLabel: processLabel ?? this.processLabel,
      roastLevel: roastLevel ?? this.roastLevel,
      priceBagCents: priceBagCents ?? this.priceBagCents,
      bagSizeG: bagSizeG ?? this.bagSizeG,
      roastDate: roastDate ?? this.roastDate,
      openedDate: openedDate ?? this.openedDate,
      finishedDate: finishedDate ?? this.finishedDate,
      createdAt: createdAt ?? this.createdAt,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roaster.present) {
      map['roaster'] = Variable<String>(roaster.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (process.present) {
      map['process'] = Variable<String>(
        $BeansTable.$converterprocessn.toSql(process.value),
      );
    }
    if (processLabel.present) {
      map['process_label'] = Variable<String>(processLabel.value);
    }
    if (roastLevel.present) {
      map['roast_level'] = Variable<String>(
        $BeansTable.$converterroastLeveln.toSql(roastLevel.value),
      );
    }
    if (priceBagCents.present) {
      map['price_bag_cents'] = Variable<int>(priceBagCents.value);
    }
    if (bagSizeG.present) {
      map['bag_size_g'] = Variable<int>(bagSizeG.value);
    }
    if (roastDate.present) {
      map['roast_date'] = Variable<DateTime>(roastDate.value);
    }
    if (openedDate.present) {
      map['opened_date'] = Variable<DateTime>(openedDate.value);
    }
    if (finishedDate.present) {
      map['finished_date'] = Variable<DateTime>(finishedDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeansCompanion(')
          ..write('id: $id, ')
          ..write('roaster: $roaster, ')
          ..write('name: $name, ')
          ..write('origin: $origin, ')
          ..write('region: $region, ')
          ..write('process: $process, ')
          ..write('processLabel: $processLabel, ')
          ..write('roastLevel: $roastLevel, ')
          ..write('priceBagCents: $priceBagCents, ')
          ..write('bagSizeG: $bagSizeG, ')
          ..write('roastDate: $roastDate, ')
          ..write('openedDate: $openedDate, ')
          ..write('finishedDate: $finishedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $GearTable extends Gear with TableInfo<$GearTable, GearData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GearTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GearKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GearKind>($GearTable.$converterkind);
  static const VerificationMeta _kindLabelMeta = const VerificationMeta(
    'kindLabel',
  );
  @override
  late final GeneratedColumn<String> kindLabel = GeneratedColumn<String>(
    'kind_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, kindLabel, name, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gear';
  @override
  VerificationContext validateIntegrity(
    Insertable<GearData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind_label')) {
      context.handle(
        _kindLabelMeta,
        kindLabel.isAcceptableOrUnknown(data['kind_label']!, _kindLabelMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GearData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GearData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $GearTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      kindLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind_label'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $GearTable createAlias(String alias) {
    return $GearTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GearKind, String, String> $converterkind =
      const EnumNameConverter<GearKind>(GearKind.values);
}

class GearData extends DataClass implements Insertable<GearData> {
  final int id;
  final GearKind kind;
  final String? kindLabel;
  final String name;
  final String? notes;
  const GearData({
    required this.id,
    required this.kind,
    this.kindLabel,
    required this.name,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>($GearTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || kindLabel != null) {
      map['kind_label'] = Variable<String>(kindLabel);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  GearCompanion toCompanion(bool nullToAbsent) {
    return GearCompanion(
      id: Value(id),
      kind: Value(kind),
      kindLabel: kindLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(kindLabel),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory GearData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GearData(
      id: serializer.fromJson<int>(json['id']),
      kind: $GearTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      kindLabel: serializer.fromJson<String?>(json['kindLabel']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>($GearTable.$converterkind.toJson(kind)),
      'kindLabel': serializer.toJson<String?>(kindLabel),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  GearData copyWith({
    int? id,
    GearKind? kind,
    Value<String?> kindLabel = const Value.absent(),
    String? name,
    Value<String?> notes = const Value.absent(),
  }) => GearData(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    kindLabel: kindLabel.present ? kindLabel.value : this.kindLabel,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
  );
  GearData copyWithCompanion(GearCompanion data) {
    return GearData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      kindLabel: data.kindLabel.present ? data.kindLabel.value : this.kindLabel,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GearData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('name: $name, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, kindLabel, name, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GearData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.kindLabel == this.kindLabel &&
          other.name == this.name &&
          other.notes == this.notes);
}

class GearCompanion extends UpdateCompanion<GearData> {
  final Value<int> id;
  final Value<GearKind> kind;
  final Value<String?> kindLabel;
  final Value<String> name;
  final Value<String?> notes;
  const GearCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.kindLabel = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
  });
  GearCompanion.insert({
    this.id = const Value.absent(),
    required GearKind kind,
    this.kindLabel = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
  }) : kind = Value(kind),
       name = Value(name);
  static Insertable<GearData> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? kindLabel,
    Expression<String>? name,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (kindLabel != null) 'kind_label': kindLabel,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
    });
  }

  GearCompanion copyWith({
    Value<int>? id,
    Value<GearKind>? kind,
    Value<String?>? kindLabel,
    Value<String>? name,
    Value<String?>? notes,
  }) {
    return GearCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      kindLabel: kindLabel ?? this.kindLabel,
      name: name ?? this.name,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $GearTable.$converterkind.toSql(kind.value),
      );
    }
    if (kindLabel.present) {
      map['kind_label'] = Variable<String>(kindLabel.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GearCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('name: $name, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BrewsTable extends Brews with TableInfo<$BrewsTable, Brew> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _beanIdMeta = const VerificationMeta('beanId');
  @override
  late final GeneratedColumn<int> beanId = GeneratedColumn<int>(
    'bean_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES beans (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BrewMethod, String> method =
      GeneratedColumn<String>(
        'method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BrewMethod>($BrewsTable.$convertermethod);
  static const VerificationMeta _methodLabelMeta = const VerificationMeta(
    'methodLabel',
  );
  @override
  late final GeneratedColumn<String> methodLabel = GeneratedColumn<String>(
    'method_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doseGMeta = const VerificationMeta('doseG');
  @override
  late final GeneratedColumn<double> doseG = GeneratedColumn<double>(
    'dose_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterGMeta = const VerificationMeta('waterG');
  @override
  late final GeneratedColumn<double> waterG = GeneratedColumn<double>(
    'water_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yieldGMeta = const VerificationMeta('yieldG');
  @override
  late final GeneratedColumn<double> yieldG = GeneratedColumn<double>(
    'yield_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grindSettingMeta = const VerificationMeta(
    'grindSetting',
  );
  @override
  late final GeneratedColumn<String> grindSetting = GeneratedColumn<String>(
    'grind_setting',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grinderGearIdMeta = const VerificationMeta(
    'grinderGearId',
  );
  @override
  late final GeneratedColumn<int> grinderGearId = GeneratedColumn<int>(
    'grinder_gear_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gear (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _tempFMeta = const VerificationMeta('tempF');
  @override
  late final GeneratedColumn<int> tempF = GeneratedColumn<int>(
    'temp_f',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeSecMeta = const VerificationMeta(
    'timeSec',
  );
  @override
  late final GeneratedColumn<int> timeSec = GeneratedColumn<int>(
    'time_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brewedAtMeta = const VerificationMeta(
    'brewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> brewedAt = GeneratedColumn<DateTime>(
    'brewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    beanId,
    method,
    methodLabel,
    doseG,
    waterG,
    yieldG,
    grindSetting,
    grinderGearId,
    tempF,
    timeSec,
    brewedAt,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brews';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brew> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bean_id')) {
      context.handle(
        _beanIdMeta,
        beanId.isAcceptableOrUnknown(data['bean_id']!, _beanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_beanIdMeta);
    }
    if (data.containsKey('method_label')) {
      context.handle(
        _methodLabelMeta,
        methodLabel.isAcceptableOrUnknown(
          data['method_label']!,
          _methodLabelMeta,
        ),
      );
    }
    if (data.containsKey('dose_g')) {
      context.handle(
        _doseGMeta,
        doseG.isAcceptableOrUnknown(data['dose_g']!, _doseGMeta),
      );
    }
    if (data.containsKey('water_g')) {
      context.handle(
        _waterGMeta,
        waterG.isAcceptableOrUnknown(data['water_g']!, _waterGMeta),
      );
    }
    if (data.containsKey('yield_g')) {
      context.handle(
        _yieldGMeta,
        yieldG.isAcceptableOrUnknown(data['yield_g']!, _yieldGMeta),
      );
    }
    if (data.containsKey('grind_setting')) {
      context.handle(
        _grindSettingMeta,
        grindSetting.isAcceptableOrUnknown(
          data['grind_setting']!,
          _grindSettingMeta,
        ),
      );
    }
    if (data.containsKey('grinder_gear_id')) {
      context.handle(
        _grinderGearIdMeta,
        grinderGearId.isAcceptableOrUnknown(
          data['grinder_gear_id']!,
          _grinderGearIdMeta,
        ),
      );
    }
    if (data.containsKey('temp_f')) {
      context.handle(
        _tempFMeta,
        tempF.isAcceptableOrUnknown(data['temp_f']!, _tempFMeta),
      );
    }
    if (data.containsKey('time_sec')) {
      context.handle(
        _timeSecMeta,
        timeSec.isAcceptableOrUnknown(data['time_sec']!, _timeSecMeta),
      );
    }
    if (data.containsKey('brewed_at')) {
      context.handle(
        _brewedAtMeta,
        brewedAt.isAcceptableOrUnknown(data['brewed_at']!, _brewedAtMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brew map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brew(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      beanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bean_id'],
      )!,
      method: $BrewsTable.$convertermethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}method'],
        )!,
      ),
      methodLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method_label'],
      ),
      doseG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose_g'],
      ),
      waterG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_g'],
      ),
      yieldG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}yield_g'],
      ),
      grindSetting: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grind_setting'],
      ),
      grinderGearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grinder_gear_id'],
      ),
      tempF: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}temp_f'],
      ),
      timeSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_sec'],
      ),
      brewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}brewed_at'],
      )!,
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $BrewsTable createAlias(String alias) {
    return $BrewsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BrewMethod, String, String> $convertermethod =
      const EnumNameConverter<BrewMethod>(BrewMethod.values);
}

class Brew extends DataClass implements Insertable<Brew> {
  final int id;
  final int beanId;
  final BrewMethod method;
  final String? methodLabel;
  final double? doseG;
  final double? waterG;
  final double? yieldG;
  final String? grindSetting;
  final int? grinderGearId;
  final int? tempF;
  final int? timeSec;
  final DateTime brewedAt;
  final int? journalEntryId;
  const Brew({
    required this.id,
    required this.beanId,
    required this.method,
    this.methodLabel,
    this.doseG,
    this.waterG,
    this.yieldG,
    this.grindSetting,
    this.grinderGearId,
    this.tempF,
    this.timeSec,
    required this.brewedAt,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bean_id'] = Variable<int>(beanId);
    {
      map['method'] = Variable<String>(
        $BrewsTable.$convertermethod.toSql(method),
      );
    }
    if (!nullToAbsent || methodLabel != null) {
      map['method_label'] = Variable<String>(methodLabel);
    }
    if (!nullToAbsent || doseG != null) {
      map['dose_g'] = Variable<double>(doseG);
    }
    if (!nullToAbsent || waterG != null) {
      map['water_g'] = Variable<double>(waterG);
    }
    if (!nullToAbsent || yieldG != null) {
      map['yield_g'] = Variable<double>(yieldG);
    }
    if (!nullToAbsent || grindSetting != null) {
      map['grind_setting'] = Variable<String>(grindSetting);
    }
    if (!nullToAbsent || grinderGearId != null) {
      map['grinder_gear_id'] = Variable<int>(grinderGearId);
    }
    if (!nullToAbsent || tempF != null) {
      map['temp_f'] = Variable<int>(tempF);
    }
    if (!nullToAbsent || timeSec != null) {
      map['time_sec'] = Variable<int>(timeSec);
    }
    map['brewed_at'] = Variable<DateTime>(brewedAt);
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  BrewsCompanion toCompanion(bool nullToAbsent) {
    return BrewsCompanion(
      id: Value(id),
      beanId: Value(beanId),
      method: Value(method),
      methodLabel: methodLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(methodLabel),
      doseG: doseG == null && nullToAbsent
          ? const Value.absent()
          : Value(doseG),
      waterG: waterG == null && nullToAbsent
          ? const Value.absent()
          : Value(waterG),
      yieldG: yieldG == null && nullToAbsent
          ? const Value.absent()
          : Value(yieldG),
      grindSetting: grindSetting == null && nullToAbsent
          ? const Value.absent()
          : Value(grindSetting),
      grinderGearId: grinderGearId == null && nullToAbsent
          ? const Value.absent()
          : Value(grinderGearId),
      tempF: tempF == null && nullToAbsent
          ? const Value.absent()
          : Value(tempF),
      timeSec: timeSec == null && nullToAbsent
          ? const Value.absent()
          : Value(timeSec),
      brewedAt: Value(brewedAt),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory Brew.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brew(
      id: serializer.fromJson<int>(json['id']),
      beanId: serializer.fromJson<int>(json['beanId']),
      method: $BrewsTable.$convertermethod.fromJson(
        serializer.fromJson<String>(json['method']),
      ),
      methodLabel: serializer.fromJson<String?>(json['methodLabel']),
      doseG: serializer.fromJson<double?>(json['doseG']),
      waterG: serializer.fromJson<double?>(json['waterG']),
      yieldG: serializer.fromJson<double?>(json['yieldG']),
      grindSetting: serializer.fromJson<String?>(json['grindSetting']),
      grinderGearId: serializer.fromJson<int?>(json['grinderGearId']),
      tempF: serializer.fromJson<int?>(json['tempF']),
      timeSec: serializer.fromJson<int?>(json['timeSec']),
      brewedAt: serializer.fromJson<DateTime>(json['brewedAt']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'beanId': serializer.toJson<int>(beanId),
      'method': serializer.toJson<String>(
        $BrewsTable.$convertermethod.toJson(method),
      ),
      'methodLabel': serializer.toJson<String?>(methodLabel),
      'doseG': serializer.toJson<double?>(doseG),
      'waterG': serializer.toJson<double?>(waterG),
      'yieldG': serializer.toJson<double?>(yieldG),
      'grindSetting': serializer.toJson<String?>(grindSetting),
      'grinderGearId': serializer.toJson<int?>(grinderGearId),
      'tempF': serializer.toJson<int?>(tempF),
      'timeSec': serializer.toJson<int?>(timeSec),
      'brewedAt': serializer.toJson<DateTime>(brewedAt),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  Brew copyWith({
    int? id,
    int? beanId,
    BrewMethod? method,
    Value<String?> methodLabel = const Value.absent(),
    Value<double?> doseG = const Value.absent(),
    Value<double?> waterG = const Value.absent(),
    Value<double?> yieldG = const Value.absent(),
    Value<String?> grindSetting = const Value.absent(),
    Value<int?> grinderGearId = const Value.absent(),
    Value<int?> tempF = const Value.absent(),
    Value<int?> timeSec = const Value.absent(),
    DateTime? brewedAt,
    Value<int?> journalEntryId = const Value.absent(),
  }) => Brew(
    id: id ?? this.id,
    beanId: beanId ?? this.beanId,
    method: method ?? this.method,
    methodLabel: methodLabel.present ? methodLabel.value : this.methodLabel,
    doseG: doseG.present ? doseG.value : this.doseG,
    waterG: waterG.present ? waterG.value : this.waterG,
    yieldG: yieldG.present ? yieldG.value : this.yieldG,
    grindSetting: grindSetting.present ? grindSetting.value : this.grindSetting,
    grinderGearId: grinderGearId.present
        ? grinderGearId.value
        : this.grinderGearId,
    tempF: tempF.present ? tempF.value : this.tempF,
    timeSec: timeSec.present ? timeSec.value : this.timeSec,
    brewedAt: brewedAt ?? this.brewedAt,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  Brew copyWithCompanion(BrewsCompanion data) {
    return Brew(
      id: data.id.present ? data.id.value : this.id,
      beanId: data.beanId.present ? data.beanId.value : this.beanId,
      method: data.method.present ? data.method.value : this.method,
      methodLabel: data.methodLabel.present
          ? data.methodLabel.value
          : this.methodLabel,
      doseG: data.doseG.present ? data.doseG.value : this.doseG,
      waterG: data.waterG.present ? data.waterG.value : this.waterG,
      yieldG: data.yieldG.present ? data.yieldG.value : this.yieldG,
      grindSetting: data.grindSetting.present
          ? data.grindSetting.value
          : this.grindSetting,
      grinderGearId: data.grinderGearId.present
          ? data.grinderGearId.value
          : this.grinderGearId,
      tempF: data.tempF.present ? data.tempF.value : this.tempF,
      timeSec: data.timeSec.present ? data.timeSec.value : this.timeSec,
      brewedAt: data.brewedAt.present ? data.brewedAt.value : this.brewedAt,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brew(')
          ..write('id: $id, ')
          ..write('beanId: $beanId, ')
          ..write('method: $method, ')
          ..write('methodLabel: $methodLabel, ')
          ..write('doseG: $doseG, ')
          ..write('waterG: $waterG, ')
          ..write('yieldG: $yieldG, ')
          ..write('grindSetting: $grindSetting, ')
          ..write('grinderGearId: $grinderGearId, ')
          ..write('tempF: $tempF, ')
          ..write('timeSec: $timeSec, ')
          ..write('brewedAt: $brewedAt, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    beanId,
    method,
    methodLabel,
    doseG,
    waterG,
    yieldG,
    grindSetting,
    grinderGearId,
    tempF,
    timeSec,
    brewedAt,
    journalEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brew &&
          other.id == this.id &&
          other.beanId == this.beanId &&
          other.method == this.method &&
          other.methodLabel == this.methodLabel &&
          other.doseG == this.doseG &&
          other.waterG == this.waterG &&
          other.yieldG == this.yieldG &&
          other.grindSetting == this.grindSetting &&
          other.grinderGearId == this.grinderGearId &&
          other.tempF == this.tempF &&
          other.timeSec == this.timeSec &&
          other.brewedAt == this.brewedAt &&
          other.journalEntryId == this.journalEntryId);
}

class BrewsCompanion extends UpdateCompanion<Brew> {
  final Value<int> id;
  final Value<int> beanId;
  final Value<BrewMethod> method;
  final Value<String?> methodLabel;
  final Value<double?> doseG;
  final Value<double?> waterG;
  final Value<double?> yieldG;
  final Value<String?> grindSetting;
  final Value<int?> grinderGearId;
  final Value<int?> tempF;
  final Value<int?> timeSec;
  final Value<DateTime> brewedAt;
  final Value<int?> journalEntryId;
  const BrewsCompanion({
    this.id = const Value.absent(),
    this.beanId = const Value.absent(),
    this.method = const Value.absent(),
    this.methodLabel = const Value.absent(),
    this.doseG = const Value.absent(),
    this.waterG = const Value.absent(),
    this.yieldG = const Value.absent(),
    this.grindSetting = const Value.absent(),
    this.grinderGearId = const Value.absent(),
    this.tempF = const Value.absent(),
    this.timeSec = const Value.absent(),
    this.brewedAt = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  BrewsCompanion.insert({
    this.id = const Value.absent(),
    required int beanId,
    required BrewMethod method,
    this.methodLabel = const Value.absent(),
    this.doseG = const Value.absent(),
    this.waterG = const Value.absent(),
    this.yieldG = const Value.absent(),
    this.grindSetting = const Value.absent(),
    this.grinderGearId = const Value.absent(),
    this.tempF = const Value.absent(),
    this.timeSec = const Value.absent(),
    this.brewedAt = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : beanId = Value(beanId),
       method = Value(method);
  static Insertable<Brew> custom({
    Expression<int>? id,
    Expression<int>? beanId,
    Expression<String>? method,
    Expression<String>? methodLabel,
    Expression<double>? doseG,
    Expression<double>? waterG,
    Expression<double>? yieldG,
    Expression<String>? grindSetting,
    Expression<int>? grinderGearId,
    Expression<int>? tempF,
    Expression<int>? timeSec,
    Expression<DateTime>? brewedAt,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (beanId != null) 'bean_id': beanId,
      if (method != null) 'method': method,
      if (methodLabel != null) 'method_label': methodLabel,
      if (doseG != null) 'dose_g': doseG,
      if (waterG != null) 'water_g': waterG,
      if (yieldG != null) 'yield_g': yieldG,
      if (grindSetting != null) 'grind_setting': grindSetting,
      if (grinderGearId != null) 'grinder_gear_id': grinderGearId,
      if (tempF != null) 'temp_f': tempF,
      if (timeSec != null) 'time_sec': timeSec,
      if (brewedAt != null) 'brewed_at': brewedAt,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  BrewsCompanion copyWith({
    Value<int>? id,
    Value<int>? beanId,
    Value<BrewMethod>? method,
    Value<String?>? methodLabel,
    Value<double?>? doseG,
    Value<double?>? waterG,
    Value<double?>? yieldG,
    Value<String?>? grindSetting,
    Value<int?>? grinderGearId,
    Value<int?>? tempF,
    Value<int?>? timeSec,
    Value<DateTime>? brewedAt,
    Value<int?>? journalEntryId,
  }) {
    return BrewsCompanion(
      id: id ?? this.id,
      beanId: beanId ?? this.beanId,
      method: method ?? this.method,
      methodLabel: methodLabel ?? this.methodLabel,
      doseG: doseG ?? this.doseG,
      waterG: waterG ?? this.waterG,
      yieldG: yieldG ?? this.yieldG,
      grindSetting: grindSetting ?? this.grindSetting,
      grinderGearId: grinderGearId ?? this.grinderGearId,
      tempF: tempF ?? this.tempF,
      timeSec: timeSec ?? this.timeSec,
      brewedAt: brewedAt ?? this.brewedAt,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (beanId.present) {
      map['bean_id'] = Variable<int>(beanId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(
        $BrewsTable.$convertermethod.toSql(method.value),
      );
    }
    if (methodLabel.present) {
      map['method_label'] = Variable<String>(methodLabel.value);
    }
    if (doseG.present) {
      map['dose_g'] = Variable<double>(doseG.value);
    }
    if (waterG.present) {
      map['water_g'] = Variable<double>(waterG.value);
    }
    if (yieldG.present) {
      map['yield_g'] = Variable<double>(yieldG.value);
    }
    if (grindSetting.present) {
      map['grind_setting'] = Variable<String>(grindSetting.value);
    }
    if (grinderGearId.present) {
      map['grinder_gear_id'] = Variable<int>(grinderGearId.value);
    }
    if (tempF.present) {
      map['temp_f'] = Variable<int>(tempF.value);
    }
    if (timeSec.present) {
      map['time_sec'] = Variable<int>(timeSec.value);
    }
    if (brewedAt.present) {
      map['brewed_at'] = Variable<DateTime>(brewedAt.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewsCompanion(')
          ..write('id: $id, ')
          ..write('beanId: $beanId, ')
          ..write('method: $method, ')
          ..write('methodLabel: $methodLabel, ')
          ..write('doseG: $doseG, ')
          ..write('waterG: $waterG, ')
          ..write('yieldG: $yieldG, ')
          ..write('grindSetting: $grindSetting, ')
          ..write('grinderGearId: $grinderGearId, ')
          ..write('tempF: $tempF, ')
          ..write('timeSec: $timeSec, ')
          ..write('brewedAt: $brewedAt, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $AppJournalPhotosTable extends AppJournalPhotos
    with TableInfo<$AppJournalPhotosTable, JournalPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, path, caption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
    );
  }

  @override
  $AppJournalPhotosTable createAlias(String alias) {
    return $AppJournalPhotosTable(attachedDatabase, alias);
  }
}

class AppJournalPhotosCompanion extends UpdateCompanion<JournalPhoto> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> path;
  final Value<String?> caption;
  const AppJournalPhotosCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.path = const Value.absent(),
    this.caption = const Value.absent(),
  });
  AppJournalPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String path,
    this.caption = const Value.absent(),
  }) : entryId = Value(entryId),
       path = Value(path);
  static Insertable<JournalPhoto> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? path,
    Expression<String>? caption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (path != null) 'path': path,
      if (caption != null) 'caption': caption,
    });
  }

  AppJournalPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? path,
    Value<String?>? caption,
  }) {
    return AppJournalPhotosCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      path: path ?? this.path,
      caption: caption ?? this.caption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalPhotosCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('path: $path, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }
}

class $AppJournalTagsTable extends AppJournalTags
    with TableInfo<$AppJournalTagsTable, JournalTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entryId, tag},
  ];
  @override
  JournalTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $AppJournalTagsTable createAlias(String alias) {
    return $AppJournalTagsTable(attachedDatabase, alias);
  }
}

class AppJournalTagsCompanion extends UpdateCompanion<JournalTag> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> tag;
  const AppJournalTagsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.tag = const Value.absent(),
  });
  AppJournalTagsCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String tag,
  }) : entryId = Value(entryId),
       tag = Value(tag);
  static Insertable<JournalTag> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? tag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (tag != null) 'tag': tag,
    });
  }

  AppJournalTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? tag,
  }) {
    return AppJournalTagsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      tag: tag ?? this.tag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalTagsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppJournalEntriesTable appJournalEntries =
      $AppJournalEntriesTable(this);
  late final $BeansTable beans = $BeansTable(this);
  late final $GearTable gear = $GearTable(this);
  late final $BrewsTable brews = $BrewsTable(this);
  late final $AppJournalPhotosTable appJournalPhotos = $AppJournalPhotosTable(
    this,
  );
  late final $AppJournalTagsTable appJournalTags = $AppJournalTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appJournalEntries,
    beans,
    gear,
    brews,
    appJournalPhotos,
    appJournalTags,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'beans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('brews', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'gear',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('brews', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$AppJournalEntriesTableCreateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });
typedef $$AppJournalEntriesTableUpdateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });

class $$AppJournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppJournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalEntriesTable,
          JournalEntry,
          $$AppJournalEntriesTableFilterComposer,
          $$AppJournalEntriesTableOrderingComposer,
          $$AppJournalEntriesTableAnnotationComposer,
          $$AppJournalEntriesTableCreateCompanionBuilder,
          $$AppJournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<
              _$AppDatabase,
              $AppJournalEntriesTable,
              JournalEntry
            >,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$AppJournalEntriesTableTableManager(
    _$AppDatabase db,
    $AppJournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion.insert(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalEntriesTable, JournalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalEntriesTable,
                    JournalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalEntriesTable,
      JournalEntry,
      $$AppJournalEntriesTableFilterComposer,
      $$AppJournalEntriesTableOrderingComposer,
      $$AppJournalEntriesTableAnnotationComposer,
      $$AppJournalEntriesTableCreateCompanionBuilder,
      $$AppJournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $AppJournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$BeansTableCreateCompanionBuilder =
    BeansCompanion Function({
      Value<int> id,
      required String roaster,
      required String name,
      Value<String?> origin,
      Value<String?> region,
      Value<RoastProcess?> process,
      Value<String?> processLabel,
      Value<RoastLevel?> roastLevel,
      Value<int?> priceBagCents,
      Value<int?> bagSizeG,
      Value<DateTime?> roastDate,
      Value<DateTime?> openedDate,
      Value<DateTime?> finishedDate,
      Value<DateTime> createdAt,
      Value<int?> journalEntryId,
    });
typedef $$BeansTableUpdateCompanionBuilder =
    BeansCompanion Function({
      Value<int> id,
      Value<String> roaster,
      Value<String> name,
      Value<String?> origin,
      Value<String?> region,
      Value<RoastProcess?> process,
      Value<String?> processLabel,
      Value<RoastLevel?> roastLevel,
      Value<int?> priceBagCents,
      Value<int?> bagSizeG,
      Value<DateTime?> roastDate,
      Value<DateTime?> openedDate,
      Value<DateTime?> finishedDate,
      Value<DateTime> createdAt,
      Value<int?> journalEntryId,
    });

final class $$BeansTableReferences
    extends BaseReferences<_$AppDatabase, $BeansTable, Bean> {
  $$BeansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BrewsTable, List<Brew>> _brewsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.brews,
    aliasName: 'beans__id__brews__bean_id',
  );

  $$BrewsTableProcessedTableManager get brewsRefs {
    final manager = $$BrewsTableTableManager(
      $_db,
      $_db.brews,
    ).filter((f) => f.beanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_brewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BeansTableFilterComposer extends Composer<_$AppDatabase, $BeansTable> {
  $$BeansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roaster => $composableBuilder(
    column: $table.roaster,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoastProcess?, RoastProcess, String>
  get process => $composableBuilder(
    column: $table.process,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get processLabel => $composableBuilder(
    column: $table.processLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoastLevel?, RoastLevel, String>
  get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priceBagCents => $composableBuilder(
    column: $table.priceBagCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bagSizeG => $composableBuilder(
    column: $table.bagSizeG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get roastDate => $composableBuilder(
    column: $table.roastDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedDate => $composableBuilder(
    column: $table.openedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedDate => $composableBuilder(
    column: $table.finishedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> brewsRefs(
    Expression<bool> Function($$BrewsTableFilterComposer f) f,
  ) {
    final $$BrewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brews,
      getReferencedColumn: (t) => t.beanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewsTableFilterComposer(
            $db: $db,
            $table: $db.brews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BeansTableOrderingComposer
    extends Composer<_$AppDatabase, $BeansTable> {
  $$BeansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roaster => $composableBuilder(
    column: $table.roaster,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get process => $composableBuilder(
    column: $table.process,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processLabel => $composableBuilder(
    column: $table.processLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceBagCents => $composableBuilder(
    column: $table.priceBagCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bagSizeG => $composableBuilder(
    column: $table.bagSizeG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get roastDate => $composableBuilder(
    column: $table.roastDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedDate => $composableBuilder(
    column: $table.openedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedDate => $composableBuilder(
    column: $table.finishedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BeansTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeansTable> {
  $$BeansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roaster =>
      $composableBuilder(column: $table.roaster, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoastProcess?, String> get process =>
      $composableBuilder(column: $table.process, builder: (column) => column);

  GeneratedColumn<String> get processLabel => $composableBuilder(
    column: $table.processLabel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RoastLevel?, String> get roastLevel =>
      $composableBuilder(
        column: $table.roastLevel,
        builder: (column) => column,
      );

  GeneratedColumn<int> get priceBagCents => $composableBuilder(
    column: $table.priceBagCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bagSizeG =>
      $composableBuilder(column: $table.bagSizeG, builder: (column) => column);

  GeneratedColumn<DateTime> get roastDate =>
      $composableBuilder(column: $table.roastDate, builder: (column) => column);

  GeneratedColumn<DateTime> get openedDate => $composableBuilder(
    column: $table.openedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finishedDate => $composableBuilder(
    column: $table.finishedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );

  Expression<T> brewsRefs<T extends Object>(
    Expression<T> Function($$BrewsTableAnnotationComposer a) f,
  ) {
    final $$BrewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brews,
      getReferencedColumn: (t) => t.beanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewsTableAnnotationComposer(
            $db: $db,
            $table: $db.brews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BeansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BeansTable,
          Bean,
          $$BeansTableFilterComposer,
          $$BeansTableOrderingComposer,
          $$BeansTableAnnotationComposer,
          $$BeansTableCreateCompanionBuilder,
          $$BeansTableUpdateCompanionBuilder,
          (Bean, $$BeansTableReferences),
          Bean,
          PrefetchHooks Function({bool brewsRefs})
        > {
  $$BeansTableTableManager(_$AppDatabase db, $BeansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> roaster = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<RoastProcess?> process = const Value.absent(),
                Value<String?> processLabel = const Value.absent(),
                Value<RoastLevel?> roastLevel = const Value.absent(),
                Value<int?> priceBagCents = const Value.absent(),
                Value<int?> bagSizeG = const Value.absent(),
                Value<DateTime?> roastDate = const Value.absent(),
                Value<DateTime?> openedDate = const Value.absent(),
                Value<DateTime?> finishedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => BeansCompanion(
                id: id,
                roaster: roaster,
                name: name,
                origin: origin,
                region: region,
                process: process,
                processLabel: processLabel,
                roastLevel: roastLevel,
                priceBagCents: priceBagCents,
                bagSizeG: bagSizeG,
                roastDate: roastDate,
                openedDate: openedDate,
                finishedDate: finishedDate,
                createdAt: createdAt,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String roaster,
                required String name,
                Value<String?> origin = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<RoastProcess?> process = const Value.absent(),
                Value<String?> processLabel = const Value.absent(),
                Value<RoastLevel?> roastLevel = const Value.absent(),
                Value<int?> priceBagCents = const Value.absent(),
                Value<int?> bagSizeG = const Value.absent(),
                Value<DateTime?> roastDate = const Value.absent(),
                Value<DateTime?> openedDate = const Value.absent(),
                Value<DateTime?> finishedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => BeansCompanion.insert(
                id: id,
                roaster: roaster,
                name: name,
                origin: origin,
                region: region,
                process: process,
                processLabel: processLabel,
                roastLevel: roastLevel,
                priceBagCents: priceBagCents,
                bagSizeG: bagSizeG,
                roastDate: roastDate,
                openedDate: openedDate,
                finishedDate: finishedDate,
                createdAt: createdAt,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BeansTable, Bean>(table),
                  $$BeansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({brewsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (brewsRefs) db.brews],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (brewsRefs)
                    await $_getPrefetchedData<Bean, $BeansTable, Brew>(
                      currentTable: table,
                      referencedTable: $$BeansTableReferences._brewsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$BeansTableReferences(db, table, p0).brewsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.beanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BeansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BeansTable,
      Bean,
      $$BeansTableFilterComposer,
      $$BeansTableOrderingComposer,
      $$BeansTableAnnotationComposer,
      $$BeansTableCreateCompanionBuilder,
      $$BeansTableUpdateCompanionBuilder,
      (Bean, $$BeansTableReferences),
      Bean,
      PrefetchHooks Function({bool brewsRefs})
    >;
typedef $$GearTableCreateCompanionBuilder =
    GearCompanion Function({
      Value<int> id,
      required GearKind kind,
      Value<String?> kindLabel,
      required String name,
      Value<String?> notes,
    });
typedef $$GearTableUpdateCompanionBuilder =
    GearCompanion Function({
      Value<int> id,
      Value<GearKind> kind,
      Value<String?> kindLabel,
      Value<String> name,
      Value<String?> notes,
    });

final class $$GearTableReferences
    extends BaseReferences<_$AppDatabase, $GearTable, GearData> {
  $$GearTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BrewsTable, List<Brew>> _brewsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.brews,
    aliasName: 'gear__id__brews__grinder_gear_id',
  );

  $$BrewsTableProcessedTableManager get brewsRefs {
    final manager = $$BrewsTableTableManager(
      $_db,
      $_db.brews,
    ).filter((f) => f.grinderGearId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_brewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GearTableFilterComposer extends Composer<_$AppDatabase, $GearTable> {
  $$GearTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GearKind, GearKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> brewsRefs(
    Expression<bool> Function($$BrewsTableFilterComposer f) f,
  ) {
    final $$BrewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brews,
      getReferencedColumn: (t) => t.grinderGearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewsTableFilterComposer(
            $db: $db,
            $table: $db.brews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GearTableOrderingComposer extends Composer<_$AppDatabase, $GearTable> {
  $$GearTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GearTableAnnotationComposer
    extends Composer<_$AppDatabase, $GearTable> {
  $$GearTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GearKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get kindLabel =>
      $composableBuilder(column: $table.kindLabel, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> brewsRefs<T extends Object>(
    Expression<T> Function($$BrewsTableAnnotationComposer a) f,
  ) {
    final $$BrewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brews,
      getReferencedColumn: (t) => t.grinderGearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrewsTableAnnotationComposer(
            $db: $db,
            $table: $db.brews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GearTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GearTable,
          GearData,
          $$GearTableFilterComposer,
          $$GearTableOrderingComposer,
          $$GearTableAnnotationComposer,
          $$GearTableCreateCompanionBuilder,
          $$GearTableUpdateCompanionBuilder,
          (GearData, $$GearTableReferences),
          GearData,
          PrefetchHooks Function({bool brewsRefs})
        > {
  $$GearTableTableManager(_$AppDatabase db, $GearTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GearTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GearTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GearTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<GearKind> kind = const Value.absent(),
                Value<String?> kindLabel = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => GearCompanion(
                id: id,
                kind: kind,
                kindLabel: kindLabel,
                name: name,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required GearKind kind,
                Value<String?> kindLabel = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
              }) => GearCompanion.insert(
                id: id,
                kind: kind,
                kindLabel: kindLabel,
                name: name,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GearTable, GearData>(table),
                  $$GearTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({brewsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (brewsRefs) db.brews],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (brewsRefs)
                    await $_getPrefetchedData<GearData, $GearTable, Brew>(
                      currentTable: table,
                      referencedTable: $$GearTableReferences._brewsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$GearTableReferences(db, table, p0).brewsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.grinderGearId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GearTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GearTable,
      GearData,
      $$GearTableFilterComposer,
      $$GearTableOrderingComposer,
      $$GearTableAnnotationComposer,
      $$GearTableCreateCompanionBuilder,
      $$GearTableUpdateCompanionBuilder,
      (GearData, $$GearTableReferences),
      GearData,
      PrefetchHooks Function({bool brewsRefs})
    >;
typedef $$BrewsTableCreateCompanionBuilder =
    BrewsCompanion Function({
      Value<int> id,
      required int beanId,
      required BrewMethod method,
      Value<String?> methodLabel,
      Value<double?> doseG,
      Value<double?> waterG,
      Value<double?> yieldG,
      Value<String?> grindSetting,
      Value<int?> grinderGearId,
      Value<int?> tempF,
      Value<int?> timeSec,
      Value<DateTime> brewedAt,
      Value<int?> journalEntryId,
    });
typedef $$BrewsTableUpdateCompanionBuilder =
    BrewsCompanion Function({
      Value<int> id,
      Value<int> beanId,
      Value<BrewMethod> method,
      Value<String?> methodLabel,
      Value<double?> doseG,
      Value<double?> waterG,
      Value<double?> yieldG,
      Value<String?> grindSetting,
      Value<int?> grinderGearId,
      Value<int?> tempF,
      Value<int?> timeSec,
      Value<DateTime> brewedAt,
      Value<int?> journalEntryId,
    });

final class $$BrewsTableReferences
    extends BaseReferences<_$AppDatabase, $BrewsTable, Brew> {
  $$BrewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BeansTable _beanIdTable(_$AppDatabase db) =>
      db.beans.createAlias('brews__bean_id__beans__id');

  $$BeansTableProcessedTableManager get beanId {
    final $_column = $_itemColumn<int>('bean_id')!;

    final manager = $$BeansTableTableManager(
      $_db,
      $_db.beans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_beanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GearTable _grinderGearIdTable(_$AppDatabase db) =>
      db.gear.createAlias('brews__grinder_gear_id__gear__id');

  $$GearTableProcessedTableManager? get grinderGearId {
    final $_column = $_itemColumn<int>('grinder_gear_id');
    if ($_column == null) return null;
    final manager = $$GearTableTableManager(
      $_db,
      $_db.gear,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_grinderGearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BrewsTableFilterComposer extends Composer<_$AppDatabase, $BrewsTable> {
  $$BrewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BrewMethod, BrewMethod, String> get method =>
      $composableBuilder(
        column: $table.method,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get methodLabel => $composableBuilder(
    column: $table.methodLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get doseG => $composableBuilder(
    column: $table.doseG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterG => $composableBuilder(
    column: $table.waterG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yieldG => $composableBuilder(
    column: $table.yieldG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grindSetting => $composableBuilder(
    column: $table.grindSetting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempF => $composableBuilder(
    column: $table.tempF,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSec => $composableBuilder(
    column: $table.timeSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get brewedAt => $composableBuilder(
    column: $table.brewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );

  $$BeansTableFilterComposer get beanId {
    final $$BeansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beanId,
      referencedTable: $db.beans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeansTableFilterComposer(
            $db: $db,
            $table: $db.beans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GearTableFilterComposer get grinderGearId {
    final $$GearTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.grinderGearId,
      referencedTable: $db.gear,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GearTableFilterComposer(
            $db: $db,
            $table: $db.gear,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrewsTable> {
  $$BrewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get methodLabel => $composableBuilder(
    column: $table.methodLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseG => $composableBuilder(
    column: $table.doseG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterG => $composableBuilder(
    column: $table.waterG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yieldG => $composableBuilder(
    column: $table.yieldG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grindSetting => $composableBuilder(
    column: $table.grindSetting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempF => $composableBuilder(
    column: $table.tempF,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSec => $composableBuilder(
    column: $table.timeSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get brewedAt => $composableBuilder(
    column: $table.brewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );

  $$BeansTableOrderingComposer get beanId {
    final $$BeansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beanId,
      referencedTable: $db.beans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeansTableOrderingComposer(
            $db: $db,
            $table: $db.beans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GearTableOrderingComposer get grinderGearId {
    final $$GearTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.grinderGearId,
      referencedTable: $db.gear,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GearTableOrderingComposer(
            $db: $db,
            $table: $db.gear,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrewsTable> {
  $$BrewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BrewMethod, String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get methodLabel => $composableBuilder(
    column: $table.methodLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get doseG =>
      $composableBuilder(column: $table.doseG, builder: (column) => column);

  GeneratedColumn<double> get waterG =>
      $composableBuilder(column: $table.waterG, builder: (column) => column);

  GeneratedColumn<double> get yieldG =>
      $composableBuilder(column: $table.yieldG, builder: (column) => column);

  GeneratedColumn<String> get grindSetting => $composableBuilder(
    column: $table.grindSetting,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempF =>
      $composableBuilder(column: $table.tempF, builder: (column) => column);

  GeneratedColumn<int> get timeSec =>
      $composableBuilder(column: $table.timeSec, builder: (column) => column);

  GeneratedColumn<DateTime> get brewedAt =>
      $composableBuilder(column: $table.brewedAt, builder: (column) => column);

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );

  $$BeansTableAnnotationComposer get beanId {
    final $$BeansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beanId,
      referencedTable: $db.beans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BeansTableAnnotationComposer(
            $db: $db,
            $table: $db.beans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GearTableAnnotationComposer get grinderGearId {
    final $$GearTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.grinderGearId,
      referencedTable: $db.gear,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GearTableAnnotationComposer(
            $db: $db,
            $table: $db.gear,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrewsTable,
          Brew,
          $$BrewsTableFilterComposer,
          $$BrewsTableOrderingComposer,
          $$BrewsTableAnnotationComposer,
          $$BrewsTableCreateCompanionBuilder,
          $$BrewsTableUpdateCompanionBuilder,
          (Brew, $$BrewsTableReferences),
          Brew,
          PrefetchHooks Function({bool beanId, bool grinderGearId})
        > {
  $$BrewsTableTableManager(_$AppDatabase db, $BrewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> beanId = const Value.absent(),
                Value<BrewMethod> method = const Value.absent(),
                Value<String?> methodLabel = const Value.absent(),
                Value<double?> doseG = const Value.absent(),
                Value<double?> waterG = const Value.absent(),
                Value<double?> yieldG = const Value.absent(),
                Value<String?> grindSetting = const Value.absent(),
                Value<int?> grinderGearId = const Value.absent(),
                Value<int?> tempF = const Value.absent(),
                Value<int?> timeSec = const Value.absent(),
                Value<DateTime> brewedAt = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => BrewsCompanion(
                id: id,
                beanId: beanId,
                method: method,
                methodLabel: methodLabel,
                doseG: doseG,
                waterG: waterG,
                yieldG: yieldG,
                grindSetting: grindSetting,
                grinderGearId: grinderGearId,
                tempF: tempF,
                timeSec: timeSec,
                brewedAt: brewedAt,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int beanId,
                required BrewMethod method,
                Value<String?> methodLabel = const Value.absent(),
                Value<double?> doseG = const Value.absent(),
                Value<double?> waterG = const Value.absent(),
                Value<double?> yieldG = const Value.absent(),
                Value<String?> grindSetting = const Value.absent(),
                Value<int?> grinderGearId = const Value.absent(),
                Value<int?> tempF = const Value.absent(),
                Value<int?> timeSec = const Value.absent(),
                Value<DateTime> brewedAt = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => BrewsCompanion.insert(
                id: id,
                beanId: beanId,
                method: method,
                methodLabel: methodLabel,
                doseG: doseG,
                waterG: waterG,
                yieldG: yieldG,
                grindSetting: grindSetting,
                grinderGearId: grinderGearId,
                tempF: tempF,
                timeSec: timeSec,
                brewedAt: brewedAt,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BrewsTable, Brew>(table),
                  $$BrewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({beanId = false, grinderGearId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (beanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.beanId,
                                referencedTable: $$BrewsTableReferences
                                    ._beanIdTable(db),
                                referencedColumn: $$BrewsTableReferences
                                    ._beanIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (grinderGearId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.grinderGearId,
                                referencedTable: $$BrewsTableReferences
                                    ._grinderGearIdTable(db),
                                referencedColumn: $$BrewsTableReferences
                                    ._grinderGearIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BrewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrewsTable,
      Brew,
      $$BrewsTableFilterComposer,
      $$BrewsTableOrderingComposer,
      $$BrewsTableAnnotationComposer,
      $$BrewsTableCreateCompanionBuilder,
      $$BrewsTableUpdateCompanionBuilder,
      (Brew, $$BrewsTableReferences),
      Brew,
      PrefetchHooks Function({bool beanId, bool grinderGearId})
    >;
typedef $$AppJournalPhotosTableCreateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      required int entryId,
      required String path,
      Value<String?> caption,
    });
typedef $$AppJournalPhotosTableUpdateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> path,
      Value<String?> caption,
    });

class $$AppJournalPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);
}

class $$AppJournalPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalPhotosTable,
          JournalPhoto,
          $$AppJournalPhotosTableFilterComposer,
          $$AppJournalPhotosTableOrderingComposer,
          $$AppJournalPhotosTableAnnotationComposer,
          $$AppJournalPhotosTableCreateCompanionBuilder,
          $$AppJournalPhotosTableUpdateCompanionBuilder,
          (
            JournalPhoto,
            BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
          ),
          JournalPhoto,
          PrefetchHooks Function()
        > {
  $$AppJournalPhotosTableTableManager(
    _$AppDatabase db,
    $AppJournalPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String path,
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion.insert(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalPhotosTable, JournalPhoto>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalPhotosTable,
                    JournalPhoto
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalPhotosTable,
      JournalPhoto,
      $$AppJournalPhotosTableFilterComposer,
      $$AppJournalPhotosTableOrderingComposer,
      $$AppJournalPhotosTableAnnotationComposer,
      $$AppJournalPhotosTableCreateCompanionBuilder,
      $$AppJournalPhotosTableUpdateCompanionBuilder,
      (
        JournalPhoto,
        BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
      ),
      JournalPhoto,
      PrefetchHooks Function()
    >;
typedef $$AppJournalTagsTableCreateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      required int entryId,
      required String tag,
    });
typedef $$AppJournalTagsTableUpdateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> tag,
    });

class $$AppJournalTagsTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$AppJournalTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalTagsTable,
          JournalTag,
          $$AppJournalTagsTableFilterComposer,
          $$AppJournalTagsTableOrderingComposer,
          $$AppJournalTagsTableAnnotationComposer,
          $$AppJournalTagsTableCreateCompanionBuilder,
          $$AppJournalTagsTableUpdateCompanionBuilder,
          (
            JournalTag,
            BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
          ),
          JournalTag,
          PrefetchHooks Function()
        > {
  $$AppJournalTagsTableTableManager(
    _$AppDatabase db,
    $AppJournalTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> tag = const Value.absent(),
              }) => AppJournalTagsCompanion(id: id, entryId: entryId, tag: tag),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String tag,
              }) => AppJournalTagsCompanion.insert(
                id: id,
                entryId: entryId,
                tag: tag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalTagsTable, JournalTag>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalTagsTable,
                    JournalTag
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalTagsTable,
      JournalTag,
      $$AppJournalTagsTableFilterComposer,
      $$AppJournalTagsTableOrderingComposer,
      $$AppJournalTagsTableAnnotationComposer,
      $$AppJournalTagsTableCreateCompanionBuilder,
      $$AppJournalTagsTableUpdateCompanionBuilder,
      (
        JournalTag,
        BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
      ),
      JournalTag,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppJournalEntriesTableTableManager get appJournalEntries =>
      $$AppJournalEntriesTableTableManager(_db, _db.appJournalEntries);
  $$BeansTableTableManager get beans =>
      $$BeansTableTableManager(_db, _db.beans);
  $$GearTableTableManager get gear => $$GearTableTableManager(_db, _db.gear);
  $$BrewsTableTableManager get brews =>
      $$BrewsTableTableManager(_db, _db.brews);
  $$AppJournalPhotosTableTableManager get appJournalPhotos =>
      $$AppJournalPhotosTableTableManager(_db, _db.appJournalPhotos);
  $$AppJournalTagsTableTableManager get appJournalTags =>
      $$AppJournalTagsTableTableManager(_db, _db.appJournalTags);
}
