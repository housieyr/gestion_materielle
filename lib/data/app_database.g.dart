// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EquipmentTable extends Equipment
    with TableInfo<$EquipmentTable, EquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _assetCodeMeta = const VerificationMeta(
    'assetCode',
  );
  @override
  late final GeneratedColumn<String> assetCode = GeneratedColumn<String>(
    'asset_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<String> serial = GeneratedColumn<String>(
    'serial',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _officeMeta = const VerificationMeta('office');
  @override
  late final GeneratedColumn<String> office = GeneratedColumn<String>(
    'office',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<EquipmentStatus>($EquipmentTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [
    id,
    assetCode,
    type,
    model,
    serial,
    department,
    office,
    status,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('asset_code')) {
      context.handle(
        _assetCodeMeta,
        assetCode.isAcceptableOrUnknown(data['asset_code']!, _assetCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_assetCodeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    } else if (isInserting) {
      context.missing(_serialMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('office')) {
      context.handle(
        _officeMeta,
        office.isAcceptableOrUnknown(data['office']!, _officeMeta),
      );
    } else if (isInserting) {
      context.missing(_officeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {assetCode},
  ];
  @override
  EquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      assetCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_code'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      office: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}office'],
      )!,
      status: $EquipmentTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EquipmentTable createAlias(String alias) {
    return $EquipmentTable(attachedDatabase, alias);
  }

  static TypeConverter<EquipmentStatus, int> $converterstatus =
      const EquipmentStatusConverter();
}

class EquipmentData extends DataClass implements Insertable<EquipmentData> {
  final int id;
  final String assetCode;
  final String type;
  final String model;
  final String serial;
  final String department;
  final String office;
  final EquipmentStatus status;
  final String? notes;
  final DateTime createdAt;
  const EquipmentData({
    required this.id,
    required this.assetCode,
    required this.type,
    required this.model,
    required this.serial,
    required this.department,
    required this.office,
    required this.status,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['asset_code'] = Variable<String>(assetCode);
    map['type'] = Variable<String>(type);
    map['model'] = Variable<String>(model);
    map['serial'] = Variable<String>(serial);
    map['department'] = Variable<String>(department);
    map['office'] = Variable<String>(office);
    {
      map['status'] = Variable<int>(
        $EquipmentTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EquipmentCompanion toCompanion(bool nullToAbsent) {
    return EquipmentCompanion(
      id: Value(id),
      assetCode: Value(assetCode),
      type: Value(type),
      model: Value(model),
      serial: Value(serial),
      department: Value(department),
      office: Value(office),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory EquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentData(
      id: serializer.fromJson<int>(json['id']),
      assetCode: serializer.fromJson<String>(json['assetCode']),
      type: serializer.fromJson<String>(json['type']),
      model: serializer.fromJson<String>(json['model']),
      serial: serializer.fromJson<String>(json['serial']),
      department: serializer.fromJson<String>(json['department']),
      office: serializer.fromJson<String>(json['office']),
      status: serializer.fromJson<EquipmentStatus>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'assetCode': serializer.toJson<String>(assetCode),
      'type': serializer.toJson<String>(type),
      'model': serializer.toJson<String>(model),
      'serial': serializer.toJson<String>(serial),
      'department': serializer.toJson<String>(department),
      'office': serializer.toJson<String>(office),
      'status': serializer.toJson<EquipmentStatus>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EquipmentData copyWith({
    int? id,
    String? assetCode,
    String? type,
    String? model,
    String? serial,
    String? department,
    String? office,
    EquipmentStatus? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => EquipmentData(
    id: id ?? this.id,
    assetCode: assetCode ?? this.assetCode,
    type: type ?? this.type,
    model: model ?? this.model,
    serial: serial ?? this.serial,
    department: department ?? this.department,
    office: office ?? this.office,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  EquipmentData copyWithCompanion(EquipmentCompanion data) {
    return EquipmentData(
      id: data.id.present ? data.id.value : this.id,
      assetCode: data.assetCode.present ? data.assetCode.value : this.assetCode,
      type: data.type.present ? data.type.value : this.type,
      model: data.model.present ? data.model.value : this.model,
      serial: data.serial.present ? data.serial.value : this.serial,
      department: data.department.present
          ? data.department.value
          : this.department,
      office: data.office.present ? data.office.value : this.office,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentData(')
          ..write('id: $id, ')
          ..write('assetCode: $assetCode, ')
          ..write('type: $type, ')
          ..write('model: $model, ')
          ..write('serial: $serial, ')
          ..write('department: $department, ')
          ..write('office: $office, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    assetCode,
    type,
    model,
    serial,
    department,
    office,
    status,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentData &&
          other.id == this.id &&
          other.assetCode == this.assetCode &&
          other.type == this.type &&
          other.model == this.model &&
          other.serial == this.serial &&
          other.department == this.department &&
          other.office == this.office &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class EquipmentCompanion extends UpdateCompanion<EquipmentData> {
  final Value<int> id;
  final Value<String> assetCode;
  final Value<String> type;
  final Value<String> model;
  final Value<String> serial;
  final Value<String> department;
  final Value<String> office;
  final Value<EquipmentStatus> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const EquipmentCompanion({
    this.id = const Value.absent(),
    this.assetCode = const Value.absent(),
    this.type = const Value.absent(),
    this.model = const Value.absent(),
    this.serial = const Value.absent(),
    this.department = const Value.absent(),
    this.office = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EquipmentCompanion.insert({
    this.id = const Value.absent(),
    required String assetCode,
    required String type,
    required String model,
    required String serial,
    required String department,
    required String office,
    required EquipmentStatus status,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : assetCode = Value(assetCode),
       type = Value(type),
       model = Value(model),
       serial = Value(serial),
       department = Value(department),
       office = Value(office),
       status = Value(status);
  static Insertable<EquipmentData> custom({
    Expression<int>? id,
    Expression<String>? assetCode,
    Expression<String>? type,
    Expression<String>? model,
    Expression<String>? serial,
    Expression<String>? department,
    Expression<String>? office,
    Expression<int>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetCode != null) 'asset_code': assetCode,
      if (type != null) 'type': type,
      if (model != null) 'model': model,
      if (serial != null) 'serial': serial,
      if (department != null) 'department': department,
      if (office != null) 'office': office,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EquipmentCompanion copyWith({
    Value<int>? id,
    Value<String>? assetCode,
    Value<String>? type,
    Value<String>? model,
    Value<String>? serial,
    Value<String>? department,
    Value<String>? office,
    Value<EquipmentStatus>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return EquipmentCompanion(
      id: id ?? this.id,
      assetCode: assetCode ?? this.assetCode,
      type: type ?? this.type,
      model: model ?? this.model,
      serial: serial ?? this.serial,
      department: department ?? this.department,
      office: office ?? this.office,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assetCode.present) {
      map['asset_code'] = Variable<String>(assetCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serial.present) {
      map['serial'] = Variable<String>(serial.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (office.present) {
      map['office'] = Variable<String>(office.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $EquipmentTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentCompanion(')
          ..write('id: $id, ')
          ..write('assetCode: $assetCode, ')
          ..write('type: $type, ')
          ..write('model: $model, ')
          ..write('serial: $serial, ')
          ..write('department: $department, ')
          ..write('office: $office, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EquipmentHistoryTable extends EquipmentHistory
    with TableInfo<$EquipmentHistoryTable, EquipmentHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment (id)',
    ),
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentStatus?, int> oldStatus =
      GeneratedColumn<int>(
        'old_status',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<EquipmentStatus?>(
        $EquipmentHistoryTable.$converteroldStatusn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentStatus?, int> newStatus =
      GeneratedColumn<int>(
        'new_status',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<EquipmentStatus?>(
        $EquipmentHistoryTable.$converternewStatusn,
      );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeTypeMeta = const VerificationMeta(
    'changeType',
  );
  @override
  late final GeneratedColumn<String> changeType = GeneratedColumn<String>(
    'change_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('StatusChange'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    equipmentId,
    changedAt,
    oldStatus,
    newStatus,
    comment,
    changeType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('change_type')) {
      context.handle(
        _changeTypeMeta,
        changeType.isAcceptableOrUnknown(data['change_type']!, _changeTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_id'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      oldStatus: $EquipmentHistoryTable.$converteroldStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}old_status'],
        ),
      ),
      newStatus: $EquipmentHistoryTable.$converternewStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}new_status'],
        ),
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      changeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_type'],
      )!,
    );
  }

  @override
  $EquipmentHistoryTable createAlias(String alias) {
    return $EquipmentHistoryTable(attachedDatabase, alias);
  }

  static TypeConverter<EquipmentStatus, int> $converteroldStatus =
      const EquipmentStatusConverter();
  static TypeConverter<EquipmentStatus?, int?> $converteroldStatusn =
      NullAwareTypeConverter.wrap($converteroldStatus);
  static TypeConverter<EquipmentStatus, int> $converternewStatus =
      const EquipmentStatusConverter();
  static TypeConverter<EquipmentStatus?, int?> $converternewStatusn =
      NullAwareTypeConverter.wrap($converternewStatus);
}

class EquipmentHistoryData extends DataClass
    implements Insertable<EquipmentHistoryData> {
  final int id;
  final int equipmentId;
  final DateTime changedAt;
  final EquipmentStatus? oldStatus;
  final EquipmentStatus? newStatus;
  final String? comment;
  final String changeType;
  const EquipmentHistoryData({
    required this.id,
    required this.equipmentId,
    required this.changedAt,
    this.oldStatus,
    this.newStatus,
    this.comment,
    required this.changeType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['equipment_id'] = Variable<int>(equipmentId);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || oldStatus != null) {
      map['old_status'] = Variable<int>(
        $EquipmentHistoryTable.$converteroldStatusn.toSql(oldStatus),
      );
    }
    if (!nullToAbsent || newStatus != null) {
      map['new_status'] = Variable<int>(
        $EquipmentHistoryTable.$converternewStatusn.toSql(newStatus),
      );
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['change_type'] = Variable<String>(changeType);
    return map;
  }

  EquipmentHistoryCompanion toCompanion(bool nullToAbsent) {
    return EquipmentHistoryCompanion(
      id: Value(id),
      equipmentId: Value(equipmentId),
      changedAt: Value(changedAt),
      oldStatus: oldStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(oldStatus),
      newStatus: newStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(newStatus),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      changeType: Value(changeType),
    );
  }

  factory EquipmentHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentHistoryData(
      id: serializer.fromJson<int>(json['id']),
      equipmentId: serializer.fromJson<int>(json['equipmentId']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      oldStatus: serializer.fromJson<EquipmentStatus?>(json['oldStatus']),
      newStatus: serializer.fromJson<EquipmentStatus?>(json['newStatus']),
      comment: serializer.fromJson<String?>(json['comment']),
      changeType: serializer.fromJson<String>(json['changeType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'equipmentId': serializer.toJson<int>(equipmentId),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'oldStatus': serializer.toJson<EquipmentStatus?>(oldStatus),
      'newStatus': serializer.toJson<EquipmentStatus?>(newStatus),
      'comment': serializer.toJson<String?>(comment),
      'changeType': serializer.toJson<String>(changeType),
    };
  }

  EquipmentHistoryData copyWith({
    int? id,
    int? equipmentId,
    DateTime? changedAt,
    Value<EquipmentStatus?> oldStatus = const Value.absent(),
    Value<EquipmentStatus?> newStatus = const Value.absent(),
    Value<String?> comment = const Value.absent(),
    String? changeType,
  }) => EquipmentHistoryData(
    id: id ?? this.id,
    equipmentId: equipmentId ?? this.equipmentId,
    changedAt: changedAt ?? this.changedAt,
    oldStatus: oldStatus.present ? oldStatus.value : this.oldStatus,
    newStatus: newStatus.present ? newStatus.value : this.newStatus,
    comment: comment.present ? comment.value : this.comment,
    changeType: changeType ?? this.changeType,
  );
  EquipmentHistoryData copyWithCompanion(EquipmentHistoryCompanion data) {
    return EquipmentHistoryData(
      id: data.id.present ? data.id.value : this.id,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      oldStatus: data.oldStatus.present ? data.oldStatus.value : this.oldStatus,
      newStatus: data.newStatus.present ? data.newStatus.value : this.newStatus,
      comment: data.comment.present ? data.comment.value : this.comment,
      changeType: data.changeType.present
          ? data.changeType.value
          : this.changeType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentHistoryData(')
          ..write('id: $id, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('changedAt: $changedAt, ')
          ..write('oldStatus: $oldStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('comment: $comment, ')
          ..write('changeType: $changeType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    equipmentId,
    changedAt,
    oldStatus,
    newStatus,
    comment,
    changeType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentHistoryData &&
          other.id == this.id &&
          other.equipmentId == this.equipmentId &&
          other.changedAt == this.changedAt &&
          other.oldStatus == this.oldStatus &&
          other.newStatus == this.newStatus &&
          other.comment == this.comment &&
          other.changeType == this.changeType);
}

class EquipmentHistoryCompanion extends UpdateCompanion<EquipmentHistoryData> {
  final Value<int> id;
  final Value<int> equipmentId;
  final Value<DateTime> changedAt;
  final Value<EquipmentStatus?> oldStatus;
  final Value<EquipmentStatus?> newStatus;
  final Value<String?> comment;
  final Value<String> changeType;
  const EquipmentHistoryCompanion({
    this.id = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.oldStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.comment = const Value.absent(),
    this.changeType = const Value.absent(),
  });
  EquipmentHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int equipmentId,
    this.changedAt = const Value.absent(),
    this.oldStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.comment = const Value.absent(),
    this.changeType = const Value.absent(),
  }) : equipmentId = Value(equipmentId);
  static Insertable<EquipmentHistoryData> custom({
    Expression<int>? id,
    Expression<int>? equipmentId,
    Expression<DateTime>? changedAt,
    Expression<int>? oldStatus,
    Expression<int>? newStatus,
    Expression<String>? comment,
    Expression<String>? changeType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (changedAt != null) 'changed_at': changedAt,
      if (oldStatus != null) 'old_status': oldStatus,
      if (newStatus != null) 'new_status': newStatus,
      if (comment != null) 'comment': comment,
      if (changeType != null) 'change_type': changeType,
    });
  }

  EquipmentHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? equipmentId,
    Value<DateTime>? changedAt,
    Value<EquipmentStatus?>? oldStatus,
    Value<EquipmentStatus?>? newStatus,
    Value<String?>? comment,
    Value<String>? changeType,
  }) {
    return EquipmentHistoryCompanion(
      id: id ?? this.id,
      equipmentId: equipmentId ?? this.equipmentId,
      changedAt: changedAt ?? this.changedAt,
      oldStatus: oldStatus ?? this.oldStatus,
      newStatus: newStatus ?? this.newStatus,
      comment: comment ?? this.comment,
      changeType: changeType ?? this.changeType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (oldStatus.present) {
      map['old_status'] = Variable<int>(
        $EquipmentHistoryTable.$converteroldStatusn.toSql(oldStatus.value),
      );
    }
    if (newStatus.present) {
      map['new_status'] = Variable<int>(
        $EquipmentHistoryTable.$converternewStatusn.toSql(newStatus.value),
      );
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (changeType.present) {
      map['change_type'] = Variable<String>(changeType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentHistoryCompanion(')
          ..write('id: $id, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('changedAt: $changedAt, ')
          ..write('oldStatus: $oldStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('comment: $comment, ')
          ..write('changeType: $changeType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EquipmentTable equipment = $EquipmentTable(this);
  late final $EquipmentHistoryTable equipmentHistory = $EquipmentHistoryTable(
    this,
  );
  late final EquipmentDao equipmentDao = EquipmentDao(this as AppDatabase);
  late final ReportsDao reportsDao = ReportsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    equipment,
    equipmentHistory,
  ];
}

typedef $$EquipmentTableCreateCompanionBuilder =
    EquipmentCompanion Function({
      Value<int> id,
      required String assetCode,
      required String type,
      required String model,
      required String serial,
      required String department,
      required String office,
      required EquipmentStatus status,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$EquipmentTableUpdateCompanionBuilder =
    EquipmentCompanion Function({
      Value<int> id,
      Value<String> assetCode,
      Value<String> type,
      Value<String> model,
      Value<String> serial,
      Value<String> department,
      Value<String> office,
      Value<EquipmentStatus> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$EquipmentTableReferences
    extends BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData> {
  $$EquipmentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EquipmentHistoryTable, List<EquipmentHistoryData>>
  _equipmentHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.equipmentHistory,
    aliasName: $_aliasNameGenerator(
      db.equipment.id,
      db.equipmentHistory.equipmentId,
    ),
  );

  $$EquipmentHistoryTableProcessedTableManager get equipmentHistoryRefs {
    final manager = $$EquipmentHistoryTableTableManager(
      $_db,
      $_db.equipmentHistory,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _equipmentHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableFilterComposer({
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

  ColumnFilters<String> get assetCode => $composableBuilder(
    column: $table.assetCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get office => $composableBuilder(
    column: $table.office,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentStatus, EquipmentStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> equipmentHistoryRefs(
    Expression<bool> Function($$EquipmentHistoryTableFilterComposer f) f,
  ) {
    final $$EquipmentHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipmentHistory,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentHistoryTableFilterComposer(
            $db: $db,
            $table: $db.equipmentHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableOrderingComposer({
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

  ColumnOrderings<String> get assetCode => $composableBuilder(
    column: $table.assetCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get office => $composableBuilder(
    column: $table.office,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetCode =>
      $composableBuilder(column: $table.assetCode, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get office =>
      $composableBuilder(column: $table.office, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> equipmentHistoryRefs<T extends Object>(
    Expression<T> Function($$EquipmentHistoryTableAnnotationComposer a) f,
  ) {
    final $$EquipmentHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipmentHistory,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.equipmentHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentTable,
          EquipmentData,
          $$EquipmentTableFilterComposer,
          $$EquipmentTableOrderingComposer,
          $$EquipmentTableAnnotationComposer,
          $$EquipmentTableCreateCompanionBuilder,
          $$EquipmentTableUpdateCompanionBuilder,
          (EquipmentData, $$EquipmentTableReferences),
          EquipmentData,
          PrefetchHooks Function({bool equipmentHistoryRefs})
        > {
  $$EquipmentTableTableManager(_$AppDatabase db, $EquipmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> assetCode = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> serial = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String> office = const Value.absent(),
                Value<EquipmentStatus> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EquipmentCompanion(
                id: id,
                assetCode: assetCode,
                type: type,
                model: model,
                serial: serial,
                department: department,
                office: office,
                status: status,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String assetCode,
                required String type,
                required String model,
                required String serial,
                required String department,
                required String office,
                required EquipmentStatus status,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EquipmentCompanion.insert(
                id: id,
                assetCode: assetCode,
                type: type,
                model: model,
                serial: serial,
                department: department,
                office: office,
                status: status,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({equipmentHistoryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (equipmentHistoryRefs) db.equipmentHistory,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (equipmentHistoryRefs)
                    await $_getPrefetchedData<
                      EquipmentData,
                      $EquipmentTable,
                      EquipmentHistoryData
                    >(
                      currentTable: table,
                      referencedTable: $$EquipmentTableReferences
                          ._equipmentHistoryRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EquipmentTableReferences(
                            db,
                            table,
                            p0,
                          ).equipmentHistoryRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.equipmentId == item.id,
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

typedef $$EquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentTable,
      EquipmentData,
      $$EquipmentTableFilterComposer,
      $$EquipmentTableOrderingComposer,
      $$EquipmentTableAnnotationComposer,
      $$EquipmentTableCreateCompanionBuilder,
      $$EquipmentTableUpdateCompanionBuilder,
      (EquipmentData, $$EquipmentTableReferences),
      EquipmentData,
      PrefetchHooks Function({bool equipmentHistoryRefs})
    >;
typedef $$EquipmentHistoryTableCreateCompanionBuilder =
    EquipmentHistoryCompanion Function({
      Value<int> id,
      required int equipmentId,
      Value<DateTime> changedAt,
      Value<EquipmentStatus?> oldStatus,
      Value<EquipmentStatus?> newStatus,
      Value<String?> comment,
      Value<String> changeType,
    });
typedef $$EquipmentHistoryTableUpdateCompanionBuilder =
    EquipmentHistoryCompanion Function({
      Value<int> id,
      Value<int> equipmentId,
      Value<DateTime> changedAt,
      Value<EquipmentStatus?> oldStatus,
      Value<EquipmentStatus?> newStatus,
      Value<String?> comment,
      Value<String> changeType,
    });

final class $$EquipmentHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EquipmentHistoryTable,
          EquipmentHistoryData
        > {
  $$EquipmentHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EquipmentTable _equipmentIdTable(_$AppDatabase db) =>
      db.equipment.createAlias(
        $_aliasNameGenerator(db.equipmentHistory.equipmentId, db.equipment.id),
      );

  $$EquipmentTableProcessedTableManager get equipmentId {
    final $_column = $_itemColumn<int>('equipment_id')!;

    final manager = $$EquipmentTableTableManager(
      $_db,
      $_db.equipment,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EquipmentHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentHistoryTable> {
  $$EquipmentHistoryTableFilterComposer({
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

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentStatus?, EquipmentStatus, int>
  get oldStatus => $composableBuilder(
    column: $table.oldStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentStatus?, EquipmentStatus, int>
  get newStatus => $composableBuilder(
    column: $table.newStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => ColumnFilters(column),
  );

  $$EquipmentTableFilterComposer get equipmentId {
    final $$EquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableFilterComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquipmentHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentHistoryTable> {
  $$EquipmentHistoryTableOrderingComposer({
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

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get oldStatus => $composableBuilder(
    column: $table.oldStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newStatus => $composableBuilder(
    column: $table.newStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => ColumnOrderings(column),
  );

  $$EquipmentTableOrderingComposer get equipmentId {
    final $$EquipmentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableOrderingComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquipmentHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentHistoryTable> {
  $$EquipmentHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentStatus?, int> get oldStatus =>
      $composableBuilder(column: $table.oldStatus, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentStatus?, int> get newStatus =>
      $composableBuilder(column: $table.newStatus, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => column,
  );

  $$EquipmentTableAnnotationComposer get equipmentId {
    final $$EquipmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableAnnotationComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquipmentHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentHistoryTable,
          EquipmentHistoryData,
          $$EquipmentHistoryTableFilterComposer,
          $$EquipmentHistoryTableOrderingComposer,
          $$EquipmentHistoryTableAnnotationComposer,
          $$EquipmentHistoryTableCreateCompanionBuilder,
          $$EquipmentHistoryTableUpdateCompanionBuilder,
          (EquipmentHistoryData, $$EquipmentHistoryTableReferences),
          EquipmentHistoryData,
          PrefetchHooks Function({bool equipmentId})
        > {
  $$EquipmentHistoryTableTableManager(
    _$AppDatabase db,
    $EquipmentHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> equipmentId = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<EquipmentStatus?> oldStatus = const Value.absent(),
                Value<EquipmentStatus?> newStatus = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<String> changeType = const Value.absent(),
              }) => EquipmentHistoryCompanion(
                id: id,
                equipmentId: equipmentId,
                changedAt: changedAt,
                oldStatus: oldStatus,
                newStatus: newStatus,
                comment: comment,
                changeType: changeType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int equipmentId,
                Value<DateTime> changedAt = const Value.absent(),
                Value<EquipmentStatus?> oldStatus = const Value.absent(),
                Value<EquipmentStatus?> newStatus = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<String> changeType = const Value.absent(),
              }) => EquipmentHistoryCompanion.insert(
                id: id,
                equipmentId: equipmentId,
                changedAt: changedAt,
                oldStatus: oldStatus,
                newStatus: newStatus,
                comment: comment,
                changeType: changeType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquipmentHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({equipmentId = false}) {
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
                    if (equipmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.equipmentId,
                                referencedTable:
                                    $$EquipmentHistoryTableReferences
                                        ._equipmentIdTable(db),
                                referencedColumn:
                                    $$EquipmentHistoryTableReferences
                                        ._equipmentIdTable(db)
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

typedef $$EquipmentHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentHistoryTable,
      EquipmentHistoryData,
      $$EquipmentHistoryTableFilterComposer,
      $$EquipmentHistoryTableOrderingComposer,
      $$EquipmentHistoryTableAnnotationComposer,
      $$EquipmentHistoryTableCreateCompanionBuilder,
      $$EquipmentHistoryTableUpdateCompanionBuilder,
      (EquipmentHistoryData, $$EquipmentHistoryTableReferences),
      EquipmentHistoryData,
      PrefetchHooks Function({bool equipmentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db, _db.equipment);
  $$EquipmentHistoryTableTableManager get equipmentHistory =>
      $$EquipmentHistoryTableTableManager(_db, _db.equipmentHistory);
}
