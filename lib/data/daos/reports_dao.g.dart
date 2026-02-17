// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EquipmentTable get equipment => attachedDatabase.equipment;
  $EquipmentHistoryTable get equipmentHistory =>
      attachedDatabase.equipmentHistory;
  ReportsDaoManager get managers => ReportsDaoManager(this);
}

class ReportsDaoManager {
  final _$ReportsDaoMixin _db;
  ReportsDaoManager(this._db);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db.attachedDatabase, _db.equipment);
  $$EquipmentHistoryTableTableManager get equipmentHistory =>
      $$EquipmentHistoryTableTableManager(
        _db.attachedDatabase,
        _db.equipmentHistory,
      );
}
