import 'package:drift/drift.dart';

enum EquipmentStatus {
  working,         // ✅ تعمل
  needsMaintenance,// ⚠️ تحتاج صيانة
  inRepair,        // 🛠️ في التصليح
  outOfService,    // ❌ خارج الخدمة
}

// Converter لحفظ الـ enum في DB كـ int
class EquipmentStatusConverter extends TypeConverter<EquipmentStatus, int> {
  const EquipmentStatusConverter();

  @override
  EquipmentStatus fromSql(int fromDb) =>
      EquipmentStatus.values[fromDb];

  @override
  int toSql(EquipmentStatus value) => value.index;
}

class Equipment extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get assetCode =>
      text().withLength(min: 1, max: 50)(); // رقم الجرد

  TextColumn get type =>
      text().withLength(min: 1, max: 50)();

  TextColumn get model =>
      text().withLength(min: 0, max: 100)();

  TextColumn get serial =>
      text().withLength(min: 0, max: 100)();

  TextColumn get department =>
      text().withLength(min: 1, max: 100)();

  TextColumn get office =>
      text().withLength(min: 1, max: 100)();

  IntColumn get status => integer().map(const EquipmentStatusConverter())();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {assetCode}, // assetCode لازم يكون فريد
  ];

  List<Index> get indexes => [
    Index(
      'idx_equipment_status',
      'CREATE INDEX idx_equipment_status ON equipment(status)',
    ),
    Index(
      'idx_equipment_department',
      'CREATE INDEX idx_equipment_department ON equipment(department)',
    ),
    Index(
      'idx_equipment_office',
      'CREATE INDEX idx_equipment_office ON equipment(office)',
    ),
    Index(
      'idx_equipment_type',
      'CREATE INDEX idx_equipment_type ON equipment("type")',
    ),
    Index(
      'idx_equipment_serial',
      'CREATE INDEX idx_equipment_serial ON equipment(serial)',
    ),
  ];

}

class EquipmentHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get equipmentId =>
      integer().references(Equipment, #id)();

  DateTimeColumn get changedAt =>
      dateTime().withDefault(currentDateAndTime)();

  IntColumn get oldStatus =>
      integer().nullable().map(const EquipmentStatusConverter())();

  IntColumn get newStatus =>
      integer().nullable().map(const EquipmentStatusConverter())();

  TextColumn get comment =>
      text().withLength(min: 0, max: 500).nullable()();

  // نوع التغيير (مفيد لاحقًا)
  TextColumn get changeType =>
      text().withLength(min: 1, max: 50).withDefault(const Constant('StatusChange'))();
}
