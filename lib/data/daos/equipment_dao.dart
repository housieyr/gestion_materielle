import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'equipment_dao.g.dart';

class EquipmentFilter {
  final String? department;
  final String? office;
  final String? type; final String? model;
  final EquipmentStatus? status;
  final String? search; // assetCode / serial / model

  const EquipmentFilter({
    this.department,
    this.office,
    this.type,this.model,
    this.status,
    this.search,
  });
}

@DriftAccessor(tables: [Equipment, EquipmentHistory])
class EquipmentDao extends DatabaseAccessor<AppDatabase>
    with _$EquipmentDaoMixin {
  EquipmentDao(super.db);

  // إضافة معدّة
  Future<int> addEquipment(EquipmentCompanion entry) {
    return into(equipment).insert(entry);
  }

  // تحديث بيانات معدّة (بدون الحالة)
  Future<bool> updateEquipmentRow(EquipmentData row) {
    return update(equipment).replace(row);
  }

  Future<int> deleteEquipmentById(int id) {
    return (delete(equipment)..where((t) => t.id.equals(id))).go();
  }

  // ====== Query أساسية للفلاتر + البحث ======
  Stream<List<EquipmentData>> watchEquipment({
    required EquipmentFilter filter,
    int limit = 200,
    int offset = 0,
  }) {
    final q = select(equipment);

    if (filter.department != null && filter.department!.trim().isNotEmpty) {
      q.where((t) => t.department.equals(filter.department!.trim()));
    }
    if (filter.office != null && filter.office!.trim().isNotEmpty) {
      q.where((t) => t.office.equals(filter.office!.trim()));
    }
    if (filter.type != null && filter.type!.trim().isNotEmpty) {
      q.where((t) => t.type.equals(filter.type!.trim()));
    } if (filter.model != null && filter.model!.trim().isNotEmpty) {
      q.where((t) => t.model.equals(filter.model!.trim()));
    }
    if (filter.status != null) {
      q.where((t) => t.status.equals(filter.status!  .index));
    }
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      final s = '%${filter.search!.trim()}%';
      q.where((t) =>
      t.assetCode.like(s) | t.serial.like(s) | t.model.like(s));
    }

    q.orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]);
    q.limit(limit, offset: offset);

    return q.watch();
  }
  Future<List<String>> getDistinctDepartmentsFiltered({
    String? office,
    String? type,String? model,
  }) async {
    final query = selectOnly(equipment, distinct: true)
      ..addColumns([equipment.department]);

    if (office != null) {
      query.where(equipment.office.equals(office));
    }
    if (type != null) {
      query.where(equipment.type.equals(type));
    }
 if (model != null) {
      query.where(equipment.model.equals(model));
    }
    final rows = await query.get();
    return rows.map((r) => r.read(equipment.department)!).toList();
  }

  Future<List<String>> getDistinctTypesFiltered({
    String? office,
    String? department,   String? model,
  }) async {
    final query = selectOnly(equipment, distinct: true)
      ..addColumns([equipment.type]);

    if (office != null) {
      query.where(equipment.office.equals(office));
    }
    if (department != null) {
      query.where(equipment.department.equals(department));
    }
  if (model != null) {
      query.where(equipment.model.equals(model));
    }
    final rows = await query.get();
    return rows.map((r) => r.read(equipment.type)!).toList();
  }

  Future<List<String>> getDistinctModelsFiltered({
    String? type,
    String? department,String? office,
  }) async {
    final query = selectOnly(equipment, distinct: true)
      ..addColumns([equipment.model]);

    if (type != null) {
      query.where(equipment.type.equals(type));
    }
    if (department != null) {
      query.where(equipment.department.equals(department));
    }
   if (office != null) {
      query.where(equipment.office.equals(office));
    }
    final rows = await query.get();
    return rows
        .map((r) => r.read(equipment.model)!)
        .where((s) => s.trim().isNotEmpty)
        .toList();
  }

  Future<List<String>> getDistinctOfficesFiltered({
    String? department,
    String? type, String? model,
  }) async {
    final query = selectOnly(equipment, distinct: true)
      ..addColumns([equipment.office]);

    if (department != null) {
      query.where(equipment.department.equals(department));
    }
    if (type != null) {
      query.where(equipment.type.equals(type));
    }
    if (model != null) {
      query.where(equipment.model.equals(model));
    }
    final rows = await query.get();
    return rows.map((r) => r.read(equipment.office)!).toList();
  }
  // ====== تغيير الحالة + تسجيل History تلقائيًا ======
  Future<void> changeStatus({
    required int equipmentId,
    required EquipmentStatus newStatus,
    String? comment,
  }) async {
    await transaction(() async {
      final current = await (select(equipment)
        ..where((t) => t.id.equals(equipmentId)))
          .getSingle();

      if (current.status == newStatus) return;

      await (update(equipment)..where((t) => t.id.equals(equipmentId))).write(
        EquipmentCompanion(status: Value(newStatus)),
      );

      await into(equipmentHistory).insert(
        EquipmentHistoryCompanion.insert(
          equipmentId: equipmentId,
          oldStatus: Value(current.status),
          newStatus: Value(newStatus),
          comment: Value(comment),
          changeType: const Value('StatusChange'),
        ),
      );
    });
  }
// داخل EquipmentDao
  Future<List<String>> getDistinctDepartments() async {
    final q = selectOnly(equipment)
      ..addColumns([equipment.department])
      ..groupBy([equipment.department])
      ..orderBy([OrderingTerm(expression: equipment.department)]);
    final rows = await q.get();
    return rows.map((r) => r.read(equipment.department)!).where((s) => s.trim().isNotEmpty).toList();
  }

  Future<List<String>> getDistinctTypes() async {
    final q = selectOnly(equipment)
      ..addColumns([equipment.type])
      ..groupBy([equipment.type])
      ..orderBy([OrderingTerm(expression: equipment.type)]);
    final rows = await q.get();
    return rows.map((r) => r.read(equipment.type)!).where((s) => s.trim().isNotEmpty).toList();
  }

  Future<List<String>> getDistinctOffices() async {
    final q = selectOnly(equipment)
      ..addColumns([equipment.office])
      ..groupBy([equipment.office])
      ..orderBy([OrderingTerm(expression: equipment.office)]);
    final rows = await q.get();
    return rows.map((r) => r.read(equipment.office)!).where((s) => s.trim().isNotEmpty).toList();
  }

  Future<int> countEquipment(EquipmentFilter filter) async {
    final q = selectOnly(equipment)..addColumns([equipment.id.count()]);

    if (filter.department != null && filter.department!.trim().isNotEmpty) {
      q.where(equipment.department.equals(filter.department!.trim()));
    }
    if (filter.office != null && filter.office!.trim().isNotEmpty) {
      q.where(equipment.office.equals(filter.office!.trim()));
    }
    if (filter.type != null && filter.type!.trim().isNotEmpty) {
      q.where(equipment.type.equals(filter.type!.trim()));
    }    if (filter.model != null && filter.model!.trim().isNotEmpty) {
      q.where(equipment.model.equals(filter.model!.trim()));
    }
    if (filter.status != null) {
      q.where(equipment.status.equals(filter.status! .index));
    }
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      final s = '%${filter.search!.trim()}%';
      q.where(equipment.assetCode.like(s) |
      equipment.serial.like(s) |
      equipment.model.like(s));
    }

    final row = await q.getSingle();
    return row.read(equipment.id.count()) ?? 0;
  }

  Future<List<EquipmentData>> fetchEquipmentForPrint({
    required EquipmentFilter filter,
    String sortColumn = 'id',
    bool sortAsc = false,
  }) async {
    final q = select(equipment);

    if (filter.department != null && filter.department!.trim().isNotEmpty) {
      q.where((t) => t.department.equals(filter.department!.trim()));
    }
    if (filter.office != null && filter.office!.trim().isNotEmpty) {
      q.where((t) => t.office.equals(filter.office!.trim()));
    }
    if (filter.type != null && filter.type!.trim().isNotEmpty) {
      q.where((t) => t.type.equals(filter.type!.trim()));
    }
    if (filter.model != null && filter.model!.trim().isNotEmpty) {
      q.where((t) => t.model.equals(filter.model!.trim()));
    }
    if (filter.status != null) {
      q.where((t) => t.status.equals(filter.status!.index));
    }
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      final s = '%${filter.search!.trim()}%';
      q.where((t) => t.assetCode.like(s) | t.serial.like(s) | t.model.like(s));
    }

    OrderingTerm order;
    switch (sortColumn) {
      case 'assetCode':
        order = OrderingTerm(expression: equipment.assetCode, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'type':
        order = OrderingTerm(expression: equipment.type, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'department':
        order = OrderingTerm(expression: equipment.department, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'office':
        order = OrderingTerm(expression: equipment.office, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'status':
        order = OrderingTerm(expression: equipment.status, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      default:
        order = OrderingTerm(expression: equipment.id, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
    }

    q.orderBy([(_) => order]);
    return q.get();
  }

  Future<List<EquipmentData>> fetchEquipmentPage({
    required EquipmentFilter filter,
    required int pageIndex,
    required int pageSize,
    String sortColumn = 'id',
    bool sortAsc = false,
  }) async {
    final q = select(equipment);

    // Filters
    if (filter.department != null && filter.department!.trim().isNotEmpty) {
      q.where((t) => t.department.equals(filter.department!.trim()));
    }
    if (filter.office != null && filter.office!.trim().isNotEmpty) {
      q.where((t) => t.office.equals(filter.office!.trim()));
    }
    if (filter.type != null && filter.type!.trim().isNotEmpty) {
      q.where((t) => t.type.equals(filter.type!.trim()));
    }if (filter.model != null && filter.model!.trim().isNotEmpty) {
      q.where((t) => t.model.equals(filter.model!.trim()));
    }
    if (filter.status != null) {
      q.where((t) => t.status.equals(filter.status! .index));
    }
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      final s = '%${filter.search!.trim()}%';
      q.where((t) => t.assetCode.like(s) | t.serial.like(s) | t.model.like(s));
    }

    // Sorting (بسيطة كبداية)
    OrderingTerm order;
    switch (sortColumn) {
      case 'assetCode':
        order = OrderingTerm(expression: equipment.assetCode, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'type':
        order = OrderingTerm(expression: equipment.type, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'department':
        order = OrderingTerm(expression: equipment.department, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'office':
        order = OrderingTerm(expression: equipment.office, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      case 'status':
        order = OrderingTerm(expression: equipment.status, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
        break;
      default:
        order = OrderingTerm(expression: equipment.id, mode: sortAsc ? OrderingMode.asc : OrderingMode.desc);
    }
    q.orderBy([(_) => order]);

    q.limit(pageSize, offset: pageIndex * pageSize);
    return q.get();
  }

  // سجل معدّة واحدة
  Stream<List<EquipmentHistoryData>> watchHistory(int equipmentId) {
    final q = (select(equipmentHistory)
      ..where((h) => h.equipmentId.equals(equipmentId))
      ..orderBy([(h) => OrderingTerm(expression: h.changedAt, mode: OrderingMode.desc)]));
    return q.watch();
  }

  // قوائم جاهزة
  Stream<List<EquipmentData>> watchInRepairNow() {
    return (select(equipment)
      ..where((t) => t.status.equals(EquipmentStatus.inRepair .index))
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .watch();
  }

  Stream<List<EquipmentData>> watchOutOfService() {
    return (select(equipment)
      ..where((t) => t.status.equals(EquipmentStatus.outOfService  .index))
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .watch();
  }
}
