// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_dao.dart';

// ignore_for_file: type=lint
mixin _$EquipmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $EquipmentTable get equipment => attachedDatabase.equipment;
  $EquipmentHistoryTable get equipmentHistory =>
      attachedDatabase.equipmentHistory;
  EquipmentDaoManager get managers => EquipmentDaoManager(this);
}

class EquipmentDaoManager {
  final _$EquipmentDaoMixin _db;
  EquipmentDaoManager(this._db);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db.attachedDatabase, _db.equipment);
  $$EquipmentHistoryTableTableManager get equipmentHistory =>
      $$EquipmentHistoryTableTableManager(
        _db.attachedDatabase,
        _db.equipmentHistory,
      );
}
